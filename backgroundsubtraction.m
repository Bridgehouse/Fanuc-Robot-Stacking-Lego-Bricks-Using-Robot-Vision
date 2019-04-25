function [image] = backgroundsubtraction(img,imgbg)

% This function performs background subtraction. The input is an image and
% a background image.

    % initialise an empty image for the background subtraction
    image = zeros(size(img,1),size(img,2),3, 'uint8');
    
    % Background subtraction performed on all three RGB channels.
    % Go through all pixels and subtract the background image pixel values
    % with the pixel values in the image with the bricks
    for i=1:size(img,1)
        for j=1:size(img,2)

            image(i,j,:) = img(i,j,:)-imgbg(i,j,:);

        end
    end


end