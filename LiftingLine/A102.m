printf("Initiating Analysis 102\n\n");
printf('Reading WING_GEOMETRY.DAT...\t');
[Object,B_matrix]=WingBuild1;
if (Object==sqrt(-1))
	printf("\tFailed to aquire wing data. Terminating script\n");
	return
endif
printf("OK\n");
Alphas=AirVector(7):AirVector(9):AirVector(8); %range of incidence to be tested
Alphas=Alphas';
density=length(Alphas);
DummyArray=zeros(12,1); %array to temporarly store Lifitng line resuts
Performance=zeros(density,3);
Lift_index=1; Drag_index=2; Efficiency_index=3;
printf("Calculating %i Prandtl lifting lines...\t",density);
A102Progress=waitbar(0,"Analysis 102 progress");
for i=1:1:density
AirVector(6)=Alphas(i);
[DummyArray,~]=LiftingLine(Object,AirVector,B_matrix);
Performance(i,:)=[DummyArray([2 7 8])];
A102progress=waitbar(i/density);
endfor
delete(A102Progress);
printf("OK\n");
printf("Saving results on disk...\t");
FileOutput102(Performance,Alphas);
printf("OK\n");
printf("Drawing graphical results...\t");
Graphs102(Performance,Alphas);
printf("OK\n");
printf("\nAnalisys 102 Completed\n\n");