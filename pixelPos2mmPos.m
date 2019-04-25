function posBrick = pixelPos2mmPos(centroid,orientation)

% This function takes the centroids and the orientations of a number of
% bricks that finds the position of the brick in the Fanuc robot's
% coordinate system.

    % Iterating through the number of bricks.
    for i = 1:size(centroid,1)
        
        % The reference position in the image
        ref_pixels = [1383 982];
        
        % The reference position in robot coordinates
        ref_position = [348.3570 -387.5660 -66.3890 -167.4350 0.9766 0];
        
        % The conversion from pixel to mm. 
        pixel2mm = 0.3962; % find the correct one depending on the camera's position.

        % The offset between the brick position and the reference point
        targetPixels = ref_pixels - centroid(i,:);

        % The offset converted to mm.
        targetMM = targetPixels * pixel2mm;

        % The position which the robot should move to is the reference
        % position minus the converted offset. It is now necessary to
        % convert the orientation as it is the same in pixels as in mm.
        posBrick(i,:) = ref_position - [targetMM(2) targetMM(1) 0 0 0 orientation(i)];

    end
end
