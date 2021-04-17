function data = dataConversion(file)

% data matrix is a 25600x4 with the following columns:
%  1: particleID
%  2: frame
%  3: x position of particle at frame number
%  4: y position of particle at frame number

table = readtable(file);
table = table2array(table);
data = zeros(256,4);

for frame = 1:100

    for partical = 1:256
        
        entry = 256*frame+partical-256;
        
        data(entry,1) = frame;
        data(entry,2) = partical;
        
        x_val = table(frame,partical+1);
        data(entry,3) = x_val;
        
        y_val = table(frame,partical+257);
        data(entry,4) = y_val;
        
    end

end

%choose to output specific columns of partical locations
particleID = data(:,1);
frame = data(:,2);
x = data(:,3);
y = data(:,4);

end