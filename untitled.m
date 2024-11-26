population{air} = positions{air};
velocities = cell(Cfg.NUM_POP, 1);
for i = 1:Cfg.NUM_POP
    velocities{i}.x_upper = zeros(1, Cfg.NUM_POINTS); 
    velocities{i}.z_upper = zeros(1, Cfg.NUM_POINTS);                                            
    velocities{i}.x_lower = zeros(1, Cfg.NUM_POINTS);                                            
    velocities{i}.z_lower = zeros(1, Cfg.NUM_POINTS);                                            
end   

figure
hold on

plot(positions{air}.x_upper,positions{air}.z_upper,'LineWidth',1.5,'Color',"#0072BD")
plot(positions{air}.x_lower,positions{air}.z_lower,'LineWidth',1.5,'Color',"#0072BD")

[population{air}.z_upper, velocities{air}.z_upper] = update_coord(population{air}.z_upper, velocities{air}.z_upper, pBest{air}.z_upper, gBest.z_upper, Cfg);
[population{air}.x_upper, velocities{air}.x_upper] = update_coord(population{air}.x_upper, velocities{air}.x_upper, pBest{air}.x_upper, gBest.x_upper, Cfg);       
[population{air}.z_lower, velocities{air}.z_lower] = update_coord(population{air}.z_lower, velocities{air}.z_lower, pBest{air}.z_lower, gBest.z_lower, Cfg);
[population{air}.x_lower, velocities{air}.x_lower] = update_coord(population{air}.x_lower, velocities{air}.x_lower, pBest{air}.x_lower, gBest.x_lower, Cfg);

population{air} = restrictions(population{air}, Cfg);

plot(population{air}.x_upper, population{air}.z_upper, LineWidth=1.5, Color="#77AC30");
plot(population{air}.x_lower, population{air}.z_lower, LineWidth=1.5, Color="#77AC30");

for i = 1:6
    population{air} = smooth_airfoil(population{air}, Cfg);
end

plot(population{air}.x_upper, population{air}.z_upper, LineWidth=1.5, Color="#D95319");
plot(population{air}.x_lower, population{air}.z_lower, LineWidth=1.5, Color="#D95319");



%plot(population{air}.x_upper, population{air}.z_upper, LineWidth=1.5, Color="#A2142F");
%plot(population{air}.x_lower, population{air}.z_lower, LineWidth=1.5, Color="#A2142F");

