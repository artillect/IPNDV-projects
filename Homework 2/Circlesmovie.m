v = VideoWriter('/Users/circuiteer/Downloads/Movie');
open(v)
for i = 1:100 
    n = 10; %change n to number of desired objects
      for k = 1:n  
    % Create random circles to display,
          X = rand(n,1);
          Y = rand(n,1);
          centers = [X Y];
          radii = 0.01*ones(n,1);
          ax = gca;
          set(gca,'Color','k')
    % Clear the axes.
          cla
    % Fix the axis limits.
          xlim([-0.1 1.1])
          ylim([-0.1 1.1])
    % Set the axis aspect ratio to 1:1.
          axis square
    % Display the circles.
          viscircles(centers,radii,'color', 'k');              
      end 
      drawnow()
      pause(0.05);  %in practice, getframe does not always permit time for drawing
      img = getframe(ax);
      writeVideo(v, img)
end

close(v);
%implay(filename)