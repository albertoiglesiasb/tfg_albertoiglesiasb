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
Cfg.NUM_POINTS = 80; % Número de puntos
Cfg.NUMBER_ITERATIONS = 50;
Cfg.NUM_AIRFOIL_LIBRARY = round(0.4*Cfg.NUM_POP);

% Parámetros del algoritmo
Cfg.AoA = -5:1:10;
Cfg.Re = 1.944e6;
Cfg.Mach = 0.455;

Cfg.w = 0.9; % Peso de inercia
Cfg.c1 = 0.95; % Coeficiente de aceleración (componente cognitiva)
Cfg.c2 = 0.95; % Coeficiente de aceleración (componente social)
Cfg.num_smooth_iter = 20;

% Parámetros puntuación  
Cfg.CL_target = 0.867;

Cfg.log_file = fopen('logfile.txt', 'w'); 
current_datetime = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');

% Deshabilitar todas las advertencias
warning('off', 'all');

%% Generar la población inicial
fprintf(Cfg.log_file, 'Inicio de la ejecución del algoritmo genético: %s\n\n', current_datetime);
fprintf( 'Inicio de la ejecución del algoritmo genético: %s\n\n', current_datetime);
fprintf(Cfg.log_file, 'CREACIÓN DE LA POBLACIÓN:\n');
fprintf('CREACIÓN DE LA POBLACIÓN\n');

population = generate_population(Cfg);

if length(population) > Cfg.NUM_POP
    disp('Se procede a cambiar el tamaño de la población.');
    Cfg.NUM_POP = length(population);
end

% Inicializar posiciones y velocidades aleatorias
positions = population;

velocities = cell(Cfg.NUM_POP, 1);

for i = 1:Cfg.NUM_POP
    velocities{i}.x_upper = zeros(1, Cfg.NUM_POINTS); 
    velocities{i}.z_upper = zeros(1, Cfg.NUM_POINTS);                                            
    velocities{i}.x_lower = zeros(1, Cfg.NUM_POINTS);                                            
    velocities{i}.z_lower = zeros(1, Cfg.NUM_POINTS);                                            
end       

% Análisis de la generación inicial
tic
fprintf('REALIZANDO ANÁLISIS INICIAL\n');
population = run_aerodynamic_analysis(population, Cfg);

% Evaluar la función objetivo en las posiciones iniciales
E_target = zeros(Cfg.NUM_POP, 1);
for i = 1:Cfg.NUM_POP
    if ~isempty(population{i}.E_target)
        E_target(i) = population{i}.E_target;
    else
        E_target(i) = 0;
    end
end

% Inicializar pBest y gBest
pBest = population; % La mejor posición que tendrán los perfiles en el inicio será la que se haya generado de momento
pBestE = E_target; % Las mejores eficiencias obtenidas
[gBestE, bestParticleIdx] = max(E_target);
gBest = population{bestParticleIdx}; % Perfil con mejor Score se guardan sus dos coordenadas upper y lower

% Se guardan los datos de la primera generación
for i = 1:length(population)
    plot_geometry(population{i}, false);
    plot_polars(population{i}, false);
end
evolution_plot{1} = [];

%% PSO

for iter = 1:Cfg.NUMBER_ITERATIONS
    disp(['Iteración ', num2str(iter)]);
    fprintf(Cfg.log_file, '\nITERACIÓN %s:\n', num2str(iter));
    fprintf(Cfg.log_file, '\t SITUACIÓN:\n');
    
    for air = 1:Cfg.NUM_POP
        
        % Actualización de coordenadas del perfil
        [population{air}, velocities{air}] = update_airfoil(population{air}, velocities{air}, pBest{air}, gBest, Cfg);

        % Comprobación y modificación del perfil en función de
        % restricciones
        population{air} = restrictions(population{air}, Cfg);

        % Suavizado del perfil varias veces
        for i = 1:Cfg.num_smooth_iter
            population{air} = smooth_airfoil(population{air}, Cfg);
        end

        % Análisis del perfil
        airfoil_analyze = cell(1,1);
        airfoil_analyze{1} = population{air};
        airfoil_analyze = run_aerodynamic_analysis(airfoil_analyze, Cfg);
        population{air} = airfoil_analyze{1};

        % Evaluar función objetivo
        if ~isempty(population{air}.E_target)
            E_target(air) = population{air}.E_target;
        else
            E_target(air) = 0;
        end

        % Actualizar pBest
        if E_target(air) >= pBestE(air)
            pBest{air} = population{air};
            pBestE(air) = E_target(air);
        end

        % Actualizar gBest
        if E_target(air) >= gBestE
            gBest = population{air};
            gBestE = E_target(air);
        end

        % Guardar gráficos del perfil
        plot_geometry(population{air}, false);
        plot_polars(population{air}, false);
    end

    % Actualizar evolution plot
    evolution_plot = get_evolution_plot(evolution_plot, pBest, iter);
    
    status(population, pBestE, Cfg);
    fprintf(Cfg.log_file, '\n\tID mejor perfil: %d\n', gBest.id);
    fprintf(Cfg.log_file, '\tEficiencia mejor perfil: %f\n', gBestE);
    
    % Mostrar progreso
    fprintf('\n\tID mejor perfil global: %d\n', gBest.id);
    fprintf('\tEficiencia mejor perfil: %f\n', gBestE);
end

tiempo = toc;

%% Guardar Resultados
disp(['Tiempo de ejecución: ', num2str(tiempo), ' segundos']);
get_results(gBest, evolution_plot, Cfg);

% Convertir tiempo a horas, minutos y segundos
hours = floor(tiempo / 3600);
minutes = floor(mod(tiempo, 3600) / 60);
seconds = mod(tiempo, 60);

fprintf(Cfg.log_file, '\nPROCESO TERMINADO CON ÉXITO\n\n');
fprintf(Cfg.log_file, 'Tiempo de ejecución: %02d:%02d:%05.2f\n', hours, minutes, seconds);

% Reactivar las advertencias
warning('on', 'all');

% Cerrar el archivo de registro
fclose(Cfg.log_file);
