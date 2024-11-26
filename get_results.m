function get_results(population, evolution_plot, Cfg)
    % Crear carpetas de salida si no existen
    outputs_folder = 'outputs';
    analysis_results_folder = fullfile(outputs_folder, 'analysis_results');
    geometry_plots_folder = fullfile(outputs_folder, 'geometry_plots');
    if ~exist(outputs_folder, 'dir')
        mkdir(outputs_folder);
    end
    if ~exist(analysis_results_folder, 'dir')
        mkdir(analysis_results_folder);
    end
    if ~exist(geometry_plots_folder, 'dir')
        mkdir(geometry_plots_folder);
    end

    % Crear la figura para la evolución
    fig_width = 10;
    fig_height = 8;
    fig = figure('Position', [100, 100, fig_width*100, fig_height*100]);
    ax1 = axes(fig);
    xlabel(ax1, 'Iterations');
    ylabel(ax1, 'Fitness');
    title(ax1, 'Evolution', 'FontWeight', 'bold');
    hold(ax1, 'on');

    % Graficar la evolución de las puntuaciones
    for i = 1:length(evolution_plot)
        scores = evolution_plot{i};
        plot(ax1, repmat(i-1, 1, length(scores)), scores, ...
            'r', 'Marker', 'x', 'LineStyle', 'none');
    end

    % Obtener y graficar la lista óptima
    optimum_list = zeros(1, length(evolution_plot));
    for i = 1:length(evolution_plot)
        scores = evolution_plot{i};
        optimum_list(i) = max(scores);
    end
    plot(ax1, 1:Cfg.NUMBER_ITERATIONS, optimum_list, 'b');
    xticks(ax1, 0:round(Cfg.NUMBER_ITERATIONS * 0.1):Cfg.NUMBER_ITERATIONS);
    grid(ax1, 'on');

    % Guardar las figuras
    saveas(fig, fullfile(outputs_folder, 'evolution_plot.svg'));
    ylim(ax1, [optimum_list(1), optimum_list(end)]);
    saveas(fig, fullfile(outputs_folder, 'evolution_plot_zoomed.svg'));
    close(fig);

    % Guardar resultados del mejor perfil aerodinámico
    rank = 1;
    for i = 1:length(population)
        best_airfoil = population{i};
        if best_airfoil.rank == rank
            plot_geometry(best_airfoil, true);
            plot_polars(best_airfoil, true);
            copyfile(fullfile(geometry_plots_folder, sprintf('airfoil_%s.mat', num2str(best_airfoil.id))), ...
                fullfile(outputs_folder, 'airfoil_best.mat'));
            copyfile(fullfile(analysis_results_folder, sprintf('xfoil_result_airfoil_%s.dat', num2str(best_airfoil.id))), ...
                fullfile(outputs_folder, 'xfoil_result_airfoil_best.dat'));
            print_final_result(best_airfoil, Cfg.log_file);
            break;
        end
    end
end
