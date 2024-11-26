function random = random_population(num_random, Cfg)
    random = cell(num_random, 1);
    for i = 1:num_random
        Cfg.LAST_ID = Cfg.LAST_ID + 1;
        fprintf(Cfg.log_file, '\t Airfoil %d: airfoil aleatorio\n', Cfg.LAST_ID);
        random{i} = generate_random_airfoil(Cfg);
    end
end