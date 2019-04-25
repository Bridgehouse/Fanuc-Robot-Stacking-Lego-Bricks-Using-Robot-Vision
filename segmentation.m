function [segmented_image] = segmentation(image,color)

% This function performs thresholding and morphology in order to segment the
% colored brick in the given image. The thresholding and morphology are
% dependent on which color that needs to be found therefore the input to the
% function should eiter be 'red', 'green', 'blue', 'yellow'. 
% The output of the function is the segmented image.

% Clear different variables just in case.
clear STATS dist ProjPoint convexhulls


% The image is split into the three channels RGB.
image_split = image;

Red = image_split(:,:,1);
Green = image_split(:,:,2);
Blue = image_split(:,:,3);

% Four if statements checks if the input is 'red', 'green', 'blue',
% 'yellow'. 

if (isequal(color, 'red'))
    
    % Create empty image, ready to be filled with black or white pixels.
    Red_segmented = zeros(size(image_split,1),size(image_split,2), 'uint8');

    % Go through all pixels in the image and perform thresholding based on histogram
    % analysis.
    for i=1:size(Red,1)
        for j=1:size(Red,2)

           
            if (Red(i,j) > 144) & (Red(i,j) < 186) & (Green(i,j) < 150)

                % If the pixel is within the thresholds, make the pixel
                % white
                Red_segmented(i,j) = 255;

            else
                
                % If the pixel falls out just one of the the thresholds, 
                % make the pixel black
                Red_segmented(i,j) = 0;
            end
        end
    end

    % convert the black white picture in greyscale to a binary black and white
    % picture
    Morphology = imbinarize(Red_segmented,0.5);
    
    % Erode the image
    se_erode = strel('sphere',1); % 4
    Morphology = imerode(Morphology,se_erode);

    % Dilate the image
    se_dilate = strel('square',5);
    Morphology = imdilate(Morphology,se_dilate);

    % Fill in holes, where holes are defined as black areas surrounded by white
    Morphology = imfill(Morphology,'holes');

elseif (isequal(color, 'green'))
    
    % Create empty image, ready to be filled with black or white pixels.
    Green_segmented = zeros(size(image_split,1),size(image_split,2), 'uint8');
    
    % Go through all pixels in the image and perform thresholding based on histogram
    % analysis.
    for i=1:size(Green,1)
        for j=1:size(Green,2)

            if (Green(i,j) > 137) & (Green(i,j) < 191) & (Red(i,j) < 152) 
                
                % If the pixel is within the thresholds, make the pixel
                % white
                Green_segmented(i,j) = 255;
                
            else
                
                % If the pixel falls out just one of the the thresholds, 
                % make the pixel black
                Green_segmented(i,j) = 0;
            end
        end
    end

    
    % convert the black white picture in greyscale to a binary black and white
    % picture
    Morphology = imbinarize(Green_segmented,0.5);
    
    %Erode the image with a sphere
    se_erode = strel('sphere',1);
    Morphology = imerode(Morphology,se_erode);


    %dilate the image with a square
    se_dilate = strel('square',7);
    Morphology = imdilate(Morphology,se_dilate);


    % Fill in holes, where holes are defined as black areas surrounded by white
    Morphology = imfill(Morphology,'holes');

    
elseif (isequal(color, 'yellow'))
    
    % Create empty image, ready to be filled with black or white pixels.
    Yellow_segmented = zeros(size(image_split,1),size(image_split,2), 'uint8');
    
    % Go through all pixels in the image and perform thresholding based on histogram
    % analysis.
    for i=1:size(Green,1)
        for j=1:size(Green,2)

            if (Green(i,j) > 25) & (Green(i,j) < 222) & (Red(i,j) > 145)
                
                % If the pixel is within the thresholds, make the pixel
                % white
                Yellow_segmented(i,j) = 255;
                
            else
                
                % If the pixel falls out just one of the the thresholds, 
                % make the pixel black
                Yellow_segmented(i,j) = 0;
            end


        end
    end

    
    % convert the black white picture in greyscale to a binary black and white
    % picture
    Morphology = imbinarize(Yellow_segmented,0.5);
   
    %Erode the image with a sphere
    se_erode = strel('sphere',1);
    Morphology = imerode(Morphology,se_erode);


    %dilate the image with a square
    se_dilate = strel('square',7);
    Morphology = imdilate(Morphology,se_dilate);
   

    % Fill in holes, where holes are defined as black areas surrounded by white
    Morphology = imfill(Morphology,'holes');


elseif (isequal(color, 'blue'))
    
    % Create empty image, ready to be filled with black or white pixels.
    Blue_segmented = zeros(size(image_split,1),size(image_split,2), 'uint8');

    % Go through all pixels in the image and perform thresholding based on histogram
    % analysis.
    for i=1:size(Blue,1)
        for j=1:size(Blue,2)


            if (Blue(i,j) > 49) & (Blue(i,j) < 166) & (Green(i,j) < 100)
                
                % If the pixel is within the thresholds, make the pixel
                % white
                Blue_segmented(i,j) = 255;

            else
                
                % If the pixel falls out just one of the the thresholds, 
                % make the pixel black
                Blue_segmented(i,j) = 0;
            end


        end
    end

    % convert the black white picture in greyscale to a binary black and white
    % picture
    Morphology = imbinarize(Blue_segmented,0.5);
    

    %Erode the image
    se_erode = strel('sphere',1); 
    Morphology = imerode(Morphology,se_erode);


    %dilate the image
    se_dilate = strel('square',5); %
    Morphology = imdilate(Morphology,se_dilate);
    

    % Fill in holes, where holes are defined as black areas surrounded by white
    Morphology = imfill(Morphology,'holes');   
    

end

% Set the morphology image equal to the output
segmented_image = Morphology;

end