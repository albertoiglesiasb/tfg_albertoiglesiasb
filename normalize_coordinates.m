function [output_x, output_z] = normalize_coordinates(input_x, input_z, N)
    % Interpolación
    function_z = @(xq) interp1(input_x, input_z, xq, 'linear', 'extrap');
    
    % Distribución cosenoide
    output_x = x_distribution(N);

    % Interpolación de Z
    output_z = function_z(output_x);
end