function [points, label] = runEpipolarLabeling(data, virtual)

% Input: data
% Output: reconstructed point cloud, label

%% set parameters
Mp = virtual.systemParams.Mp;
Np = virtual.systemParams.Np;
Mc = virtual.systemParams.Mc;
Nc = virtual.systemParams.Nc;

%% binning
xc_list_round = round(data_undistort.xc_list);
xc_list_round(:,1,:) = max(1, min(xc_list_round(:,1,:), Nc, 'includenan'), 'includenan');
xc_list_round(:,2,:) = max(1, min(xc_list_round(:,2,:), Mc, 'includenan'), 'includenan');
data_undistort.xc_list = xc_list_round;

%% labeling
[label_in, data] = estimateLabelBackproject(data, virtual);


mode = 4; 
[points_temp, ~, label_c_used] = reconstructPoints(data, label_in, virtual, mode);

% thresholding with the number of used rays
label = label_in;
label.c_list = label_c_used;

th_ray = 2;
is_unstable = points_temp.nObservation < th_ray;
label.c_list(is_unstable, :) = NaN;

%% evaluate label
m_evaluate_synthetic;

wrong_c = (label_test.c_list ~= label_gt.c_list) & ~isnan(label_test.c_list);
wrong_c_repmat = repmat(wrong_c, [1 1 2]);
xc_all = reshape(permute(data.xc_list, [1 3 2]), [], 2);
xc_wrong = xc_all(wrong_c_repmat);
xc_wrong = reshape(xc_wrong, [], 2);

label_wrong = label.c_list(wrong_c);
label_wrong_gt = label_gt.c_list(wrong_c);
length(label_wrong)
% 
% figure; imshow(data.imgScan1_rgb); hold on;
% plot(xc_wrong(:,1), xc_wrong(:,2), 'co');

%% location
mode = 2;
[points, ~, ~] = reconstructPoints(data, label, virtual, mode);

%% pca normal
% K = 10;
% points.normal_pca = computePCAnormal(points, data, label, virtual, K);
% points.normal = points.normal_pca;

%% save
% pc = pointCloud(points.location, 'Normal', points.normal);


end