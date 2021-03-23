function saveFiles(nShapes)

for i = 1:200
    %im = randomIrregularShapes(nShapes);
    im = randomCircles(nShapes);
    filename = ['hw2_' num2str(nShapes) '_randomCircles_' num2str(i) '.png'];
    imwrite(im, filename);
end

end

