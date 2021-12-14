function [normal_pca, nInlier_pca] = computePCAnormal(points, data, label, virtual, K)
% PCA normal for multi-view reconstruction
fprintf('\nComputing PCA normal...\n');
[~, dp_list] = pixel2ray(data.xp_list, label.p_list, virtual.mirror_id_p, virtual.Projs);
[~, dc_list] = pixel2ray(data.xc_list, label.c_list, virtual.mirror_id_c, virtual.Cams);

normal_pca = NaN(size(points.location));
nInlier_pca = NaN(size(points.location,1),1);

is_valid = ~isnan(points.location(:,1));
location = points.location(is_valid, :);
[normal_pca(is_valid, :), nInlier_pca(is_valid, :)] = computePCAnormalRANSAC(location, K);

normal_pca = flipPCANormalMV2(normal_pca, dp_list, dc_list);


end