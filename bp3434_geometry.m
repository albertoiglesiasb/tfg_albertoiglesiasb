function geometry = bp3434_geometry(parameters, Cfg)
    % Asignación de los parámetros
    rle = parameters(1);
    fprintf(Cfg.log_file, '\t\t\t\t r_le = %.4f; ', rle);
    x_t = parameters(2);
    fprintf(Cfg.log_file, 'x_t = %.4f; ', x_t);
    z_t = parameters(3);
    fprintf(Cfg.log_file, 'z_t = %.4f; ', z_t);
    x_c = parameters(4);
    fprintf(Cfg.log_file, 'x_c = %.4f;\n', x_c);
    z_c = parameters(5);
    fprintf(Cfg.log_file, '\t\t\t\t z_c = %.4f; ', z_c);
    z_te = parameters(6);
    fprintf(Cfg.log_file, 'z_te = %.4f; ', z_te);
    dz_te = parameters(7);
    fprintf(Cfg.log_file, 'dz_te = %.4f; ', dz_te);
    gamma_le = parameters(8);
    fprintf(Cfg.log_file, 'gamma_le = %.4f;\n', gamma_le);
    beta_te = parameters(9);
    fprintf(Cfg.log_file, '\t\t\t\t beta_te = %.4f; ', beta_te);
    alpha_te = parameters(10);
    fprintf(Cfg.log_file, 'alpha_te = %.4f; ', alpha_te);
    b0 = parameters(11);
    fprintf(Cfg.log_file, 'b0 = %.4f; ', b0);
    b2 = parameters(12);
    fprintf(Cfg.log_file, 'b2 = %.4f;\n', b2);
    b8 = parameters(13);
    fprintf(Cfg.log_file, '\t\t\t\t b8 = %.4f; ', b8);
    b15 = parameters(14);
    fprintf(Cfg.log_file, 'b15 = %.4f; ', b15);
    b17 = parameters(15);
    fprintf(Cfg.log_file, 'b17 = %.4f\n', b17);

    %Inicialización variables
    x_ = {zeros(1, 4), zeros(1, 5), zeros(1, 4), zeros(1, 5)};
    z_ = {zeros(1, 4), zeros(1, 5), zeros(1, 4), zeros(1, 5)};

    % Línea de espesor borde de ataque
    x_{1}(1) = 0;
    x_{1}(2) = 0;
    x_{1}(3) = (3 * (b8 ^ 2)) / (2 * rle); % Reversed sign
    x_{1}(4) = x_t;
    
    z_{1}(1) = 0;
    z_{1}(2) = b8;
    z_{1}(3) = z_t;
    z_{1}(4) = z_t;

    % Línea de espesor borde de salida
    x_{2}(1) = x_t;
    x_{2}(2) = (7 * x_t - ((9 * (b8 ^ 2)) / (2 * rle))) / 4;
    x_{2}(3) = 3 * x_t - ((15 * (b8 ^ 2)) / (4 * rle));
    x_{2}(4) = b15;
    x_{2}(5) = 1;
    
    z_{2}(1) = z_t;
    z_{2}(2) = z_t;
    z_{2}(3) = (z_t + b8) / 2;
    z_{2}(4) = dz_te + (1 - b15) * tan(beta_te);
    z_{2}(5) = dz_te;
    
    % LE camber line
    x_{3}(1) = 0;
    x_{3}(2) = b0;
    x_{3}(3) = b2;
    x_{3}(4) = x_c;
    
    z_{3}(1) = 0;
    z_{3}(2) = b0 * tan(gamma_le);
    z_{3}(3) = z_c;
    z_{3}(4) = z_c;
    
    % TE camber line
    x_{4}(1) = x_c;
    x_{4}(2) = (3 * x_c - z_c * (1 / tan(gamma_le))) / 2;
    x_{4}(3) = (-8 * z_c * (1 / tan(gamma_le)) + 13 * x_c) / 6;
    x_{4}(4) = b17;
    x_{4}(5) = 1;
    
    z_{4}(1) = z_c;
    z_{4}(2) = z_c;
    z_{4}(3) = (5 * z_c) / 6;
    z_{4}(4) = z_te + (1 - b17) * tan(alpha_te);
    z_{4}(5) = z_te;
    
    % Inicialización de las celdas x y z
    x = cell(1, 4);
    z = cell(1, 4);
    
    % Inicialización de las celdas con vectores vacíos
    for i = 1:4
        x{i} = [];
        z{i} = [];
    end
    
    % Definir N_generate
    N_generate = Cfg.NUM_POINTS/2;
    
    % Bucle anidado para calcular las coordenadas usando las curvas de Bézier
    for i = 1:4
        for j = 0:N_generate
            u = j / N_generate;
            if i == 1 || i == 3
                x{i}(end+1) = x_{i}(1) * ((1 - u)^3) + ...
                              3 * x_{i}(2) * u * ((1 - u)^2) + ...
                              3 * x_{i}(3) * (u^2) * (1 - u) + ...
                              x_{i}(4) * (u^3);
                z{i}(end+1) = z_{i}(1) * ((1 - u)^3) + ...
                              3 * z_{i}(2) * u * ((1 - u)^2) + ...
                              3 * z_{i}(3) * (u^2) * (1 - u) + ...
                              z_{i}(4) * (u^3);
            elseif i == 2 || i == 4
                x{i}(end+1) = x_{i}(1) * ((1 - u)^4) + ...
                              4 * x_{i}(2) * u * ((1 - u)^3) + ...
                              6 * x_{i}(3) * (u^2) * ((1 - u)^2) + ...
                              4 * x_{i}(4) * (u^3) * (1 - u) + ...
                              x_{i}(5) * (u^4);
                z{i}(end+1) = z_{i}(1) * ((1 - u)^4) + ...
                              4 * z_{i}(2) * u * ((1 - u)^3) + ...
                              6 * z_{i}(3) * (u^2) * ((1 - u)^2) + ...
                              4 * z_{i}(4) * (u^3) * (1 - u) + ...
                              z_{i}(5) * (u^4);
            end
        end
    end
    
    % Definir x_t, z_t, x_c, z_c
    x{1}(end) = [];
    z{1}(end) = [];
    x{3}(end) = [];
    z{3}(end) = [];

    x_t = [x{1} x{2}];
    z_t = [z{1} z{2}];
    x_c = [x{3} x{4}];
    z_c = [z{3} z{4}];

    z_t = replace_nan(z_t);

    z_c = replace_nan(z_c);

    [x, z_t] = normalize_coordinates(x_t, z_t, Cfg.NUM_POINTS);
    [~, z_c] = normalize_coordinates(x_c, z_c, Cfg.NUM_POINTS);
    
    % Obtener x_upper, z_upper, x_lower y z_lower 
    x_upper = x;
    z_upper = z_c + 0.5 * z_t;

    x_lower = x;
    z_lower = z_c - 0.5 * z_t;

    % Obtener el spline del perfil
    geometry = airfoil_geometry(x_upper, z_upper, x_lower, z_lower, Cfg.NUM_POINTS);
end