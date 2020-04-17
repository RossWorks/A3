function done = Graphs101(CoeffMatrix)
figure()
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
xlabel("X - longitudinal axis [m]","fontsize",14)
ylabel("Y - lateral axis [m]","fontsize",14);
zlabel("Z - vertical axis [m]","fontsize",14);
axis("equal")
title_obj=title("Analysis 101 graphical report");
legend_obj=legend("Lifting Line","location","south");
set(legend_obj,"fontsize",14);
set(title_obj,"fontsize",14);
done=0;
endfunction