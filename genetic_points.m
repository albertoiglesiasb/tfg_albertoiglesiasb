%% Inicialización del algoritmo
clear
% Define la ruta de la carpeta predefinidos
Cfg.predefined_dir = 'Predefinidos';
if ~exist(Cfg.predefined_dir, 'dir')
        mkdir(Cfg.predefined_dir);
end

% Define la ruta de la carpeta banco de perfiles
Cfg.library_dir = 'profilsw';
if ~exist(Cfg.library_dir, 'dir')
        mkdir(Cfg.library_dir);
end

% Parámetros de la población
Cfg.NUM_POP = 50; % Cantidad de población inicial
Cfg.NUM_POINTS = 50; % Número de puntos
Cfg.NUMBER_ITERATIONS = 50;
Cfg.NUM_AIRFOIL_LIBRARY = round(0.4*Cfg.NUM_POP);
Cfg.NUMBER_PARENTS = 0.4*(Cfg.NUM_POP);
Cfg.LAST_ID = 1;

% Parámetros del algoritmo
Cfg.AoA = -5:1:10;
Cfg.Re = 1.944e6;
Cfg.Mach = 0.455;

% Parámetros puntuación
Cfg.CL_target = 0.867;

Cfg.PERCENT_CROSS_1 = rand;
Cfg.PERCENT_CROSS_2 = rand;
Cfg.PROB_MUTATION_X = 0.8;
Cfg.PROB_MUTATION_Z = 0.8;
Cfg.WIDTH_MUTATION_X = 0.1;
Cfg.WIDTH_MUTATION_Z = 0.2;

Cfg.log_file = fopen('logfile.txt', 'w'); 

% Deshabilitar todas las advertencias
warning('off', 'all');

%% Algoritmo genético

[population, Cfg] = Gen_algorithm(Cfg);

warning('on', 'all');

