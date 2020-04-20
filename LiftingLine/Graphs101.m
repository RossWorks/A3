function done = Graphs101(CoeffMatrix)
figure(1)
cL_index=17; cD_index=21;
%plot(CoeffMatrix(:,2),CoeffMatrix(:,17),'g'); %cL
%hold on
%grid on
%plot(CoeffMatrix(:,2),CoeffMatrix(:,18),'--b');  %Cd0
%plot(CoeffMatrix(:,2),CoeffMatrix(:,19),'--y'); %cDi
%plot(CoeffMatrix(:,2),CoeffMatrix(:,20),'--m'); %cDw
%plot(CoeffMatrix(:,2),CoeffMatrix(:,21),'r'); %cD
%xlabel("y [m]")
%text_legend={"c_L" "c_D_0" "c_D_i" "c_D_w" "c_D"};
%legend(text_legend)
%title("Coefficients evolution")
plot3(CoeffMatrix(:,1),CoeffMatrix(:,2),CoeffMatrix(:,3),'-o')
grid on
hold on
xlabel("X - longitudinal axis [m]","fontsize",14)
ylabel("Y - lateral axis [m]","fontsize",14);
zlabel("Z - vertical axis [m]","fontsize",14);
axis("equal")
Limits=axis();
cL_max=max(CoeffMatrix(:,cL_index));
scaled_cL=(1/cL_max)*CoeffMatrix(:,cL_index)*Limits(2);
scaled_cD=(1/cL_max)*CoeffMatrix(:,cD_index)*Limits(2);
for i=1:1:length(scaled_cL)
	plot3([CoeffMatrix(i,1) CoeffMatrix(i,1)],[CoeffMatrix(i,2) CoeffMatrix(i,2)],[CoeffMatrix(i,3) CoeffMatrix(i,3)+scaled_cL(i)],'g')
	plot3([CoeffMatrix(i,1) CoeffMatrix(i,1)+scaled_cD(i)],[CoeffMatrix(i,2) CoeffMatrix(i,2)],[CoeffMatrix(i,3) CoeffMatrix(i,3)],'r')
endfor
axis("equal")
title_obj=title("Analysis 101 graphical report");
legend_obj=legend({"Lifting Line","Lift","Drag"},"location","south","orientation","horizontal");
set(legend_obj,"fontsize",14);
set(title_obj,"fontsize",14);
done=0;
endfunction