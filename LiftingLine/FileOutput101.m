function done = FileOutput101 (AirArray,AeroArray,CoeffMatrix)
%% OUTPUT TO FILE
AeroPTR=fopen("OUTPUT_FILES/REPORT_101.DAT","w");
if (AeroPTR==-1) %if failed to open file...
  printf("\nError while opening REPORT_101.DAT for output. Terminating script...\n");
  done=sqrt(-1); %as usual the imaginary unit tells "ERROR"
  return
endif
fprintf(AeroPTR,"Begin of aerodynamic analysis 101 report file\n");
fprintf(AeroPTR,"Freeflow conditions:\nMach=\t%.3f\nTemperature[K]=\t%g\nPressure[Pa]=\t%g\nDensity[kg/m^3]=\t%g\nAngle of attack[deg]=\t%.3f\n",AirArray(5),AirArray(1),AirArray(2),AirArray(3),rad2deg(AirArray(6)));
fprintf(AeroPTR,"Total Lift[N]:\t%+.16E\n",AeroArray(1));
fprintf(AeroPTR,"Total Drag[N]:\t%+.16E\n",AeroArray(3));
fprintf(AeroPTR,"cL is\t%+.16E\ncD0 is\t%+.16E\ncDi is\t%+.16E\ncDw is\t%+.16E\ncD is\t%+.16E\n",AeroArray(2),AeroArray(4),AeroArray(5),AeroArray(6),AeroArray(7));
fprintf(AeroPTR,"Efficiency:\t%.4f\nOstwald factor:\t%.4f\n",AeroArray(8),AeroArray(9));
fprintf(AeroPTR,"Wing Area[m^2]:\t%.16E\nAspect ratio:\t%.4f\n",AeroArray(10),AeroArray(11));
fprintf(AeroPTR,"Reynolds:\t%.16E\n",AeroArray(12));
fprintf(AeroPTR,"\nX [m]\tY [m]\tZ [m]\tChord [m]\tTwist angle [rad]\tSweep angle [rad]\tDiedral [rad]\tcLa\tcL0\tcDcL3\tcDcL2\tcDcL1\tcDcL0\talphaZeroLift[rad]\tthickness\tsupercritical\tcL\tcD0\tcDi\tcDw\tcD\n");
dlmwrite(AeroPTR,CoeffMatrix,"\t","precision","%+.16E");
fprintf(AeroPTR,"End of aerodynamic report file");
fclose(AeroPTR);
done=0;
endfunction