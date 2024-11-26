function print_final_result(airfoil, log_file)
    % Imprimir resultados
    fprintf(log_file, '\nOPTIMUM AIRFOIL (ID = %d):\n', airfoil.id);
    fprintf(log_file, '\tGEOMETRY:\n');
    fprintf(log_file, '\t\tx_upper\t\tz_upper\t|\tx_lower\t\tz_lower\n');
    for i = 1:length(airfoil.x_lower)
        fprintf(log_file,'\t\t%.4f\t\t%.4f\t|\t%.4f\t\t%.4f\n', airfoil.x_upper(i), airfoil.z_upper(i), airfoil.x_lower(i), airfoil.z_lower(i));
    end
    fprintf(log_file, '\tPROPERTIES:\n');
    fprintf(log_file, '\t\tlift_coeff_target: %.4f\n', airfoil.CL_target);
    fprintf(log_file, '\t\tdrag_coeff_target: %.4f\n', airfoil.CD_target);
    fprintf(log_file, '\t\teffic_target: %.4f\n', airfoil.E_target);
end
