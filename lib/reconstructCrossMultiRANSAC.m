function [points, label_p_all, label_c_used] = reconstructCrossMultiRANSAC(op_list, dp_list, oc_list, dc_list, label)

% input
nScan = size(op_list, 1);

% output
points.location = NaN(nScan, 3);
points.err_triangulation = NaN(nScan, 1);
points.nObservation = NaN(nScan, 1);

label_c_used = NaN(size(label.c_list));

% parameters for ransac
sampleSize = 1;
maxDistance = 0.5; % mm

distFcn = @(X, ray_c) distMVTRI(X, ray_c);


for iScan = 1:nScan
    
    if mod(iScan, 10000) == 0
        fprintf('%d/%d \n', iScan, nScan);
    end

    if isnan(dp_list(iScan, 1))
        continue;
    end

    op = op_list(iScan, :);
    dp = dp_list(iScan, :);
    ray_p = [dp op];

    oc_multi = oc_list(iScan, :, :);
    dc_multi = dc_list(iScan, :, :);

    is_observed = squeeze(~isnan(oc_multi(1,1,:)));

    if any(is_observed)
        
        fitFcn = @(ray_c) fitMVTRI(ray_c, ray_p);

        oc_multi = oc_multi(:, :, is_observed);
        dc_multi = dc_multi(:, :, is_observed);
        
        oc_multi = permute(oc_multi, [3 2 1]);
        dc_multi = permute(dc_multi, [3 2 1]);

        ray_c = [dc_multi oc_multi];

        try
            [X, inlierIdx] = ransac(ray_c, fitFcn, distFcn, sampleSize, maxDistance);
            
            % save
            X_refine = fitMVTRI(ray_c(inlierIdx, :), ray_p);
            points.location(iScan, :) = X_refine';

            points.err_triangulation(iScan) = mean(distMVTRI(X_refine, [dp op; ray_c(inlierIdx, :)]));
            points.nObservation(iScan) = sum(inlierIdx);
            
            iMeasurement = find(is_observed);
            iMeasurement_used = iMeasurement(inlierIdx);
            label_c_used(iScan, iMeasurement_used) = label.c_list(iScan, iMeasurement_used);
            
        catch ME
            if ~strcmp(ME.identifier, 'vision:ransac:notEnoughInliers')
                fprintf('%s\n', ME.message);
                error('something is wrong');                
            end
        end
        
    end
end

label_p_all = label.p_list;


end

% 
% function X = fitMVTRI(rays)
% 
%     d_i = rays(:, 1:3);
%     o_i = rays(:, 4:6);
% 
%     A = zeros(3);
%     b = zeros(1, 3);
%     c = 0;
% 
%     for ii = 1:size(rays, 1)
%         d = d_i(ii, :)';
%         o = o_i(ii, :)';
%         A_i = eye(3) - d*d';
%         b_i = o'*(A_i);
%         c_i = o'*(A_i)*o;
% 
%         A = A + A_i;
%         b = b + b_i;
%         c = c + c_i;
%     end
% 
%     % compute point
%     X = A\b';
%     
% end

function X = fitMVTRI(ray_c, ray_p)

    dp = ray_p(1, 1:3);
    op = ray_p(1, 4:6);

    dc_multi = ray_c(:, 1:3);
    oc_multi = ray_c(:, 4:6);
    
    dc_multi = permute(dc_multi, [3 2 1]);
    oc_multi = permute(oc_multi, [3 2 1]);
    
    X = computeNearestPointFromRays(op, dp, oc_multi, dc_multi);
    X = X';
    
end

function dist = distMVTRI(X, rays)

    d_i = rays(:, 1:3);
    o_i = rays(:, 4:6);

    dist = zeros(size(rays,1), 1);

    for ii = 1:size(rays, 1)
        d = d_i(ii, :)';
        o = o_i(ii, :)';
        A_i = eye(3) - d*d';
        b_i = o'*(A_i);
        c_i = o'*(A_i)*o;

        dist(ii) = sqrt(X'*A_i*X - 2*b_i*X + c_i);

    end

end


function isValid = isInsideMirrorSystem(X)
%     isValid = is_inside_system(X, systemParams);
    isValid = 1;
end
