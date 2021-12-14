function [d_epipolar, label_p, label_c_multi, num_candidate, label_p_all, label_c_multi_all, label_c_multi_possible] = computeEpipolarDistances(xp, xc_multi, label_possible_p, label_possible_c_multi, virtual)

    % compute epipolar distances of possible label_p for one projector pixel and best camera pixel
    [min_distance_possible_multi, label_c_multi_possible] = computeEpipolarDistance_multi(xp, xc_multi, label_possible_p, label_possible_c_multi, virtual);
    
    % take the best projector label
    mean_epipolar_dist = mean(min_distance_possible_multi, 2);
    [min_best, idx_best] = min(mean_epipolar_dist);

    th = min_best+1e-2; % 1 pixel
    num_candidate = sum(mean_epipolar_dist<th);
    
    % save
    d_epipolar = min_distance_possible_multi(idx_best,:);
    label_p = label_possible_p(idx_best);
    label_c_multi = label_c_multi_possible(idx_best, :);

    % all
    is_valid_all = mean_epipolar_dist < th;
    label_p_all = label_possible_p(is_valid_all);
    label_c_multi_all = label_c_multi_possible(is_valid_all, :);

end
