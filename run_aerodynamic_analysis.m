function analyse_population = run_aerodynamic_analysis(population, Cfg)
    for i = 1:length(population)
        try
            results =  analyze_airfoil([flip(population{i}.x_upper), population{i}.x_lower]', ...
                [flip(population{i}.z_upper), population{i}.z_lower]', Cfg.AoA, Cfg.Re, Cfg.Mach);
            results.E = results.CL ./ results.CD;
            population{i}.CL = results.CL;
            population{i}.CD = results.CD;
            population{i}.E = results.E;
            population{i}.alpha = results.alpha;
            population{i} = evaluate_airfoil(population{i}, Cfg);
            if ~isfield(population{i}, 'id')
                population{i}.id = i;
            end

            % Mensaje de datos en barra de comando
            fprintf('\t\tPerfil %d: Cl \t\t Cd \t\t E\n', population{i}.id);
            fprintf('\t\t\t\t  %1.2f       %.5f \t %3.2f\n', population{i}.CL_target,population{i}.CD_target, population{i}.E_target);
        catch ME
            if ~isfield(population{i}, 'id')
                population{i}.id = i;
            end
            fprintf('\t\tPerfil %d: Error al analizar\n', population{i}.id);
            error('Error al ejecutar XFoil: %s', ME.message);
        end

        analyse_population = population;
    end
end
    
