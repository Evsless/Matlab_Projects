clc; clear; close all;

%% Choose an image to analyse
[image, path] = uigetfile('.jpg', 'Select image');     % Choose an image
image = imread([path image]);                          % Upload an image

%% Choose an image pattern
[pattern, path] = uigetfile('*.jpg; *.JPG; *.jpeg; ...*.JPEG; *.png; *.PNG; *.tif; *.TIF',...
    'Select a pattern', 'MultiSelect', 'on');   % Choose a pattern

pattern = convertCharsToStrings(pattern);       % Convertion to array of strings to recieve num of patterns

num_of_patterns = length(pattern);              % Number of patterns

peak_offset = zeros(length(pattern), 2);        % Memory allocation(for peak offset 2-dimension vector)
pattern_size = zeros(length(pattern), 2);       % Memory allocation(for pattern size 2-dimension vector)

for i = 1:length(pattern)
    im_pattern = imread([path convertStringsToChars(pattern(i))]);   % Upload a pattern
    pattern_size(i, :) = size(im_pattern(:,:,1));                    % Adding a size of a pattern               
    cr_corr = normxcorr2(im_pattern(:,:,1), image(:,:,1));           % Cross corelation of an immage and a pattern
    
    [max_c, imax] = max(abs(cr_corr(:)));                            % Maximum of a function
    [ypeak, xpeak] = ind2sub(size(cr_corr), imax(1));                % A pattern area on a cr_corr image
    
    peak_offset(i, :) = ...
     [(xpeak - size(im_pattern,2)) (ypeak - size(im_pattern,1))];    % A pattern area on a original image    
end

%% Representation of the results
figure(1)
    imshow(image); hold on;
    for i = 1:length(pattern)
        rectangle('Position', [peak_offset(i,:), pattern_size(i, :)],...    % Drawing a border of patterns
            'EdgeColor', 'green', 'LineWidth', 2); hold on;
    end