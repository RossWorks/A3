function [OUTPUT,PLL_matrix]=WingBuild1()
WingPTR=fopen("INPUT_FILES/1D_WING_GEOMETRY.DAT",'r'); %pointer to wing.dat file
%% Check to verify that file is available
if (WingPTR==-1)
  printf('Can''t read "WING_GEOMETRY.DAT" file!\n');
  OUTPUT=sqrt(-1); %imaginary unit as error marker
	PLL_matrix=OUTPUT;
  return %if file not available, terminate script
endif

%% FILE INPUT SECTION
%global characteristics valid for the whole wing
Stringa=fgetl(WingPTR);
Nodes=sscanf(Stringa,'%i');
Stringa=fgetl(WingPTR);
Sections=sscanf(Stringa,'%i');
Stringa=fgetl(WingPTR);
N_airfoils=sscanf(Stringa,'%i');
Stringa=fgetl(WingPTR);
WingSpan=sscanf(Stringa,'%f');
AccessoryData=WingSpan;
Stringa=fgetl(WingPTR);
FuselageDiameter=sscanf(Stringa,"%f");

%Arrays for storing the formulas and section caractheristics
ChordPolys=zeros(Sections,4);
Sweep=zeros(Sections,1);
TwistPolys=zeros(Sections,4);
Diedral=zeros(Sections,1);
Airfoil=zeros(Sections,9);
Sections_end=zeros(Sections,1);
AirfoilData=zeros(N_airfoils,9);

%reading WING.DAT for wing formulas
for i=1:Sections
  Stringa=fgetl(WingPTR);
  ChordPolys(i,:)=sscanf(Stringa,"%f %f %f %f");
  Stringa=fgetl(WingPTR);
  Sweep(i)=sscanf(Stringa,"%f");
  Stringa=fgetl(WingPTR);
  TwistPolys(i,:)=sscanf(Stringa,"%f %f %f %f");
  Stringa=fgetl(WingPTR);
  Diedral(i)=sscanf(Stringa,"%f");
  Stringa=fgetl(WingPTR);
  AFI=sscanf(Stringa,"%i");
  [Airfoil(i,:),~]=airfoilRead(AFI);
  if (Airfoil(i,:)==-1)
    printf('Can''t read Airfoil file! Terminating script\n');
    Wing=sqrt(-1); %imaginary unit as error marker
    return
  endif
  Stringa=fgetl(WingPTR);
  Sections_end(i)=sscanf(Stringa,"%f");
endfor
fclose(WingPTR);

%%Wing matrix initialization
station_x=1;
station_y=2; %those are index to easily id the wing array cells
station_z=3;
chord_index=4;
twist_index=5;
sweep_index=6;
diedral_index=7;
airfoil_index=8;
cLa_index=8;
N=16;

Wing=zeros(Nodes,N);
%arrays for graphical representation of Wing.
QuarterLine=zeros(Nodes,3);

phi=[1:1:Nodes]'*pi/(Nodes+1);
for i=1:Nodes
  k=-1;
  Wing(i,station_y)=0.5*WingSpan*cos(phi(i));
  progress=abs(Wing(i,station_y)/(WingSpan/2)); %this tells the % of half wingspan the for is at (ex .67)
  for j=1:Sections
    if(progress<=Sections_end(j))
      k=j; %according to current "%" the for cycle selects the correct section data
      break %when found we need to exit the for to avoid overwriting the correct data
    endif
  endfor
  if (k<1) %it means the for-cycle hasn't found a section: that's an ERROR
    printf("\nError while loading wing matrix!\n");
		OUTPUT=sqrt(-1); %imaginary unit as error marker
    return
  endif  
  Wing(i,chord_index)=polyval(ChordPolys(j,:),abs(Wing(i,station_y))); %chord lenght
  Wing(i,twist_index)=deg2rad(polyval(TwistPolys(j,:),abs(Wing(i,station_y)))); %twist
  Wing(i,sweep_index)=deg2rad(Sweep(j)); %ALWAYS m-kg-s UNITS
  Wing(i,diedral_index)=deg2rad(Diedral(j)); %diedral at i node
  Wing(i,airfoil_index:airfoil_index+8)=Airfoil(j,:); %array of airfoil aero data
endfor
%computing Wing Area
WingArea=0;
for i=2:Nodes
	WingArea+=abs(Wing(i,station_y)-Wing(i-1,station_y))*Wing(i,chord_index);
endfor
%other aerogeometrical characteristics
AspectRatio=WingSpan^2/WingArea;
TaperRatio=Wing(end,chord_index)/Wing(1,chord_index);
Mean_Aero_Chord=Wing(idivide(Nodes,2),chord_index)*(2/3)*(1+TaperRatio+TaperRatio^2)/(1+TaperRatio);

%computing Wing B matrix for PLL calculation (once for every wing)
PLL_matrix=zeros(Nodes);

