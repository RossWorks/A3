clear all
close all
clc
format long

addpath(genpath(pwd));

SplashScreen();
[Job,AirVector]=InitialSetup();

switch (Job)
case 101
	A101();
case 102
	A102();
otherwise
	printf("\tFailed to aquire initialisation data. Terminating script\n");
endswitch
%% clean up mess
fclose("all");
restoredefaultpath();
clear all
format short