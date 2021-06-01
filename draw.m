function [output_size] = draw(outputs, key, titles, save_path)
output_size = size(outputs);
hold on;
for i=1:1:output_size(1)
    subplot(1, output_size(1), i);
    title(titles(i));
    legends = [];
    for j=1:1:output_size(2)
        output = outputs(i, j);
        time = output.time;
        gap = output.gap;
        iter = output.iter;
        line = '-';
        if strcmpi(output.alg, 'Gurobi')
            %iter = [output.iter, ];
            %time = [output.time, output.time];
            %gap = [1e-15, 1];
            line = '*';
        end
        if strcmpi(output.alg, 'Mosek')
            %iter = [output.iter, output.iter];
            %time = [output.time, output.time];
            %gap = [1e-15, 1];
            line = '*';
        end
        if strcmpi(key, 'time')
            if time(1) == -1
                continue
            end
            semilogy(time, gap, line, 'LineWidth', 3);
            xlabel('Time/s');
        else
            if iter(1) == -1
                continue
            end
            semilogy(iter, gap, line, 'LineWidth', 3);
            xlabel('Iteration');
        end
        ylabel('Relative Duality Gap');
        legends = [legends, string(output.alg)];
    end
    legend(legends);
    set(gca,'yscale','log');
    % set(gca,'ylim',[1e-15, 1]);
end
set(gca,'FontName', 'Times New Roman', 'FontSize', 18, 'LineWidth', 1.5);
saveas(gcf, save_path, 'pdf');
hold off;
end