for j=1:Nodes
	for n=1:Nodes %columns
		%theta=acos(Wing(j,station_y)/(WingSpan/2)); %angle coordinate for every station
		theta=phi(j);
		PLL_matrix(j,n)=sin(n*theta)*(sin(theta)+(n*Wing(n,cLa_index)*Wing(n,chord_index)/(4*WingSpan)));
	endfor
endfor

%computing stations x and z coordinates for graphs
odd_even=mod(Nodes,2); %two ways to obtain x and z if nodes are odd or even
halfNodes=idivide(Nodes,2,"ceil"); %half of nodes, rounded up toward +infinity
if (odd_even==1) %if we have odd stations, the middle station is placed in the origin
	for i=0:halfNodes-1
		if(i==0)
			Wing(halfNodes-i,station_x)=0;
			Wing(halfNodes-i,station_z)=0;
		else
			delta_y=abs(Wing(halfNodes-i,station_y)-Wing(halfNodes-i+1,station_y));
			Wing(halfNodes-i,station_x)=Wing(halfNodes-i+1,station_x)+delta_y*sin(Wing(halfNodes-i,sweep_index));
			Wing(halfNodes+i,station_x)=Wing(halfNodes-i,station_x);
			Wing(halfNodes-i,station_z)=Wing(halfNodes-i+1,station_z)+delta_y*sin(Wing(halfNodes-i,diedral_index));
			Wing(halfNodes+i,station_z)=Wing(halfNodes-i,station_z);
		endif
	endfor
else
%in case of even stations, we miss a central station in the origin
%we have to impose the origin as the "previous station"
%afterwards we proceed as usual
%pay attention to the fact that we miss a "central" station
	for i=0:halfNodes-1
		if(i==0)
			delta_y=abs(Wing(halfNodes-i,station_y));
			Wing(halfNodes-i,station_x)=delta_y*sin(Wing(halfNodes-i,sweep_index));
			Wing(halfNodes+i+1,station_x)=Wing(halfNodes-i,station_x);
			Wing(halfNodes-i,station_z)=delta_y*sin(Wing(halfNodes-i,diedral_index));
			Wing(halfNodes+i+1,station_z)=Wing(halfNodes-i,station_z);
		else
			delta_y=abs(Wing(halfNodes-i,station_y)-Wing(halfNodes-i+1,station_y));
			Wing(halfNodes-i,station_x)=Wing(halfNodes-i+1,station_x)+delta_y*sin(Wing(halfNodes-i,sweep_index));
			Wing(halfNodes+i+1,station_x)=Wing(halfNodes-i,station_x);
			Wing(halfNodes-i,station_z)=Wing(halfNodes-i+1,station_z)+delta_y*sin(Wing(halfNodes-i,diedral_index));
			Wing(halfNodes+i+1,station_z)=Wing(halfNodes-i,station_z);
		endif
	endfor
endif
Wing(:,station_x)+=Wing(:,chord_index)/4;

OUTPUT=[Wing];
%Saving Wing matrix to file
%printf("Saving wing matrix...\t");
%WingPTR=fopen("OUTPUT_FILES/WING.DAT","w");
%if (WingPTR<2) %up to file Pointer 2 there are stdin, stdout and stderr
%  printf("\nError while opening WING.DAT for output. Terminating script...\n");
%  Wing=sqrt(-1); %as usual the imaginary unit tells "ERROR"
%  return
%endif
%Stringa=sprintf("Wing report file\n\n");
%fprintf(WingPTR,Stringa);
%Stringa=sprintf("Wing is divided in %i sections\nThe aerodynamic mesh is made of %i nodes\n",Sections,Nodes);
%fprintf(WingPTR,Stringa);
%Stringa=sprintf("%i airfoils have been loaded\nWing span is %g m\nThe fuselage shadows %g m of total wing span\n",N_airfoils,WingSpan,FuselageDiameter);
%fprintf(WingPTR,Stringa);
%Stringa=sprintf("Wing Area [m^2]:\t%+.16E\tAspect ratio:\t%f\tTaper ratio:\t%f\n",WingArea,AspectRatio,TaperRatio);
%fprintf(WingPTR,Stringa);
%fprintf(WingPTR,"\n\nWing matrix:\n\n");
%%that's a quite long string, may consider to split it up for readability [UPDATE] NAHHHHHH
%Stringa=sprintf("Root distance [m]\tChord [m]\tTwist angle [rad]\tSweep angle [rad]\tDiedral [rad]\tcLa\tcL0\tcDcL3\tcDcL2\tcDcL1\tcDcL0\talphaZeroLift[rad]\tthickness\tsupercritical\n");
%fprintf(WingPTR,Stringa);
%dlmwrite(WingPTR,Wing,"\t",'append','on','precision','%+.16E'); %16 digits looks reasonable to store data
%fprintf(WingPTR,"End of wing file"); %to confirm that all data have been written
%fclose(WingPTR);
%printf("OK\n\n");

endfunction