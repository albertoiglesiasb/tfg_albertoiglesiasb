function results = analyze_airfoil(points_x, points_z, alphas, Re, Mach)
    % Esta función evalúa un perfil aerodinámico usando XFoil.
    % Inputs:
    %   coords - Matriz n x 2 con las coordenadas del perfil del ala.
    %   alphas - Vector con los ángulos de ataque.
    %   Re     - Número de Reynolds.
    %   Mach   - Número de Mach.
    % Outputs:
    %   results - Estructura con los coeficientes aerodinámicos (CL, CD, Cm).

    % Llamada a la función xfoil para obtener los resultados
    coords = [points_x, points_z];
    try
        [pol] = xfoil(coords, alphas, Re, Mach, 'oper iter 300');

        % Almacenar resultados en una estructura
        results.CL = pol.Cl;
        results.CD = pol.Cd;
        results.alpha = pol.alpha;

    catch

        results.CL = [];
        results.CD = [];
        results.alpha = [];

    end
    
end