function [Point, idx_done, sum_hit_inf] = runRayTracingWithMirrorsOnlySubpixel(Cam, Mirrors, max_reflection, pixels)
% runRayTracingWithMirrorsOnlySubpixel
%
% Input
%     Cam               Structure of camera.
%     Mirrors           Structure of planar mirrors.
%     Object            Structure of object mesh.
%     max_reflection    Maximum number of reflection.
%     pixels            pixels to backproject (nPixel x 2)

% Output
%     Point             Structure of points. 
%                       (location, distance, mirror_sequence, 
%                       fn_intersection, foreshortening)
%     idx_done          Index of valid pixels (hit object or go infinite)
%                       (If it is small, increase max_reflection)
%     sum_hit_inf    Number of pixels that hit the infinity



% cast rays from camera
nRay = size(pixels, 1);

ray.origin = repmat(Cam.C', [nRay 1]); % MNx3 vector ray origin
ray.direction = castRayFromPixels(pixels, Cam.K, Cam.R); % MNx3 vector ray direction

% initialize output
Point.location = NaN(nRay, 3);
Point.distance = zeros(nRay, 1);
Point.mirror_sequence = zeros(nRay, 1);
Point.foreshortening = NaN(nRay, 1); % cos from camera direction (actually not foreshortening)
Point.fn_intersection = NaN(nRay, 3); % face normal at intersection side
Point.idx_f = NaN(nRay, 1); % face at intersection
Point.direction_final = NaN(nRay, 3); % final direction of the ray before hitting the object

sum_hit_hole = 0;
idx_hit_hole = false(nRay, 1);

sum_hit_inf = 0;

% set parameters
nMirror = length(Mirrors);

idx_done = false(nRay, 1);
ray_undone = ray;
% fprintf('\n======= Ray tracing (max_reflection = %d) =======\n', max_reflection);
% fprintf('%10s \t %10s \t %10s \t %10s \t %s (%d) \n', ...
%     'Reflect', 'hit_hole', 'hit_inf', 'hit_mirror', 'done', nRay);

for iReflection = 1:max_reflection
    % set variables
    num_undone = size(ray_undone.direction, 1);
    location_mirror = NaN(num_undone, 3, nMirror);
    direction_mirror = NaN(num_undone, 3, nMirror);
    distance_mirror = Inf(num_undone, 1, nMirror);
    
    % ray tracing to closest mirror
    for iMirror = 1:nMirror
        [location_temp, direction_temp, distance_temp] = intersectRayMirror(ray_undone, Mirrors{iMirror});
        location_mirror(:,:,iMirror) = location_temp;
        direction_mirror(:,:,iMirror) = direction_temp;
        distance_mirror(:,:,iMirror) = distance_temp;
    end
    [min_distance_mirror, idx_min_distance_mirror] = min(distance_mirror, [], 3);
    
    [I1, I2] = ndgrid(1:num_undone, 1:3);
    ind = sub2ind([num_undone 3 nMirror], I1, I2, repmat(idx_min_distance_mirror, [1 3]));
    min_location_mirror = location_mirror(ind);
    min_direction_mirror = direction_mirror(ind);

    % if object is closer, ray tracing is done for corresponding pixel
    [Point, idx_hit_mirror, idx_hit_inf] = updateHitPointMirrorOnly(Point, min_distance_mirror, idx_min_distance_mirror, idx_done);
    
    % count each kind of reflection (debug)
    sum_hit_hole = sum_hit_hole + sum(idx_hit_hole);
    sum_hit_inf = sum_hit_inf + sum(idx_hit_inf);

    % update ray (after reflection)
    ray_undone.origin = min_location_mirror(idx_hit_mirror, :); % NotImplemented
    ray_undone.direction = min_direction_mirror(idx_hit_mirror, :); % NotImplemented
    
    % update idx_done
    idx_done(~idx_done) = ~idx_hit_mirror; % done if it did not hit mirror
    
%     fprintf('%10d \t %10d \t %10d \t %10d \t %10d\n', iReflection, sum(idx_hit_hole), sum(idx_hit_inf), sum(idx_hit_mirror), sum(~idx_hit_mirror))

    if all(idx_done)
%         fprintf('All pixels done!\n');
        break;
    end
    
end

% fprintf('-----------------------------------------------------------------------\n')
% fprintf('Total \t\t %10d \t %10d \t %10d \t %10d\n', sum_hit_hole, sum_hit_inf, sum(idx_hit_mirror), sum(idx_done))
% fprintf('Ratio \t\t %10.1f \t %10.1f \t %10.1f \t %10.1f\n', 100*sum_hit_hole/(M*N), 100*sum_hit_inf/(M*N), 100*sum(idx_hit_mirror)/(M*N), (100*sum(idx_done)/(M*N)))


Point.location(~idx_done, :) = Inf;
Point.distance(~idx_done, :) = Inf;
% Point.mirror_sequence(~idx_done, :) = NaN;
Point.foreshortening(~idx_done, :) = NaN;
Point.fn_intersection(~idx_done, :) = NaN;
Point.idx_f(~idx_done, :) = NaN;
Point.direction_final(~idx_done, :) = NaN;

% toc;

end
