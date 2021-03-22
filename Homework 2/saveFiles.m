function saveFiles(nShapes)

for i = 1:200
    im = randomIrregularShapes(nShapes);
    filename = ['hw2_' num2str(nShapes) '_irregularShapes_' num2str(i) '.png'];
    imwrite(im, filename);
end

end

