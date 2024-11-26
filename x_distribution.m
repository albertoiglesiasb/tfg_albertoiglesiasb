function output_x = x_distribution(num_points)
    % Distribución cosenoide
    beta = linspace(0, pi, num_points); % Distribución cosenoide
    cos_x = (1 - cos(beta)) / 2; % Transformación cosenoide [0, 1]

    % Ajuste de incremento para mayor densidad inicial
    for i = 2:num_points
        cos_x(i) = round(cos_x(i-1) + i * (2 / (num_points * (num_points + 1))), 8);
        if cos_x(i) > 1
            cos_x(i) = 1;
        end
    end

    % Normalización para asegurar el rango [0, 1]
    output_x = cos_x / max(cos_x);
end