num_objs = input('Number of objects: ');
vel = input('Speed of objects (in pixels/frame): ');
SNR = input('Sound-to-noise ratio: ');
shapeChanges = input('Do you want shape changes (1 for yes, 0 for no): ');


randomShape = shapeChanges == 1;

generateMovingParticlesMovie(num_objs, vel, SNR, randomShape);
%printf('Movie file name: %s', movieFileName);
%printf('Downscaled movie file name: %s', downscaledMovieFileName);
%printf('Table file name: %s', tableFileName);