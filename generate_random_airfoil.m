function airfoil = generate_random_airfoil(Cfg)
    % Genera parámetros random de la parametrización BP3434
    parameters = gen_random_parameter();

    % Genera la geometria del perfil aerodinámico utilizando los parámetros
    airfoil = bp3434_geometry(parameters, Cfg);
end