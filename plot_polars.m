function plot_polars(airfoil, best_airfoil)
    % Carpetas de salida
    outputs_folder = 'outputs';
    analysis_results_folder = fullfile(outputs_folder, 'analysis_results', sprintf('airfoil_%d', airfoil.id));
    polars_plots_folder = fullfile(outputs_folder, 'polars_plots', sprintf('airfoil_%d', airfoil.id));
    
    % Crear carpetas si no existen
    if ~exist(outputs_folder, 'dir')
        mkdir(outputs_folder);
    end
    if ~exist(analysis_results_folder, 'dir')
        mkdir(analysis_results_folder);
    end
    if ~exist(polars_plots_folder, 'dir')
        mkdir(polars_plots_folder);
    end
    
    % Obtener el número siguiente para los archivos .mat y .svg
    svg_files = dir(fullfile(polars_plots_folder, '*.svg'));
    
    num_svg = max(length(svg_files)) + 1;

    % Crear la figura y las subplots
    fig_width = 10;
    fig_height = 8;
    figure('Units', 'inches', 'Position', [1, 1, fig_width, fig_height]);

    subplot(2, 2, 1);
    plot(airfoil.alpha, airfoil.CL, 'b', 'LineWidth', 1.5);
    xlabel('\alpha');
    ylabel('C_l');
    grid on;

    subplot(2, 2, 2);
    plot(airfoil.alpha, airfoil.CD, 'b', 'LineWidth', 1.5);
    xlabel('\alpha');
    ylabel('C_d');
    grid on;

    subplot(2, 2, 3);
    plot(airfoil.alpha, airfoil.E, 'b', 'LineWidth', 1.5);
    xlabel('\alpha');
    ylabel('C_l/C_d');
    grid on;
    
    % Configuración del título y guardado de la figura
    if best_airfoil
        sgtitle(sprintf('Polars of airfoil %d (best)', airfoil.id), 'FontWeight', 'bold');
        saveas(gcf, fullfile(outputs_folder, 'polars_airfoil_best.svg'));
        save_analysis_data(airfoil, outputs_folder, best_airfoil);
    else
        sgtitle(sprintf('Polars of airfoil %d', airfoil.id), 'FontWeight', 'bold');
        saveas(gcf, fullfile(polars_plots_folder, sprintf('polars_airfoil_%d_%d.svg', airfoil.id, num_svg)));
        save_analysis_data(airfoil, analysis_results_folder, best_airfoil);
    end
    
    % Cerrar la figura
    close(gcf);
end
