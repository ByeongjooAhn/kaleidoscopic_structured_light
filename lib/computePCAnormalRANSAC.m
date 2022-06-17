function [normals, nInlier] = computePCAnormalRANSAC(points, K)
    nPoint = size(points, 1);
    normals = NaN(nPoint, 3);
    nInlier = NaN(nPoint, 1);
    
    fitFcn = @(points) fitPlane(points);
    distFcn = @(normal, points) distPlane(normal, points);
    idx = knnsearch(points, points, 'K', K);
    for iPoint = 1:nPoint
        if mod(iPoint, 10000) == 0
            fprintf('%d/%d\n', iPoint, nPoint);
        end
                
        data = points(idx(iPoint, :), :);
        
        sampleSize = 3;
        maxDistance = 0.25; 
        try
            [normal, inlierIdx] = ransac(data,fitFcn,distFcn,sampleSize,maxDistance);
            % save
            normal_refine = fitPlane(data(inlierIdx, :));
            normals(iPoint, :) = normal_refine';
            nInlier(iPoint, :) = sum(inlierIdx);
        catch
            continue;
        end

    end
    

end


function normal = fitPlane(points_neighbor)
    coeff = pca(points_neighbor);
    normal = coeff(:,end)';
end

function dist = distPlane(normal, points_neighbor)
    nx = points_neighbor*normal';
    d = mean(nx);
    dist = abs(nx - d);
end
