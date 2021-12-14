function [label, d_epipolar_list, num_candidate_list] = runEpipolarLabelingBackproject(data, virtual)

%% set parameters
xp_list = data.xp_list;
xc_list = data.xc_list;
nScan = size(xp_list, 1);

label.p_list = NaN(nScan, 1);
label.c_list = NaN(nScan, size(xc_list,3));

Proj0 = virtual.Projs{1};
Cam0 = virtual.Cams{1};
Mp = Proj0.M;
Np = Proj0.N;
Mc = Cam0.M;
Nc = Cam0.N;

% ambiguity by the identically mirrored labels
max_nAmbiguous = 10;
label.p_list_all = NaN(nScan, max_nAmbiguous);
label.c_list_all = NaN(nScan, size(xc_list,3), max_nAmbiguous);

% for backprojection
Cam0 = virtual.Cams{1};
Mirrors = virtual.Mirrors;
mirror_angle = acosd(dot(Mirrors{1}.n, -Mirrors{3}.n));
max_reflection = ceil(360 / mirror_angle);

d_epipolar_list = NaN(nScan, size(xc_list,3));
num_candidate_list = NaN(nScan, 1);

for iScan = 1:nScan 
    if mod(iScan, 100000) == 0
        fprintf('%d/%d \n', iScan, nScan);
    end

    xp = xp_list(iScan, :);
    xc_multi = xc_list(iScan, :, :);
    is_observed = squeeze(~isnan(xc_multi(:,1,:)));
    xc_multi = xc_multi(:,:,is_observed);

    % label_c_noobject
    pixels = permute(xc_multi, [3 2 1]);
    [Point_backproject, ~, ~] = runRayTracingWithMirrorsOnlySubpixel(Cam0, Mirrors, max_reflection, pixels);
    label_c_noobject_backproject = Point_backproject.mirror_sequence;
    
    label_possible_p = computeLabelPossible(xp, virtual.label_p_noobject, Mp, Np);
    [label_possible_c_multi, is_c_edge] = computeLabelPossibleMultiBackproject(xc_multi, label_c_noobject_backproject, Mc, Nc);
            
    
    % Skip edge of the mirrors
    is_p_edge = isnan(label_possible_p(1));
    if is_p_edge || all(is_c_edge)
        continue;
    end
    xc_multi = xc_multi(:,:,~is_c_edge);
    label_possible_c_multi = label_possible_c_multi(~is_c_edge);

    % compute epipolar distances
    [d_epipolar, label_p, label_c_multi, num_candidate, label_p_all, label_c_multi_all] = ...
        computeEpipolarDistances(xp, xc_multi, label_possible_p, label_possible_c_multi, virtual);
    
    % debug: label ambiguity
    num_candidate_list(iScan) = num_candidate;
    
    % save in the original order
    d_epipolar_temp = NaN(1, length(is_c_edge));
    d_epipolar_temp(~is_c_edge) = d_epipolar;
    
    label_c_temp = NaN(1, length(is_c_edge));
    label_c_temp(~is_c_edge) = label_c_multi;
    
    d_epipolar_list(iScan, is_observed) = d_epipolar_temp;
    label.p_list(iScan) = label_p;
    label.c_list(iScan, is_observed) = label_c_temp;
    
    label_c_temp_all = NaN(1, length(is_c_edge), num_candidate);
    label_c_temp_all(:, ~is_c_edge, :) = permute(label_c_multi_all, [3 2 1]);
    
    label.p_list_all(iScan, 1:num_candidate) = label_p_all;
    label.c_list_all(iScan, is_observed, 1:num_candidate) = label_c_temp_all;
    
end

end


