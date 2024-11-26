function [population, Cfg] = Gen_algorithm(Cfg)
    %% Generar la población inicial
    current_datetime = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
    fprintf(Cfg.log_file, 'Inicio de la ejecución del algoritmo genético: %s\n\n', current_datetime);
    fprintf( 'Inicio de la ejecución del algoritmo genético: %s\n\n', current_datetime);
    fprintf(Cfg.log_file, 'CREACIÓN DE LA POBLACIÓN:\n');
    fprintf('CREACIÓN DE LA POBLACIÓN\n');
    
    population = generate_population(Cfg);
    
    if length(population) > Cfg.NUM_POP
        disp('Se procede a cambiar el tamaño de la población.');
        Cfg.NUM_POP = length(population);
    end
    
    % Análisis de la primera generación
    tic
    fprintf('REALIZANDO ANÁLISIS INICIAL\n');
    population = run_aerodynamic_analysis(population, Cfg);
    population = rank_population(population);
    
    % Se guardan los datos de la primera generación
    for i = 1:length(population)
        plot_geometry(population{i}, false);
        plot_polars(population{i}, false);
    end
    evolution_plot{1} = []; 
    Cfg.LAST_ID = find_id(population);
    %% Algoritmo Genético
    for gen = 1:Cfg.NUMBER_ITERATIONS
        disp(['GENERACIÓN ', num2str(gen)]);
        fprintf(Cfg.log_file, '\nITERACIÓN %s:\n', num2str(gen));
        fprintf(Cfg.log_file, '\t SITUACIÓN INICIAL:\n');
        status(population, Cfg);
    
        % Selección de los padres
        parents = select_parents(population, Cfg);
        fprintf('\t SELECCIÓN DE PADRES:\n');
        fprintf(Cfg.log_file, '\t SELECCIÓN DE PADRES:\n');
        status(parents, Cfg);
    
        % Cruce de los individuos
        fprintf('\t CRUCES:\n');
        fprintf(Cfg.log_file, '\t CRUCES:\n');
        children = crossover(parents, Cfg.LAST_ID, Cfg);
    
        % Mutacion de los individuos
        fprintf('\t MUTACIONES:\n');
        fprintf(Cfg.log_file, '\t MUTACIONES:\n');
        children = mutation(children, Cfg);
    
        % Se hace el análisis en xfoil de los hijos
        fprintf('\t ANÁLISIS DE LOS HIJOS:\n')
        children = run_aerodynamic_analysis(children, Cfg);
    
        % Se guardan los datos de los hijos
        for i = 1:length(children)
            plot_geometry(children{i}, false);
            plot_polars(children{i}, false);
        end 
    
        % Reduccion de la población
        fprintf(Cfg.log_file, '\t REDUCCIÓN:\n');
        [population, discarded] = reduce_population(population, children);
        population = rank_population(population);
        status(discarded, Cfg);
    
        % Actualizar evolution plot
        evolution_plot = get_evolution_plot(evolution_plot, population, gen);
        Cfg.LAST_ID = find_id(children);
    end
    
    tiempo = toc;
    
    %% Mejor individuo
    disp(['Tiempo de ejecucion: ', num2str(tiempo), ' segundos']);
    get_results(population, evolution_plot, Cfg);
    
    % Convertir tiempo a horas, minutos y segundos
    hours = floor(tiempo / 3600);
    minutes = floor(mod(tiempo, 3600) / 60);
    seconds = mod(tiempo, 60);
    
    fprintf(Cfg.log_file, '\nPROCESO TERMINADO CON ÉXITO\n\n');
    fprintf(Cfg.log_file, 'Tiempo de ejecución: %02d:%02d:%05.2f\n', hours, minutes, seconds);
    
    % Close the log file
    fclose(Cfg.log_file);
end