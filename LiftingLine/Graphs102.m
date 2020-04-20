function done = Graphs102 (AeroVector,AoAs)
figure(1)
hold on
subplot(2,2,1)
plot(rad2deg(AoAs),AeroVector(:,1),rad2deg(AoAs),AeroVector(:,2))
title("c_L and c_D vs alpha")
xlabel("alpha [°]")
ylabel("c_L , c_D")
legend("c_L","c_D")
grid on
subplot(2,2,2)
plot(rad2deg(AoAs),AeroVector(:,3),'g')
[~,best_alpha_index]=max(AeroVector(:,3));
title2=sprintf("max. efficiency @ %.2f degrees of incidence",rad2deg(AoAs(best_alpha_index)));
title(title2)
xlabel("alpha [°]")
ylabel("Efficiency")
grid on
subplot(2,2,3)
plot(AeroVector(:,2),AeroVector(:,1))
title("Complete wing polar")
xlabel("c_D")
ylabel("c_L")
grid on
endfunction