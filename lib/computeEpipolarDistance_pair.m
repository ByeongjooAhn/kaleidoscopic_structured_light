function [min_distance_possible, label_c] = computeEpipolarDistance_pair(xp, xc, label_possible_p, label_possible_c, virtual)

nPossible_p = length(label_possible_p);
nPossible_c = length(label_possible_c);

min_distance_possible = NaN(nPossible_p, 1);
label_c = NaN(nPossible_p, 1);


% possible projector
for iP = 1:nPossible_p
    label_possible_p_i = label_possible_p(iP);
    iProj = (virtual.mirror_id_p == label_possible_p_i);
    
    d_min = Inf;
    iC_min = 0;

    % possible camera
    for iC = 1:nPossible_c
        label_possible_c_i = label_possible_c(iC);
        iCam = (virtual.mirror_id_c==label_possible_c_i);
        if ~any(iCam)
            Proj_i = virtual.Projs{iProj};
            Cam_i = makeVirtualCameras(virtual.Cams{1}, virtual.Mirrors, label_possible_c_i);
            [F, E, R, t] = computeFundamentalMatrix(Proj_i, Cam_i{1});
        else
            F = virtual.epipolar.F_cp{iCam, iProj};
        end

        lp = F*[xp 1]';
        lc = F'*[xc 1]';
        d_temp = abs(dot(lp, [xc 1]))/norm(lp(1:2)) +...
                abs(dot(lc, [xp 1]))/norm(lc(1:2));

        if d_temp < d_min
            d_min = d_temp;
            iC_min = iC;
        end
    end
    
    min_distance_possible(iP) = d_min;
    label_c(iP) = label_possible_c(iC_min);

end




end