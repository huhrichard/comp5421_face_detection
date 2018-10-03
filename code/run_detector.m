% Starter code prepared by James Hays for CS 143, Brown University
% This function returns detections on all of the images in a given path.
% You will want to use non-maximum suppression on your detections or your
% performance will be poor (the evaluation counts a duplicate detection as
% wrong). The non-maximum suppression is done on a per-image basis. The
% starter code includes a call to a provided non-max suppression function.
function [bboxes, confidences, image_ids] = .... 
    run_detector(test_scn_path, w, b, feature_params, threshold)
% 'test_scn_path' is a string. This directory contains images which may or
%    may not have faces in them. This function should work for the MIT+CMU
%    test set but also for any other images (e.g. class photos)
% 'w' and 'b' are the linear classifier parameters
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.

% 'bboxes' is Nx4. N is the number of detections. bboxes(i,:) is
%   [x_min, y_min, x_max, y_max] for detection i. 
%   Remember 'y' is dimension 1 in Matlab!
% 'confidences' is Nx1. confidences(i) is the real valued confidence of
%   detection i.
% 'image_ids' is an Nx1 cell array. image_ids{i} is the image file name
%   for detection i. (not the full path, just 'albert.jpg')

% The placeholder version of this code will return random bounding boxes in
% each test image. It will even do non-maximum suppression on the random
% bounding boxes to give you an example of how to call the function.

% Your actual code should convert each test image to HoG feature space with
% a _single_ call to vl_hog for each scale. Then step over the HoG cells,
% taking groups of cells that are the same size as your learned template,
% and classifying them. If the classification is above some confidence,
% keep the detection and then pass all the detections for an image to
% non-maximum suppression. For your initial debugging, you can operate only
% at a single scale and you can skip calling non-maximum suppression.

test_scenes = dir( fullfile( test_scn_path, '*.jpg' ));

%initialize these as empty and incrementally expand them.
bboxes = zeros(0,4);
confidences = zeros(0,1);
image_ids = cell(0,1);
noOfCellin1D = feature_params.template_size/feature_params.hog_cell_size;


for i = 1:length(test_scenes)
      
    fprintf('Detecting faces in %s\n', test_scenes(i).name)
    img = imread( fullfile( test_scn_path, test_scenes(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    
    %You can delete all of this below.
    % Let's create 15 random detections per image
    
    cur_bboxes = [];
    cur_confidences = [];
    sizeOfImg = size(img);

%%%%%%%%%%%%%% scale the cell size %%%%%%%%%%%%%%%%%%%%%
    % windowSize = feature_params.template_size/feature_params.hog_cell_size;
    % cellSizeUpperBound = floor(min(sizeOfImg)/noOfCellin1D);
    % multiScaleCellSize = feature_params.hog_cell_size:3:cellSizeUpperBound;
    
    % for cellSize = multiScaleCellSize
    %     hog = vl_hog(img, cellSize);
    %     windowSize = noOfCellin1D*cellSize;
    %     % size(hog)
    %     % pause;
    %     for x = 1:(size(hog,1)-noOfCellin1D+1)
    %         for y = 1:(size(hog,2)-noOfCellin1D+1)
    %             reshapedHOG = reshape(hog(x:(x+noOfCellin1D-1), y:(y+noOfCellin1D-1),:), [], 1, 1);
    %             confidence = w'*reshapedHOG+b;
    %             if confidence > -1
    %                 x_min = (x-1)*cellSize+1;
    %                 y_min = (y-1)*cellSize+1;
    %                 x_max = x_min+windowSize-1;
    %                 y_max = y_min+windowSize-1;
    %                 cur_bboxes = [cur_bboxes;y_min, x_min, y_max, x_max];
    %                 cur_confidences = [cur_confidences; confidence];
    %             end
    %         end
    %     end
    % end
    % cur_image_ids(1:length(cur_confidences),1) = {test_scenes(i).name};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% scaling the image %%%%%%%%

    minScale = feature_params.template_size/min(sizeOfImg);
    multiScale = linspace(minScale,1, 10);
    cellInWin = feature_params.template_size/feature_params.hog_cell_size;
    
    for scale = multiScale
        resizedImg = imresize(img, scale);
        hog = vl_hog(resizedImg, feature_params.hog_cell_size);
        % perm = vl_hog('permutation') ;
        % hog_reflected = vl_hog(resizedImg, feature_params.hog_cell_size);      
        for x = 1:1:(size(hog,1)-cellInWin+1)
            for y = 1:1:(size(hog,2)-cellInWin+1)
                reshapedHOG = reshape(hog(x:(x+cellInWin-1), y:(y+cellInWin-1),:), [], 1, 1);
                confidence = w'*reshapedHOG+b;
                if confidence > threshold
                    x_min = (x-1)*feature_params.hog_cell_size/scale+1;
                    y_min = (y-1)*feature_params.hog_cell_size/scale+1;
                    x_max = floor(((x-1)*feature_params.hog_cell_size)/scale)+floor(feature_params.template_size/scale);
                    y_max = floor(((y-1)*feature_params.hog_cell_size)/scale)+floor(feature_params.template_size/scale);
                    cur_bboxes = [cur_bboxes;y_min, x_min, y_max, x_max];
                    cur_confidences = [cur_confidences; confidence];
                end
                % reshapedHOG = reshape(hog_(x:(x+cellInWin-1), y:(y+cellInWin-1),:), [], 1, 1);
                % confidence = w'*reshapedHOG+b;
                % if confidence > threshold
                %     x_min = (x-1)*feature_params.hog_cell_size/scale+1;
                %     y_min = (y-1)*feature_params.hog_cell_size/scale+1;
                %     x_max = floor(((x-1)*feature_params.hog_cell_size)/scale)+floor(feature_params.template_size/scale);
                %     y_max = floor(((y-1)*feature_params.hog_cell_size)/scale)+floor(feature_params.template_size/scale);
                %     cur_bboxes = [cur_bboxes;y_min, x_min, y_max, x_max];
                %     cur_confidences = [cur_confidences; confidence];
                % end
            end
        end


    end
    cur_image_ids(1:length(cur_confidences),1) = {test_scenes(i).name};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % size(cur_bboxes)
    % size(cur_confidences)
    % cur_x_min = rand(15,1) * size(img,2);
    % cur_y_min = rand(15,1) * size(img,1);
    % cur_bboxes = [cur_x_min, cur_y_min, cur_x_min + rand(15,1) * 50, cur_y_min + rand(15,1) * 50];
    % cur_confidences = rand(15,1) * 4 - 2; %confidences in the range [-2 2]
    % cur_image_ids(1:15,1) = {test_scenes(i).name};
    
    %non_max_supr_bbox can actually get somewhat slow with thousands of
    %initial detections. You could pre-filter the detections by confidence,
    %e.g. a detection with confidence -1.1 will probably never be
    %meaningful. You probably _don't_ want to threshold at 0.0, though. You
    %can get higher recall with a lower threshold. You don't need to modify
    %anything in non_max_supr_bbox, but you can.
    if length(cur_confidences) > 0
        [is_maximum] = non_max_supr_bbox(cur_bboxes, cur_confidences, size(img));

        cur_confidences = cur_confidences(is_maximum,:);
        cur_bboxes      = cur_bboxes(     is_maximum,:);
        cur_image_ids   = cur_image_ids(  is_maximum,:);
     
        bboxes      = [bboxes;      cur_bboxes];
        confidences = [confidences; cur_confidences];
        image_ids   = [image_ids;   cur_image_ids];
    end
end




