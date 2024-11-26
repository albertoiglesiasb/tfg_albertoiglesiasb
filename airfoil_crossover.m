function airfoil = airfoil_crossover(upper_csapi_1, lower_csapi_1, upper_csapi_2, lower_csapi_2, Cfg)
    
    % Se obtiene 
    airfoil.upper_csapi = upper_csapi_1;
    airfoil.upper_csapi.coefs = Cfg.PERCENT_CROSS_1*upper_csapi_1.coefs + Cfg.PERCENT_CROSS_2*upper_csapi_2.coefs;
    airfoil.lower_csapi = lower_csapi_1;
    airfoil.lower_csapi.coefs = Cfg.PERCENT_CROSS_1*lower_csapi_1.coefs + Cfg.PERCENT_CROSS_2*lower_csapi_2.coefs;
    
    % Se obtiene la geometría completa de los ambos hijos
    x = x_distribution(Cfg.NUM_POINTS);
    
    airfoil.x_upper = x;
    airfoil.x_lower = x;

    airfoil.z_upper = ppval(airfoil.upper_csapi, x);
    airfoil.z_lower = ppval(airfoil.lower_csapi, x);
end