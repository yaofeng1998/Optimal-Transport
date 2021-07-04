function [output_size] = draw(outputs, key, titles, save_path)
close;
output_size = size(outputs);
c = colormap(parula(output_size(2)));
lines = '*';
for i = 1:1:output_size(1)
    subplot(1, output_size(1), i);
    hold on;
    title(titles(i));
    plots = [];
    legends = [];
    for j = 1:1:output_size(2)
        output = outputs(i, j);
        time = output.time;
        gap = output.gap;
        iter = 1:1:output.iter;
        line = '-';
        line_width = 6;
        if length(time) == 1
            iter = output.iter;
            line = lines(mod(j, length(lines)) + 1);
            line_width = 13;
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
            h = plot(time, gap, line, 'LineWidth', line_width, 'color', c(j, :), 'MarkerFaceColor', c(j, :));
            xlabel('Time/s');
        else
            if iter(1) == -1
                continue
            end
            h = plot(iter, gap, line, 'LineWidth', line_width, 'color', c(j, :), 'MarkerFaceColor', c(j, :));
            xlabel('Iteration');
        end
        ylabel('Relative Duality Gap');
        plots = [plots, h];
        legends = [legends, string(output.alg)];
    end
    % set(gca,'xscale','log');
    set(gca,'yscale','log');
    set(gca,'FontName', 'Times New Roman', 'FontSize', 38, 'LineWidth', 1.5);
    y_range = get(gca, 'ylim');
    set(gca, 'ylim', [1e-12, y_range(2)]);
    grid on;
    box on;
    set(gca, 'XMinorGrid','off');
    set(gca, 'YMinorGrid','off');
    h = legend(plots, legends, 'Location', 'northeast', 'orientation','vertical');
    set(h, 'box', 'off');
end
set(gcf,'unit','normalized','position',[0.2,0.2,0.5 * output_size(1),0.5]);
set(gcf, 'PaperSize', [36 * output_size(1), 24]);
print('-dpdf', '-fillpage', save_path)
hold off;
end