function [Command,AirArray]=InitialSetup()
  k=-0.0065; %Temperature decrease factor with height
  directory="INPUT_FILES/INPUT.DAT";
printf("reading INPUT.DAT file...\t");
  AirPTR=fopen(directory,"r");
  if (AirPTR==-1) %chech for access to input file
    printf('Can''t read "INPUT.DAT" file! Terminating script\n');
    Command=sqrt(-1);
    AirArray=Command;
    return
  end
  Stringa=fgetl(AirPTR);
  Command=sscanf(Stringa,"%i");
  Stringa=fgetl(AirPTR);
  Height=sscanf(Stringa,"%f");
  Stringa=fgetl(AirPTR);
  T0=sscanf(Stringa,"%f");
  Stringa=fgetl(AirPTR);
  p0=sscanf(Stringa,"%f");
  Stringa=fgetl(AirPTR);
  rho0=sscanf(Stringa,"%f");
  Stringa=fgetl(AirPTR);
  Mach=sscanf(Stringa,"%f");
  Stringa=fgetl(AirPTR);
  Alpha=sscanf(Stringa,"%f");
  Alpha=deg2rad(Alpha);
	Stringa=fgetl(AirPTR);
  Alpha_min=sscanf(Stringa,"%f");
  Alpha_min=deg2rad(Alpha_min);
	Stringa=fgetl(AirPTR);
  Alpha_max=sscanf(Stringa,"%f");
  Alpha_max=deg2rad(Alpha_max);
	Stringa=fgetl(AirPTR);
  Alpha_step=sscanf(Stringa,"%f");
  Alpha_step=deg2rad(Alpha_step);
  fclose(AirPTR);
  if (Height<0)
    AirArray=[T0,p0,rho0,...
    1.46e-6*(T0^1.5)/(110+T0),...
    Mach,Alpha,Alpha_min,Alpha_max,Alpha_step]';
  else
    AirArray(1)=T0-k*Height;
    AirArray(2)=p0*(AirArray(1)/T0)^5.2561;
    AirArray(3)=rho0*(AirArray(1)/T0)^4.2561;
    AirArray(4)=1.46e-6*(AirArray(1)^1.5)/(110+AirArray(1));
    AirArray(5)=Mach;
    AirArray(6)=Alpha;
		AirArray(7)=Alpha_min;
		AirArray(8)=Alpha_max;
		AirArray(9)=Alpha_step;
		AirArray=AirArray';
  endif
printf("OK\n\n");
endfunction