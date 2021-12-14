function [min_distance_possible_multi, label_c_multi] = computeEpipolarDistance_multi(xp, xc_multi, label_possible_p, label_possible_c_multi, virtual)

    % Collect epipolar distances for all measurements of xc_multi
    nObservation = size(xc_multi, 3);
    nPossible_p = length(label_possible_p);
    
    min_distance_possible_multi = NaN(nPossible_p, nObservation);
    label_c_multi = NaN(nPossible_p, nObservation);
    for i = 1:nObservation
        % compute epipolar distance for single pair of (xp, xc)
        % "how good is each possible label_p for given xc?"
        [min_distance_possible, label_c] = computeEpipolarDistance_pair(xp, xc_multi(:,:,i), label_possible_p, label_possible_c_multi{i}, virtual);
        min_distance_possible_multi(:, i) = min_distance_possible;
        label_c_multi(:, i) = label_c;
    end

end
