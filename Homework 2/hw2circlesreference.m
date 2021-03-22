%circle stuff
angles = linspace(0, 2*pi, 360);
radius = 20;  %would need to randomize radius in image
CenterX = 50; %arbitrary, depends on where it is in the image
CenterY = 40; %arbitrary, depends on where it is in the image
x = radius * cos(angles) + CenterX;
y = radius * sin(angles) + CenterY;
plot(x, y, 'b-', 'LineWidth', 1);
hold on;
%plot(CenterX, CenterY, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
axis equal;
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);