function [AirfoilData,AirfoilName]=airfoilRead(Index)
name=1;
filename=strjoin({"INPUT_FILES/AIRFOIL",mat2str(Index),".DAT"},"");
airfoilPTR=fopen(filename,"r");
if (airfoilPTR==-1)
    printf('Can''t read "WING_GEOMETRY.DAT" file!\n');
    AirfoilData=i;
    return
endif
AirfoilName=fgetl(airfoilPTR);
Stringa=fgetl(airfoilPTR);
thickness=sscanf(Stringa,"%f");
Stringa=fgetl(airfoilPTR);
supercritical=sscanf(Stringa,"%f");
Stringa=fgetl(airfoilPTR);
AirfoilMatrix=dlmread(airfoilPTR,"\t");
AirfoilMatrix(:,1)=deg2rad(AirfoilMatrix(:,1));
[cLacL0]=polyfit(AirfoilMatrix(:,1),AirfoilMatrix(:,2),1);
[cDcL]=polyfit(AirfoilMatrix(:,2),AirfoilMatrix(:,3),3);
alphaZeroLift=roots([cLacL0]);
AirfoilData=[cLacL0 cDcL alphaZeroLift thickness supercritical];
fclose(airfoilPTR);
endfunction