function [evaluation, total_score] = calculate_score(profile, Cfg)
    % Calcular puntaje de un perfil aerodinámico basado en Cl, Cd y eficiencia
    %
    % Inputs:
    %   profile - Estructura que contiene Cl, Cd y eficiencia
    %   Cfg - Estructura de configuración con parámetros de puntuación
    %
    % Outputs:
    %   total_score - Puntaje total del perfil
    %   evaluation - Vector con detalles de la evaluación y puntajes individuales

    % Cálculo de puntajes individuales
    Cl_score = get_score(profile.CL_opt, Cfg.CL_LB, Cfg.CL_UB, ...
                         Cfg.CL_NORMALIZATION, Cfg.CL_PENALIZATION);
    Cd_score = get_score(min(profile.CD), Cfg.CD_LB, Cfg.CD_UB, ...
                         Cfg.CD_NORMALIZATION, Cfg.CD_PENALIZATION);
    efficiency_score = get_score(max(profile.E), Cfg.E_LB, Cfg.E_UB, ...
                                 Cfg.E_NORMALIZATION, Cfg.E_PENALIZATION);
    
    % Cálculo del puntaje total
    total_score = (Cl_score * Cfg.CL_WEIGHT + ...
                   Cd_score * Cfg.CD_WEIGHT + ...
                   efficiency_score * Cfg.E_WEIGHT);
    
    evaluation = [Cl_score, Cd_score, efficiency_score];
end
