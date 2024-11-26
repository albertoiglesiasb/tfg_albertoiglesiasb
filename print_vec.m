function print_vec(vec, log_file)
    for i = 1:length(vec)
        if i == length(vec)
            fprintf(log_file, '%s]\n', num2str(vec(i)));
        else
            fprintf(log_file, '%s, ', num2str(vec(i)));
        end
    end
end