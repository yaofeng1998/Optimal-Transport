function [output_size] = draw(outputs, key, titles, save_path)
output_size = size(outputs);
c = colormap(parula(output_size(1) * output_size(2)));
hold on;
for i=1:1:output_size(1)
    subplot(1, output_size(1), i);
    title(titles(i));
    plots = [];
    legends = [];
    for j=1:1:output_size(2)
        output = outputs(i, j);
        time = output.time;
        gap = output.gap;
        iter = 1:1:(output.iter + 1);
        line = '-';
        line_width = 3;
        if length(time) == 1
            iter = output.iter;
            line = '*';
            line_width = 10;
            if gap < 1e-12
                gap = 1e-12;
            end
        else
            gap(gap < 1e-12) = 1e-12;
        end
        if strcmpi(key, 'time')
            if time(1) == -1
                continue
            end
            h = plot(time, gap, line, 'LineWidth', line_width, 'color', c((i - 1) * output_size(2) + j, :), 'MarkerFaceColor', c((i - 1) * output_size(2) + j, :));
            xlabel('Time/s');
        else
            if iter(1) == -1
                continue
            end
            h = plot(iter, gap, line, 'LineWidth', line_width, 'color', c((i - 1) * output_size(2) + j, :), 'MarkerFaceColor', c((i - 1) * output_size(2) + j, :));
            xlabel('Iteration');
        end
        ylabel('Relative Duality Gap');
        plots = [plots, h];
        legends = [legends, string(output.alg)];
    end
    legend(plots, legends, 'Location','Best');
    set(gca,'yscale','log');
    % set(gca,'ylim',[1e-15, 1]);
end
set(gca,'FontName', 'Times New Roman', 'FontSize', 18, 'LineWidth', 1.5);
set(gcf,'position',[100, 100, 960 * output_size(1), 600]);
set(gcf, 'PaperSize', [28 * output_size(1), 18.75]);
grid on;
set(gca, 'XMinorGrid','off');
set(gca, 'YMinorGrid','off');
y_range = get(gca,'ylim');
set(gca,'ylim',[1e-12, y_range(2)]);
saveas(gcf, save_path, 'pdf');
hold off;
end