% main file

% From this file the the connection to the camera and the robot are
% established. The segmentation, blob-analysis and getting the brick
% positions are called 4 times. One time for each color and saved in
% different variable.
% The last part of the script is a switch case that determines based on the
% order of bricks which brick to pick next. 
% The movement of the robot is also done within this script.

%%
% Connect to camera
cam = webcam
%%
% acquire background picture
%imgBackground = snapshot(cam);

%%
% Connect to robot
r = RobotConnector

%%
clear bricks_red bricks_green bricks_blue bricks_yellow
% define brick height 19.1

brickHeight = 19.1;

% define speed of robot given in percentage
speed = 100;

% define home position
home = [-1.7122 -339.9580  315.3710 -167.4320    0.9766    0.2525];


% define drop of position and drop of home
drop_of = [-229.9120 -624.0100  -62.8188 -167.5450    0.9537   -3.2832];
drop_of_home = [-229.9120 -624.0100  0 -167.5450    0.9537   -3.2832];

% define order of bricks
order_of_colors = [2, 2, 4, 3, 3, 1, 1];

% definition for the case cycle:
    %  1: red
    %  2: green
    %  3: blue
    %  4: yellow

% move robot to home position
r.moveJoint(home(1),home(2),home(3),home(4),home(5),home(6),speed)

pause(0.1)

% open gripper
r.openGrapper


% acquire picture with lego bricks
%imgBricks = snapshot(cam);

% backgroundsubtraction
%image = backgroundsubtraction(imgBricks,imgBackground);


%----------------------------------------------------------------------
% Segmentation RED
segmented_image = segmentation(image,'red');

% find bricks in image
[center, ProjPoint, orientation, numberofBricks] = getBrick(segmented_image);

% convert pixels to tool coordinates and save brick positions and orientations in array
bricks_red = pixelPos2mmPos(center,orientation);


%----------------------------------------------------------------------
% Segmentation GREEN
segmented_image = segmentation(image,'green');

% find bricks in image
[center, ProjPoint, orientation, numberofBricks] = getBrick(segmented_image);

% convert pixels to tool coordinates and save brick positions and orientations in array
bricks_green = pixelPos2mmPos(center,orientation);


%----------------------------------------------------------------------
% Segmentation BLUE
segmented_image = segmentation(image,'blue');

% find bricks in image
[center, ProjPoint, orientation, numberofBricks] = getBrick(segmented_image);

% convert pixels to tool coordinates and save brick positions and orientations in array
bricks_blue = pixelPos2mmPos(center,orientation);

%----------------------------------------------------------------------
% Segmentation YELLOW
segmented_image = segmentation(image,'yellow');

% find bricks in image
[center, ProjPoint, orientation, numberofBricks] = getBrick(segmented_image);

% convert pixels to tool coordinates and save brick positions and orientations in array
bricks_yellow = pixelPos2mmPos(center,orientation);

%----------------------------------------------------------------------

counters = zeros(1,4)

for i = 1:length(order_of_colors)
    switch order_of_colors(i)
        case 1
            % counter1
            counters(1) = counters(1) + 1;
            
            % save position from array corresponding to the counter
            position = bricks_red(counters(1),:)
            
        case 2  % GREEN
            
            % counter2
            counters(2) = counters(2) + 1;
            
            % save position from array corresponding to the counter
            position = bricks_green(counters(2),:);

            
        case 3  % BLUE
            % counter3
            counters(3) = counters(3) + 1;
            
            % save position from array corresponding to the counter
            position = bricks_blue(counters(3),:);

        case 4  % YELLOW
            % counter4
            counters(4) = counters(4) + 1;
            
            % save position from array corresponding to the counter
            position = bricks_yellow(counters(4),:);
 
    end
    

    % move robot to brick position + 60 mm in height
    r.moveJoint(position(1),position(2),position(3)+60,position(4),position(5),position(6),speed)
    
    pause(0.1)
    
    % move robot to brick position
    r.moveJoint(position(1),position(2),position(3),position(4),position(5),position(6),speed)
     
    pause(0.1)
    
    % close gripper
    r.closeGrapper
    
    pause(0.1)
    
    % move robot to brick position + 60 mm in height
    r.moveJoint(position(1),position(2),position(3)+60,position(4),position(5),position(6),speed)

    pause(0.1)
    
    % move robot to drop of position home (z value should grow with i*brickHeight)
    r.moveJoint(drop_of_home(1),drop_of_home(2),drop_of_home(3)+(i-1)*brickHeight,drop_of_home(4),drop_of_home(5),drop_of_home(6),speed)

    pause(0.1)
    
    % move robot to drop of position (z value should grow with i*brickHeight)
    r.moveJoint(drop_of(1),drop_of(2),drop_of(3)+(i-1)*brickHeight,drop_of(4),drop_of(5),drop_of(6),speed)
    
    pause(0.1)
    
    % open gripper
    r.openGrapper
    
    pause(0.1)
    
    % move robot to drop of position home (z value should grow with i*brickHeight)
    r.moveJoint(drop_of_home(1),drop_of_home(2),drop_of_home(3)+(i-1)*brickHeight,drop_of_home(4),drop_of_home(5),drop_of_home(6),speed)

    % move robot to home position
    r.moveJoint(home(1),home(2),home(3),home(4),home(5),home(6),speed)
    
end




