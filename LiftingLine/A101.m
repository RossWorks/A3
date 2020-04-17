printf("Initiating Analysis 101\n\n");
printf('Reading 1D_WING_GEOMETRY.DAT...\t');
[Object,B_matrix]=WingBuild1;
if (Object==sqrt(-1))
	printf("\tFailed to aquire wing data. Terminating script\n");
	return
endif
printf("OK\n");
printf("Calculating Prandtl lifting line...\t");
[AeroArray,CoeffMatrix]=LiftingLine(Object,AirVector,B_matrix);
printf("OK\n");
printf("Saving report file...\t");
FileOutput101(AirVector,AeroArray,CoeffMatrix);
printf("OK\n");
printf("Elaborating graphical report...\t")
Graphs101(CoeffMatrix);
printf("OK\n");
printf("\nAnalysis 101 completed\n");