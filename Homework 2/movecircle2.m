filename = 'movecircle.avi';
FR = 5;
MoveSeconds = 20;

xobs=[1.5 4.0 1.2 7.0 8.0];
    yobs=[4.5 3.0 1.5 5.0 8.0];
    robs=[1.5 1.0 0.8 1.0 1.0];
     theta=linspace(0,2*pi,100);

N = numel(xobs);
fh = gobjects(N, 1);
xspeed = zeros(N, 1);
yspeed = zeros(N, 1);

ax = gca;
set(gca,'Color','k');
hold on

for k = 1:N
        fh(k) = fill(ax, xobs(k)+robs(k)*cos(theta),yobs(k)+robs(k)*sin(theta),'w');
        xspeed(k) = randn()/2;
        yspeed(k) = randn()/2;
end
hold off

v = VideoWriter(filename);
v.FrameRate = FR;
open(v)


for iterations = 1 : FR * MoveSeconds
    for k = 1 : length(fh)
        fh(k).Vertices = fh(k).Vertices + [xspeed(k), yspeed(k)];
    end
    drawnow();
    pause(0.05);  %in practice, getframe does not always permit time for drawing
    img = getframe(ax);
    writeVideo(v, img);
end

close(v);

implay(filename);
