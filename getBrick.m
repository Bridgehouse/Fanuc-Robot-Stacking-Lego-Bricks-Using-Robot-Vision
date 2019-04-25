function [center,ProjPoint, orientation, numberofBricks] = getBrick(Morphology)

% This function takes in a segmented binary image and outputs centre and 
% the orientation of all BLOBs in the input image that has an area larger
% than a specified value. It also outputs a projected point which is used
% for calculation and for visiulisation. It also outputs the number of
% bricks found in the image.

    % Get properties of the BLOBS
    STATS = regionprops(Morphology,'all');

    % Counter initialised for counting how many bricks in the image that are
    % found
    counter = 0;

    %Go through all BLOBS found in the image
    for k = 1:length(STATS)

    % Ignore small BLOBS, we sort out the bricks
    if STATS(k).Area > 5000 

        % Increase counter by one each time a brick is found
        counter = counter + 1; 

        %Save the centre of the brick as x0 and y0 for temporary use
        x0 = STATS(k).Centroid(1);
        y0 = STATS(k).Centroid(2);

        %initialise dist to temporary hold distances
        dist = 0;

        % The point on the convex hull which has the smallest distance to the
        % centroid is found by going through all lines that together span the
        % convex hull. All the smallest distances to each line in the convex
        % hull are saved in dist.
        for i = 1:length(STATS(k).ConvexHull)
            if (i == 1)
                x1 = STATS(k).ConvexHull(end,1);
                y1 = STATS(k).ConvexHull(end,2);

                x2 = STATS(k).ConvexHull(i,1);
                y2 = STATS(k).ConvexHull(i,2);

                dist(i) = (abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - x1*y2))/(sqrt((y2-y1)^2 + (x2-x1)^2));

            else
            x1 = STATS(k).ConvexHull(i-1,1);
            y1 = STATS(k).ConvexHull(i-1,2);

            x2 = STATS(k).ConvexHull(i,1);
            y2 = STATS(k).ConvexHull(i,2);

            dist(i) = (abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - x1*y2))/(sqrt((y2-y1)^2 + (x2-x1)^2));
            end

            % Check if everything is numbers.
            if (isnan(dist(i)) == true)
                dist(i) = 1000000; % If we get a NaN number if two points are equal then we just assign a big number to that value in dist.
            end
        end

        % finds the minimum of dist (the point closest to the centroid)
        [distance(k),index(k)] = min(dist);

        % Project a point onto the line with the smallest minimum (closest to the centroid)
        % This projected point is a method found from some one else on the
        % internet.
        x1 = STATS(k).ConvexHull(index(k),1);
        y1 = STATS(k).ConvexHull(index(k),2);
        x2 = STATS(k).ConvexHull(index(k)-1,1);
        y2 = STATS(k).ConvexHull(index(k)-1,2);
        x0 = STATS(k).Centroid(1);
        y0 = STATS(k).Centroid(2);

        vector = [x1, y1; x2, y2];
        q = [x0,y0];

        p0 = vector(1,:);
        p1 = vector(2,:);
        a = [-q(1)*(p1(1)-p0(1)) - q(2)*(p1(2)-p0(2));
            -p0(2)*(p1(1)-p0(1)) + p0(1)*(p1(2)-p0(2))]; 
        b = [p1(1) - p0(1), p1(2) - p0(2);
            p0(2) - p1(2), p1(1) - p0(1)];

        % Save the proj point to the output of the function
        ProjPoint(:,counter) = -(b\a);

        %Save the centre of the brick to the output of the function
        center(counter,:) = STATS(k).Centroid;

        %Slope of the line between center and projpoint
        m = (y2-y1)/(x2-x1);

        % gives the angle between the line with the slope m and the x axis.
        orientation_temp = atand(m);

        % Since the brick is a square it is only necessary to get the
        % orientation as an angle between -90 and 90 (in fact only 0 and 90),
        % however doing -90 to 90, will maybe make less weird tool rotations.
        if (orientation_temp > 90)
            while orientation_temp > 90
                orientation_temp = orientation_temp - 90;
            end

        elseif (orientation_temp < -90)
            while orientation_temp < -90
                orientation_temp = orientation_temp + 90;
            end
        end

        % Save the orientation to the output of the function
        orientation(counter) = orientation_temp;
    end
    end

    %save the number of bricks to the output of the function.
    numberofBricks = counter;

end