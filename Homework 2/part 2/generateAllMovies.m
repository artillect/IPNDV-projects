% Arrays of input parameters for random particle motion movies
num_particles = [64, 128, 256];
vel = [4, 8, 32];
SNR = [20, 2];

% Iterate over parameters in num_particles array
for num_parts_idx  = 1:length(num_particles)
    % Iterate over parameters in vel array
    for vel_idx = 1:length(vel)
        % Iterate over parameters in SNR array
        for SNR_idx =  1:length(SNR)
            % Generate movies with and without shape changes
            for randomShape = 0:1
                % Generate movies with given parameters
                [movieFileName, tableFileName] = generateMovingParticlesMovie(num_particles(num_parts_idx), vel(vel_idx), SNR(SNR_idx), randomShape);
                fprintf('Movie file name: %s\n', movieFileName);
                fprintf('Table file name: %s\n', tableFileName);
            end
        end
    end    
end