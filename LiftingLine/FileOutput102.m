function done = FileOutput102 (AeroVector,AoAs)
dir="OUTPUT_FILES/REPORT_102.DAT";
FID102=fopen(dir,"w");
if (FID102==-1)
	printf("\nError while opening REPORT_102.DAT for output. Terminating script...\n");
	return
endif
fprintf(FID102,"Begin of Aerodynamic analysis 102 report file\n");
fprintf(FID102,"Incidence\tLift\tDrag\tEfficiency\n");
dlmwrite(FID102,[AoAs AeroVector],"\t","precision","%+.16E");
fprintf(FID102,"End of report file");
endfunction