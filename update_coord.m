function [coor_mod, vel_mod] = update_coord(coor, vel, pBest, gBest, Cfg)

    % Generación de números aleatorios
    r1 = rand(size(coor));
    r2 = rand(size(coor));

    % Actualizar velocidad
    vel_mod = Cfg.w * vel + Cfg.c1 * r1 .* (pBest - coor) + Cfg.c2 * r2 .* (gBest - coor);
    
    % Actualizar posición
    coor_mod = coor + vel_mod;

end