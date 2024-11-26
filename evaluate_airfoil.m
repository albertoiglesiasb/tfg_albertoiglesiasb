function airfoil = evaluate_airfoil(airfoil, Cfg)

    if ~isfield(Cfg, 'max_iter') || isempty(Cfg.max_iter)
        Cfg.max_iter = 3;
    end

    % Extraer los datos de Cl, Cd y eficiencia
    Cl_data = airfoil.CL;
    alpha_data = airfoil.alpha;

    if ~isempty(Cl_data)
        % Buscar el valor de Cl más cercano
        [~, idx] = min(abs(Cl_data - Cfg.CL_target));
    
        % Si el Cl exacto no se encuentra, interpolar entre los más cercanos
        if abs(Cl_data(idx) - Cfg.CL_target) > 0.01 && Cl_data(idx) > 0
            if length(Cl_data) == idx && idx ~= 1
                % Si el Cl deseado está fuera del rango de datos disponibles, usar extremo
                alpha_interp = interp1(Cl_data(idx-1:idx), ...
                                    alpha_data(idx-1:idx), ...
                                    Cfg.CL_target, 'linear', 'extrap');
            elseif idx == 1 && length(Cl_data) > 1
                % Interpolar Cl linealmente
                alpha_interp = interp1(Cl_data(idx:idx+1), ...
                                    alpha_data(idx:idx+1), ...
                                    Cfg.CL_target, 'linear', 'extrap');
            elseif length(Cl_data) == 1
                alpha_interp = alpha_data(idx) + 1;
            else
                alpha_interp = interp1(Cl_data(idx-1:idx+1), ...
                                    alpha_data(idx-1:idx+1), ...
                                    Cfg.CL_target, 'linear', 'extrap');
            end

            % Se vuelve a llamar a Xfoil para que analice en el alpha interpolado
            airfoil_inter = analyze_airfoil([flip(airfoil.x_upper), airfoil.x_lower]', ...
                        [flip(airfoil.z_upper), airfoil.z_lower]', alpha_interp, Cfg.Re, Cfg.Mach);

            if ~isempty(airfoil_inter.CL)
                % Incluir el nuevo dato de alpha, CL y CD
                airfoil.alpha(end+1) = airfoil_inter.alpha;
                airfoil.CL(end+1) = airfoil_inter.CL;
                airfoil.CD(end+1) = airfoil_inter.CD;
            else
                airfoil_inter.alpha = airfoil.alpha(idx);
                airfoil_inter.CL = airfoil.CL(idx);
                airfoil_inter.CD = airfoil.CD(idx);
            end
        else
            % Si el Cl está suficientemente cerca, no se interpola
            airfoil_inter.CL = airfoil.CL(idx); 
            airfoil_inter.CD = airfoil.CD(idx);
        end

        % Ordenar en función de alpha
        [airfoil.alpha, sort_idx] = sort(airfoil.alpha);  % Ordenar alpha
        airfoil.CL = airfoil.CL(sort_idx);  % Reordenar CL basado en alpha
        airfoil.CD = airfoil.CD(sort_idx);  % Reordenar CD basado en alpha
    
        % Calcular eficiencia (Cl/Cd)
        airfoil.E_target = airfoil_inter.CL / airfoil_inter.CD;
        airfoil.CD_target = airfoil_inter.CD;
        airfoil.CL_target = airfoil_inter.CL;
        airfoil.E = airfoil.CL ./ airfoil.CD;
    
        if abs(airfoil_inter.CL - Cfg.CL_target) > 0.01 && Cfg.max_iter > 0
            Cfg.max_iter = Cfg.max_iter - 1;
            airfoil = evaluate_airfoil(airfoil, Cfg);
        end
    else
        airfoil.E_target = [];
        airfoil.CD_target = [];
        airfoil.CL_target = [];
    end
    
end
