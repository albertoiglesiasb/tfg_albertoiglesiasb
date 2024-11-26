function coef = xfoil(coord, alpha, Re, Mach, varargin)
    % Run XFoil and return the lift and drag coefficients (Cl and Cd), as well as the optimal Cl.
    % coef = xfoil(coord, alpha, Re, Mach, {extra commands})
    %
    % Inputs:
    %   coord: Normalized foil coordinates (n by 2 array) or a filename or a NACA string
    %   alpha: Angle-of-attack, can be a vector
    %   Re: Reynolds number (use Re=0 for inviscid mode)
    %   Mach: Mach number
    %   varargin: Extra XFoil commands (e.g., 'oper/iter 150')
    %
    % Outputs:
    %   coef: structure with fields 'alpha', 'Cl', 'Cd', 'Cl_opt', and 'alpha_opt'

    % Check and set default values for inputs
    if nargin < 1, coord = 'NACA0012'; end
    if nargin < 2, alpha = 0; end
    if nargin < 3, Re = 1e6; end
    if nargin < 4, Mach = 0.2; end

    % Set default number of iterations if not provided in varargin
    iter_set = false;
    for ii = 1:length(varargin)
        if contains(varargin{ii}, 'iter')
            iter_set = true;
            break;
        end
    end
    if ~iter_set
        varargin = [varargin, {'oper iter 300'}];
    end

    % Default foil name
    foil_name = mfilename;

    % Default filenames
    wd = fileparts(which(mfilename)); % Working directory, where xfoil.exe needs to be
    fname = mfilename;
    file_coord = [foil_name '.foil'];

    % Save coordinates
    if ischar(coord)
        if isempty(regexpi(coord, '^NACA *[0-9]{4,5}$', 'once')) % Check if a NACA string
            file_coord = coord;
        end
    else
        % Write foil ordinate file
        if exist(file_coord, 'file'), delete(file_coord); end
        fid = fopen(file_coord, 'w');
        if fid <= 0
            error('Unable to create file %s', file_coord);
        else
            fprintf(fid, '%s\n', foil_name);
            fprintf(fid, '%9.5f   %9.5f\n', coord');
            fclose(fid);
        end
    end

    % Write xfoil command file
    fid = fopen([wd filesep fname '.inp'], 'w');
    if fid <= 0
        error('Unable to create xfoil.inp file');
    else
        if ischar(coord)
            if ~isempty(regexpi(coord, '^NACA *[0-9]{4,5}$', 'once'))
                fprintf(fid, 'naca %s\n', coord(5:end));
            else
                fprintf(fid, 'load %s\n', file_coord);
            end
        else
            fprintf(fid, 'load %s\n', file_coord);
        end

        % Insert extra commands to disable graphical output
        fprintf(fid, 'PLOP\nG F\n\n');
        
        % Extra XFoil commands
        for ii = 1:length(varargin)
            txt = varargin{ii};
            txt = regexprep(txt, '[ \\\/]+', '\n');
            fprintf(fid, '%s\n', txt);
        end

        fprintf(fid, 're %g\n', Re);
        fprintf(fid, 'mach %g\n', Mach);

        % Switch to viscous mode
        if Re > 0
            fprintf(fid, 'visc\n');
        end

        % Polar accumulation 
        fprintf(fid, 'pacc\n\n\n');

        % Xfoil alpha calculations
        if isscalar(alpha)
            fprintf(fid, 'Alfa %g\n', alpha);
        else
            fprintf(fid, 'ASEQ %g', min(alpha));
            fprintf(fid, ' %g', max(alpha));
            fprintf(fid, ' %g\n', abs(alpha(1)-alpha(2)));
        end
        

        file_pwrt = sprintf('%s_pwrt.dat', fname);
        fprintf(fid, 'pwrt\n%s\n', file_pwrt);
        fprintf(fid, 'plis\n');
        fprintf(fid, '\nquit\n');
        fclose(fid);

        % Define and configure the timer
        t = timer('StartDelay', 30, 'TasksToExecute', 1, 'ExecutionMode', 'fixedRate');
        t.TimerFcn = @(~,~)system('TASKKILL /IM xfoil.exe /F');  % Terminate XFoil if timer elapses

        try
            start(t);  % Start the timer
            cmd = sprintf('cd %s && xfoil.exe < %s.inp > %s.out', wd, fname, fname);
            [status, result] = system(cmd);
            stop(t);  % Stop the timer
            if status ~= 0
                disp(result);
                error('Xfoil execution failed! %s', cmd);
            end
        catch
            stop(t);  % Ensure the timer is stopped in case of error
        end
        delete(t);  % Clean up the timer

        % Read polar data
        fid = fopen([wd filesep file_pwrt], 'r');
        if fid <= 0
            error('Unable to read xfoil polar file %s', file_pwrt);
        else
            % Read the polar data starting from the 13th line
            P = textscan(fid, '%f %f %f %f %f %f %f', 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'HeaderLines', 12);
            fclose(fid);
            delete([wd filesep file_pwrt]);

            % Extract data
            coef.alpha = P{1};
            coef.Cl = P{2};
            coef.Cd = P{3};

        end

        % Delete input files
        if exist([wd filesep file_coord], 'file'), delete([wd filesep file_coord]); end
        if exist([wd filesep fname '.inp'], 'file'), delete([wd filesep fname '.inp']); end
        if exist([wd filesep fname '.out'], 'file'), delete([wd filesep fname '.out']); end
    end
end
