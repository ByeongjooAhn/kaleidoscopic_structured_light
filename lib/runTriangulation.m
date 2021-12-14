function [points, label] = runTriangulation(data, label_in, virtual)
%% RANSAC
% multi-view triangulation
mode = 4;
[points_temp, ~, label_c_used] = reconstructPoints(data, label_in, virtual, mode);

% thresholding with the number of used rays
label = label_in;
label.c_list = label_c_used;

th_ray = 2;
is_unstable = points_temp.nObservation < th_ray;
label.c_list(is_unstable, :) = NaN;


%% Final reconstruction
mode = 2;
[points, ~, ~] = reconstructPoints(data, label, virtual, mode);


end
