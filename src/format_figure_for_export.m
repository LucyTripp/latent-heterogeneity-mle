function format_figure_for_export(figure_handle)
% Apply a legible chart style independent of MATLAB's light/dark theme.

figure_handle.Color = "white";
figure_handle.Position(3:4) = [900, 550];

axes_handles = findall(figure_handle, "Type", "axes");

for axis_handle = axes_handles'
    axis_handle.Color = "white";
    axis_handle.XColor = "black";
    axis_handle.YColor = "black";
    axis_handle.FontSize = 12;
    axis_handle.LineWidth = 1;
    axis_handle.GridColor = [0.65, 0.65, 0.65];
    axis_handle.GridAlpha = 0.35;

    axis_handle.Title.Color = "black";
    axis_handle.Title.FontSize = 15;
    axis_handle.Title.FontWeight = "bold";
    axis_handle.XLabel.Color = "black";
    axis_handle.YLabel.Color = "black";
end

legend_handles = findall(figure_handle, "Type", "legend");

for legend_handle = legend_handles'
    legend_handle.Color = "white";
    legend_handle.TextColor = "black";
    legend_handle.EdgeColor = [0.55, 0.55, 0.55];
    legend_handle.FontSize = 11;
end
end