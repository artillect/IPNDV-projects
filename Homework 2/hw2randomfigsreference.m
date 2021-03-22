%This code generates a random closed figure


% Randomize amplitude and phase.
H = 10; %arbitrary; the larger it is the crazier your shape is (rho, phi will vary)
rho = rand(1,H) .* logspace(-0.5,-2.5,H);
phi = rand(1,H) .* 2*pi;

% Accumulate r(t) over t=[0,2*pi]
t = linspace(0,2*pi,75); %arbitrary number of points, can change
r = ones(size(t));
for h=1:H
  r = r + rho(h)*sin(h*t+phi(h));  
end

% Reconstruct x(t), y(t)
x = r .* cos(t);
y = r .* sin(t);

% Plot x(t) and y(t)
figure;
hold on;
plot(x,y,'b-');
xlabel('x(t)');
ylabel('y(t)');
axis equal;