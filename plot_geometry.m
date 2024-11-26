function plot_geometry(member, best_airfoil)

    % Extraer coordenadas de la geometría
    x_upper = member.x_upper;
    z_upper = member.z_upper;
    x_lower = member.x_lower;
    z_lower = member.z_lower;
    
    % Configuración de la figura
    fig_width = 10;
    fig_height = 4;
    figure('Units', 'inches', 'Position', [1, 1, fig_width, fig_height]);

    % Crear el gráfico
    hold on;
    plot([flip(x_upper), x_lower], [flip(z_upper), z_lower], 'b', 'LineWidth', 1.5);
    set(gca, 'XTick', 0:0.1:1, 'FontSize', 10);
    xlabel('Chord');
    grid on;
    axis([-0.05, 1.05, -0.15, 0.15]);
    hold off;
    
    % Carpetas de salida
    outputs_folder = 'outputs';
    geometry_plots_folder = fullfile(outputs_folder, 'geometry_plots', sprintf('airfoil_%d', member.id));
    
    % Crear carpetas si no existen
    if ~exist(geometry_plots_folder, 'dir')
        mkdir(geometry_plots_folder);
    end
    
    % Obtener el número siguiente para los archivos .mat y .svg
    mat_files = dir(fullfile(geometry_plots_folder, '*.mat'));
    svg_files = dir(fullfile(geometry_plots_folder, '*.svg'));
    
    num_mat = max(length(mat_files)) + 1;
    num_svg = max(length(svg_files)) + 1;
    
    % Configuración del título y guardado de la figura
    if best_airfoil
        title(sprintf('Geometry of airfoil %d (best)', member.id), 'FontWeight', 'bold');
        saveas(gcf, fullfile(outputs_folder, 'geometry_airfoil_best.svg'));
        save(fullfile(outputs_folder, 'airfoil_best.mat'), 'member');
    else
        title(sprintf('Geometry of airfoil %d', member.id), 'FontWeight', 'bold');
        saveas(gcf, fullfile(geometry_plots_folder, sprintf('geometry_airfoil_%d_%d.svg', member.id, num_svg)));
        save(fullfile(geometry_plots_folder, sprintf('airfoil_%d_%d.mat', member.id, num_mat)), 'member');
    end
    
    % Cerrar la figura
    close(gcf);
end
