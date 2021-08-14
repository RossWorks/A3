function [AeroArray,CoeffMatrix]=LiftingLine(Wing,FlightEnvironment,B)
%%Indexes of wing and Air arrays
  %Wing matrix
	Nodes=length(Wing(:,1));
  station_y=2; chord_index=4; twist_index=5; sweep_index=6; diedral_index=7;
	cLa_index=8; cDcL3_index=10; cDcL0_index=13;
	alpha_ZL_index=14; thickness_index=15;
	supercritical_index=16;
	%FlightEnvironment vector
	T_index=1;p_index=2;rho_index=3;mi_index=4;Mach_index=5;alpha_index=6;

%% Aquiring useful data from the wing matrix
WingSpan=2*(Wing(1,station_y))/cos(pi/(Nodes+1)); %inverse formula: from 1st station we obtain the Wingspan
TaperRatio=Wing(end,chord_index)/Wing(1,chord_index);
Mean_Aero_Chord=Wing(idivide(Nodes,int8(2),"ceil"),chord_index)*(2/3)*(1+TaperRatio+TaperRatio^2)/(1+TaperRatio);
phi=acos(Wing(:,station_y)/(WingSpan/2)); %angle coordinate for every station
V=FlightEnvironment(Mach_index)*sqrt(1.4*287*FlightEnvironment(T_index)); %True Air Speed [m/s]
Reynolds=FlightEnvironment(rho_index)*V*Mean_Aero_Chord/FlightEnvironment(mi_index);
%% Computing characteristics of the finite wing
WingArea=0; %computing Wing Area
for i=2:Nodes
	WingArea+=abs(Wing(i,station_y)-Wing(i-1,station_y))*Wing(i,chord_index);
endfor
AspectRatio=WingSpan^2/WingArea;

%% Setting prandtl line system

%the system is B*A=C
A=zeros(Nodes,1); %unknown vector
B; %coefficients vector (always the same for every wing, not dependant on AoA. obtained as a parameter form WingBuild1.m
C=A; %known terms vector
for j=1:Nodes %rows
	theta=phi(j);
	alpha_zero=Wing(j,alpha_ZL_index);
	alpha_infty=FlightEnvironment(alpha_index);
	alpha_geo=Wing(j,twist_index);
	C(j)=Wing(j,cLa_index)*Wing(j,chord_index)/(4*WingSpan)*sin(theta)*(alpha_infty-alpha_geo-alpha_zero);
endfor
% solution of Pradtl linear system (looks so easy here)
A=B\C;

%% computation of aerodynamic performance
%Vortex cL, cDi, cD0, cDw at each node

Gamma=zeros(Nodes,1);
cL=zeros(Nodes,1);
cD0=zeros(Nodes,1);
cDi=zeros(Nodes,1);
cDw=zeros(Nodes,1);
cD=zeros(Nodes,1);
for i=1:Nodes
	Gamma(i)=2*WingSpan*V*sum(A.*sin([1:Nodes]'*phi(i)));
	cL(i)=2*Gamma(i)/V/Wing(i,chord_index);
	%correction of cL
	cL(i)*=cos(Wing(i,sweep_index)); %sweep angle correction
	cL(i)/=sqrt(abs(1-FlightEnvironment(Mach_index)^2)); %compressibility correction
	cDi(i)=cL(i)*tan(FlightEnvironment(alpha_index)-Wing(i,alpha_ZL_index)-Wing(i,twist_index));
	cD0(i)=polyval(Wing(i,cDcL3_index:cDcL0_index),cL(i));
	cL(i)=cL(i)*cos(Wing(i,diedral_index));
	if(Wing(i:supercritical_index)==1)
    K=0.95;
  else
    K=0.87;
  endif
  Mcrit(i)=K-cL(i)/10-Wing(i,thickness_index)-(0.1/80)^(1/3); %empirical formula for critical mach number
	NormalFlightMach=FlightEnvironment(Mach_index)*cos(Wing(i,sweep_index)); %only the perpendicular component of speed creates wave drag
  if(NormalFlightMach>Mcrit(i))
		cDw(i)=20*(NormalFlightMach-Mcrit(i))^4; %Wave drag
  endif
	cD(i)=cD0(i)+cDi(i)+cDw(i);
endfor
%global lift and drag
cL_tot=0;
cD_tot=0;cDi_tot=0; cDw_tot=0;cD0_tot=0;
Den=0;
for i=2:Nodes
cL_tot+=(cL(i-1)+cL(i))/2*(Wing(i-1,chord_index)+Wing(i,chord_index))/2*abs(Wing(i-1,station_y)-Wing(i,station_y));
cD_tot+=(cD(i-1)+cD(i))/2*(Wing(i-1,chord_index)+Wing(i,chord_index))/2*abs(Wing(i-1,station_y)-Wing(i,station_y));
cDi_tot+=(cDi(i-1)+cDi(i))/2*(Wing(i-1,chord_index)+Wing(i,chord_index))/2*abs(Wing(i-1,station_y)-Wing(i,station_y));
cD0_tot+=(cD0(i-1)+cD0(i))/2*(Wing(i-1,chord_index)+Wing(i,chord_index))/2*abs(Wing(i-1,station_y)-Wing(i,station_y));
cDw_tot+=(cDw(i-1)+cDw(i))/2*(Wing(i-1,chord_index)+Wing(i,chord_index))/2*abs(Wing(i-1,station_y)-Wing(i,station_y));
Den+=(Wing(i-1,chord_index)+Wing(i,chord_index))/2*abs(Wing(i-1,station_y)-Wing(i,station_y));
endfor
cL_tot/=Den;
cD_tot/=Den;
cDi_tot/=Den;
cD0_tot/=Den;
cDw_tot/=Den;
%global Aero performance for whole wing
Lift=.5*FlightEnvironment(rho_index)*V^2*WingArea*cL_tot;
Drag=.5*FlightEnvironment(rho_index)*V^2*WingArea*cD_tot;
Ostwald=cL_tot^2/(cDi_tot*pi*AspectRatio);

%% OUTPUT TO MEMORY
%FlightEnvironment has 6 entries
AeroArray=[Lift;cL_tot;Drag;cD0_tot;cDi_tot;cDw_tot;cD_tot; Lift/Drag;Ostwald;...
					WingArea;AspectRatio;Reynolds];
CoeffMatrix=[Wing cL cD0 cDi cDw cD];
endfunction