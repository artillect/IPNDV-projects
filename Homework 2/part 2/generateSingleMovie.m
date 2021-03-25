% generateSingleMovie is a helper script for the function
% generateMovingParticlesMovie()
% It takes a set of user inputs, and generates a movie with random particle
% motion according to those inputs.

% Get parameters for movie
num_particles = input('Number of objects: ');
vel = input('Speed of objects (in pixels/frame): ');
SNR = input('Sound-to-noise ratio: ');
shapeChanges = input('Do you want shape changes (1 for yes, 0 for no): ');

% Generate movie with user-input parameters
[movieFileName, tableFileName] = generateMovingParticlesMovie(num_particles, vel, SNR, shapeChanges);
fprintf('Movie file name: %s\n', movieFileName);
fprintf('Table file name: %s\n', tableFileName);