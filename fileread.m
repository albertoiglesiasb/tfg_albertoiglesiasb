clear;
clc;

file_air = 'NACA4412.txt';
fileID = fopen(file_air,"r");

NACA = textscan(fileID,'%f %f','CollectOutput',1,'Delimiter','','HeaderLines',0);

fclose(fileID);

AoA = 5;
Re = 1e6;
Mach = 0.3;

Airfoil(:,1) = NACA{1} (:,1);
Airfoil(:,2) = NACA{1} (:,2);

[perfil,data] = xfoil(Airfoil,AoA,Re,Mach);

% Separar airfoil en (U)pper and (L)ower
XB_U = data.x (data.y >= 0 & data.x <=1);
XB_L = data.x (data.y <= 0  & data.x <=1);
YB_U = data.y (data.y >= 0 & data.x <=1) ;
YB_L = data.y (data.y <= 0  & data.x <=1);

% Pintar: Airfoil
figure (1);
cla; hold on; grid off;
set(gcf, 'Color', 'White');
set(gca, 'FontSize',12);
plot (XB_U, YB_U, 'b.-');
plot (XB_L, YB_L, 'r.-');
xlabel ('X Coordinate');
ylabel ('Y Coordinate');
axis equal;

% Separar resultados Xfoil en (U)pper and (L)ower
Cp_U = data.cp(data.y >= 0 & data.x <=1);
Cp_L = data.cp(data.y <= 0  & data.x <=1);
X_U  = data.xcp(data.y >= 0 & data.x <=1);
X_L  = data.xcp(data.y <= 0  & data.x <=1);

% Pintar: Cp
figure (2);
cla; hold on; grid on;
set(gcf, 'Color', 'White');
set(gca, 'FontSize',12);
plot (X_U, -Cp_U, 'b.-');
plot (X_L, -Cp_L, 'r.-');
xlabel ('X Coordinate');
ylabel ('- Cp');