function [Point, idx_hit_mirror, idx_hit_inf] = updateHitPointMirrorOnly(Point, min_distance_mirror, idx_min_distance_mirror, idx_done)

% check rays hitting object
idx_hit_mirror = ~isinf(min_distance_mirror);
idx_hit_inf = isinf(min_distance_mirror);

% combine the depth to object and the depth to mirror
distance_mirror = min_distance_mirror;
distance_mirror(~idx_hit_mirror) = 0;
distance_update = distance_mirror;
distance_update(idx_hit_inf) = Inf;

% combine mirror sequence (mirror id should be 1 digit)
mirror_sequence_update = zeros(size(distance_update));
mirror_sequence_update(idx_hit_mirror) = idx_min_distance_mirror(idx_hit_mirror);

% update Point
Point.location(~idx_done, :) = Inf;
Point.distance(~idx_done, :) = Point.distance(~idx_done, :) + distance_update;
Point.mirror_sequence(~idx_done, :) = 10*Point.mirror_sequence(~idx_done, :) + mirror_sequence_update;
Point.foreshortening(~idx_done, :) = NaN;
Point.fn_intersection(~idx_done, :) = NaN;
Point.idx_f(~idx_done, :) = NaN;
Point.direction_final(~idx_done, :) = NaN;

end
