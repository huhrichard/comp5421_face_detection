% Starter code prepared by James Hays for CS 143, Brown University
% This function should return negative training examples (non-faces) from
% any images in 'non_face_scn_path'. Images should be converted to
% grayscale, because the positive training data is only available in
% grayscale. For best performance, you should sample random negative
% examples at multiple scales.

function features_neg = get_random_negative_features(non_face_scn_path, feature_params, num_samples)
% 'non_face_scn_path' is a string. This directory contains many images
%   which have no faces in them.
% 'feature_params' is a struct, with fields
%   feature_params.template_size (probably 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
% 'num_samples' is the number of random negatives to be mined, it's not
%   important for the function to find exactly 'num_samples' non-face
%   features, e.g. you might try to sample some number from each image, but
%   some images might be too small to find enough.

% 'features_neg' is N by D matrix where N is the number of non-faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
% num_images = length(image_files);

% randSample = ceil(num_samples/(2*num_images));
% features_neg = [];
% windowSize = feature_params.template_size;
% noOfCell = feature_params.template_size/feature_params.hog_cell_size;
% for i = 1:num_images
% 	im = imread(strcat(non_face_scn_path,'/', image_files(i).name));
% 	if(size(im,3) > 1)
%         im = rgb2gray(im);
%     end
% 	sizeOfImg = size(im);
% 	cellSizeUpperBound = min([feature_params.hog_cell_size*2, floor(min(sizeOfImg)/noOfCell)]);
% 	randCellSize = randi([floor(feature_params.hog_cell_size/2) cellSizeUpperBound], 1, randSample);
% 	% randW = randi([1 (sizeOfImg(1)-windowSize+1)], 1, randSample);
% 	% randH = randi([1 (sizeOfImg(2)-windowSize+1)], 1, randSample);
% 	im = single(im);
% 	for j = 1:randSample
% 		randWinSize = noOfCell*randCellSize(j);
% 		randW = randi([1 (sizeOfImg(1)-randWinSize+1)],1, 1);
% 		randH = randi([1 (sizeOfImg(2)-randWinSize+1)],1, 1);
% 		hog = vl_hog(im(randW:(randW+randWinSize-1), randH:(randH+randWinSize-1)), randCellSize(j));
% 		features_neg = [features_neg, squeeze(reshape(hog, [], 1, 1))];

% 		perm = vl_hog('permutation');
% 		hog = vl_hog(im(randW:(randW+randWinSize-1), randH:(randH+randWinSize-1)), randCellSize(j));
% 		features_neg = [features_neg, squeeze(reshape(hog, [], 1, 1))];
% 	end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
% num_images = length(image_files);

% randSample = ceil(num_samples/num_images);
% features_neg = [];
% windowSize = feature_params.template_size;
% noOfCell = feature_params.template_size/feature_params.hog_cell_size;
% for i = 1:num_images
% 	im = imread(strcat(non_face_scn_path,'/', image_files(i).name));
% 	if(size(im,3) > 1)
%         im = rgb2gray(im);
%     end
% 	sizeOfImg = size(im);
% 	% cellSizeUpperBound = min([feature_params.hog_cell_size*2, floor(min(sizeOfImg)/noOfCell)]);
% 	% randCellSize = randi([floor(feature_params.hog_cell_size/2) cellSizeUpperBound], 1, randSample);
% 	randW = randi([1 (sizeOfImg(1)-windowSize+1)], 1, randSample);
% 	randH = randi([1 (sizeOfImg(2)-windowSize+1)], 1, randSample);
% 	im = single(im);
% 	for j = 1:randSample
% 		% randWinSize = noOfCell*randCellSize(j);
% 		% randW = randi([1 (sizeOfImg(1)-randWinSize+1)],1, 1);
% 		% randH = randi([1 (sizeOfImg(2)-randWinSize+1)],1, 1);
% 		hog = vl_hog(im(randW(j):(randW(j)+windowSize-1), randH(j):(randH(j)+windowSize-1)), feature_params.hog_cell_size);
% 		features_neg = [features_neg, squeeze(reshape(hog, [], 1, 1))];

% 		perm = vl_hog('permutation');
% 		hog = vl_hog(im(randW(j):(randW(j)+windowSize-1), randH(j):(randH(j)+windowSize-1)), feature_params.hog_cell_size);
% 		features_neg = [features_neg, squeeze(reshape(hog, [], 1, 1))];

% 	end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
num_images = length(image_files);
randSample = ceil(num_samples/num_images);
features_neg = [];
windowSize = feature_params.template_size;
noOfCell = feature_params.template_size/feature_params.hog_cell_size;
for i = 1:num_images
	im = imread(strcat(non_face_scn_path,'/', image_files(i).name));
	if(size(im,3) > 1)
        im = rgb2gray(im);
    end
	sizeOfImg = size(im);
	% cellSizeUpperBound = min([feature_params.hog_cell_size*2, floor(min(sizeOfImg)/noOfCell)]);
	% randCellSize = randi([floor(feature_params.hog_cell_size/2) cellSizeUpperBound], 1, randSample);
	randW = randi([1 floor(sizeOfImg(1)/feature_params.hog_cell_size)-noOfCell+1], 1, randSample);
	randH = randi([1 floor(sizeOfImg(2)/feature_params.hog_cell_size)-noOfCell+1], 1, randSample);
	im = single(im);
	hog = vl_hog(im, feature_params.hog_cell_size);
	perm = vl_hog('permutation');

	hog_Reflected = vl_hog(im, feature_params.hog_cell_size);
	for j = 1:randSample
		% randWinSize = noOfCell*randCellSize(j);
		% randW = randi([1 (sizeOfImg(1)-randWinSize+1)],1, 1);
		% randH = randi([1 (sizeOfImg(2)-randWinSize+1)],1, 1);
		randSampledHog = hog(randW(j):(randW(j)+noOfCell-1), randH(j):(randH(j)+noOfCell-1),:);
		features_neg = [features_neg, squeeze(reshape(randSampledHog, [], 1, 1))];

		randSampledHog_Reflected = hog_Reflected(randW(j):(randW(j)+noOfCell-1), randH(j):(randH(j)+noOfCell-1),:);
		features_neg = [features_neg, squeeze(reshape(randSampledHog_Reflected, [], 1, 1))];
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% size(features_neg)
% % placeholder to be deleted
% features_neg = rand(100, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);