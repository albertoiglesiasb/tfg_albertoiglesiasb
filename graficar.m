% Configuración de colores y leyendas
colors = ["#D95319", "#77AC30", "#7E2F8E", "#A2142F"]; % Colores para "Best round"
blackColor = [0, 0, 0]; % Color negro para NACA 34108
grayColor = [0.5, 0.5, 0.5]; % Color gris para NACA 4708
legendLabels = {}; % Inicializar etiquetas para la leyenda

% Cargar y graficar los perfiles iniciales
predefinedFolder = 'Predefinidos';
airfoil1Path = fullfile(predefinedFolder, 'airfoil_1.mat');
airfoil2Path = fullfile(predefinedFolder, 'airfoil_2.mat');

% 1. Figura de los perfiles aerodinámicos

% Crear la figura para los perfiles aerodinámicos
fig_width = 10;
fig_height = 4;
figure('Units', 'inches', 'Position', [1, 1, fig_width, fig_height]);
hold on;

% Cargar y graficar los perfiles iniciales con línea de puntos
if exist(airfoil1Path, 'file')
    load(airfoil1Path);
    plot([flip(member.x_upper), member.x_lower], [flip(member.z_upper), member.z_lower], ':', 'Color', blackColor, 'LineWidth', 1.5);
    legendLabels{end+1} = 'NACA 34108 (Initial)';
end
if exist(airfoil2Path, 'file')
    load(airfoil2Path);
    plot([flip(member.x_upper), member.x_lower], [flip(member.z_upper), member.z_lower], ':', 'Color', grayColor, 'LineWidth', 1.5);
    legendLabels{end+1} = 'NACA 4708 (Initial)';
end

% Encontrar el mejor perfil
folders = dir('50p 50g*');
numFolders = length(folders);
bestE_target = -Inf;
bestMember = struct();
bestIndex = 0;

for i = 1:numFolders
    folderName = folders(i).name;
    dataPath = fullfile(folderName, 'airfoil_best.mat');
    
    if exist(dataPath, 'file')
        load(dataPath);
        
        if isfield(member, 'E_target') && member.E_target > bestE_target
            bestE_target = member.E_target;
            bestMember = member;
            bestIndex = i;
        end
    end
end

% Graficar los perfiles excepto el mejor
for i = 1:numFolders
    if i == bestIndex
        continue; % Saltar el mejor perfil
    end
    
    folderName = folders(i).name;
    dataPath = fullfile(folderName, 'airfoil_best.mat');
    
    if exist(dataPath, 'file')
        load(dataPath);
        color = colors(mod(i-1, length(colors)) + 1);

        % Graficar perfil con línea de guiones
        plot([flip(member.x_upper), member.x_lower], [flip(member.z_upper), member.z_lower], '--', 'Color', color, 'LineWidth', 1.5);
        legendLabels{end+1} = sprintf('Best round %d', i);
    end
end

% Graficar el mejor perfil con línea continua y color azul
if ~isempty(bestMember)
    plot([flip(bestMember.x_upper), bestMember.x_lower], [flip(bestMember.z_upper), bestMember.z_lower], '-', 'Color', 'b', 'LineWidth', 1.5);
    legendLabels{end+1} = 'Best airfoil';
end

% Configuración de la gráfica
set(gca, 'XTick', 0:0.1:1, 'FontSize', 10);
xlabel('Chord');
ylabel('Thickness');
grid on;
axis([-0.05, 1.05, -0.2, 0.2]);
legend(legendLabels, 'Location', 'best');
title('Geometry of airfoils (comparison)');
hold off;

% 2. Figura de las polares

% Crear la figura para las polares con subplots
fig_width = 10;
fig_height = 8;
figure('Units', 'inches', 'Position', [1, 1, fig_width, fig_height]);

% Cargar y graficar los perfiles iniciales con línea de puntos en subplots
legendLabels = {}; % Reiniciar etiquetas para la leyenda

if exist(airfoil1Path, 'file')
    load(airfoil1Path);
    subplot(2, 2, 1);
    plot(member.alpha, member.CL, ':', 'Color', blackColor, 'LineWidth', 1.5);
    hold on;
    subplot(2, 2, 2);
    plot(member.alpha, member.CD, ':', 'Color', blackColor, 'LineWidth', 1.5);
    hold on;
    subplot(2, 2, 3);
    plot(member.alpha, member.E, ':', 'Color', blackColor, 'LineWidth', 1.5);
    hold on;
    legendLabels{end+1} = 'NACA 34108 (Initial)';
end

if exist(airfoil2Path, 'file')
    load(airfoil2Path);
    subplot(2, 2, 1);
    plot(member.alpha, member.CL, ':', 'Color', grayColor, 'LineWidth', 1.5);
    subplot(2, 2, 2);
    plot(member.alpha, member.CD, ':', 'Color', grayColor, 'LineWidth', 1.5);
    subplot(2, 2, 3);
    plot(member.alpha, member.E, ':', 'Color', grayColor, 'LineWidth', 1.5);
    hold on;
    legendLabels{end+1} = 'NACA 4708 (Initial)';
end

% Graficar los perfiles excepto el mejor
for i = 1:numFolders
    if i == bestIndex
        continue;
    end
    
    folderName = folders(i).name;
    dataPath = fullfile(folderName, 'airfoil_best.mat');
    
    if exist(dataPath, 'file')
        load(dataPath);
        color = colors(mod(i-1, length(colors)) + 1);

        subplot(2, 2, 1);
        plot(member.alpha, member.CL, '--', 'Color', color, 'LineWidth', 1.5);
        hold on;
        
        subplot(2, 2, 2);
        plot(member.alpha, member.CD, '--', 'Color', color, 'LineWidth', 1.5);
        hold on;
        
        subplot(2, 2, 3);
        plot(member.alpha, member.E, '--', 'Color', color, 'LineWidth', 1.5);
        hold on;
        
        legendLabels{end+1} = sprintf('Best round %d', i);
    end
end

% Graficar el mejor perfil con línea continua y color azul
if ~isempty(bestMember)
    subplot(2, 2, 1);
    plot(bestMember.alpha, bestMember.CL, '-', 'Color', 'b', 'LineWidth', 1.5);
    legendLabels{end+1} = 'Best airfoil';
    
    subplot(2, 2, 2);
    plot(bestMember.alpha, bestMember.CD, '-', 'Color', 'b', 'LineWidth', 1.5);
    
    subplot(2, 2, 3);
    plot(bestMember.alpha, bestMember.E, '-', 'Color', 'b', 'LineWidth', 1.5);
end

% Configuración de los subplots
subplot(2, 2, 1);
xlabel('\alpha');
ylabel('C_l');
grid on;
legend(legendLabels, 'Location', 'best'); % Mover la leyenda al primer subplot

subplot(2, 2, 2);
xlabel('\alpha');
ylabel('C_d');
grid on;

subplot(2, 2, 3);
xlabel('\alpha');
ylabel('C_l / C_d');
grid on;

% Establecer el título común
sgtitle('Polars of airfoils (comparison)');

% Eliminar el cuarto subplot (no es necesario hacer nada aquí)
