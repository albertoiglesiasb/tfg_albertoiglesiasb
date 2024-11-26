function airfoil_population = generate_population(Cfg)
    % Lee los perfiles predefinidos
    airfoil_predifined = read_predefined(Cfg);
    num_predifined = length(airfoil_predifined);
    if num_predifined == 0
        Cfg.LAST_ID = 0;
    else
        Cfg.LAST_ID = find_id(airfoil_predifined);
    end

    % Incorpora algunos perfiles de la librería
    if Cfg.NUM_POP - num_predifined > Cfg.NUM_AIRFOIL_LIBRARY
        airfoil_library = read_library(Cfg);
    elseif Cfg.NUM_POP - num_predifined <= Cfg.NUM_AIRFOIL_LIBRARY && Cfg.NUM_POP - num_predifined > 0
        Cfg.NUM_AIRFOIL_LIBRARY = round((Cfg.NUM_POP - num_predifined)/2);
        airfoil_library = read_library(Cfg);
    else
        disp('Se han cargado más perfiles predefinidos que el tamaño de la población.');
        disp('Revise los perfiles predefinidos o el tamaño de la población.');
        airfoil_library = [];
    end

    Cfg.LAST_ID = find_id(airfoil_library);

    % Genera una población random de perfiles aerodinamicos necesarios
    if Cfg.NUM_POP - num_predifined - Cfg.NUM_AIRFOIL_LIBRARY > 0
        airfoil_random = random_population(Cfg.NUM_POP - num_predifined - Cfg.NUM_AIRFOIL_LIBRARY, Cfg);
    else
        airfoil_random = [];
    end
    % Une las dos poblaciones
    airfoil_population = [airfoil_predifined; airfoil_library; airfoil_random];
end
