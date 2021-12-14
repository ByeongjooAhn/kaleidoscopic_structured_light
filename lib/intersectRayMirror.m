function [location, direction, distance] = intersectRayMirror(ray, Mirror)
% intersectRayMirror     intersect Ray and Planar mirror
%
% Input:
%     ray           Ray. (MNx3 origin, MNx3 direction)
% 
% Output:
%     location      MNx3 vector ray direction.
%     direction     MNx3 vector ray direction.
%     distance      MNx1 vector ray direction.

t = (Mirror.d - ray.origin*Mirror.n')./(ray.direction*Mirror.n');

cos_angle = -ray.direction*Mirror.n';
idx_reflect = (t > 0) & (cos_angle > 0);

location = ray.origin + repmat(t, [1 3]).*ray.direction;
direction = 2*cos_angle*Mirror.n + ray.direction;
direction = direction ./ repmat(sqrt(sum(direction.^2, 2)), [1 3]);

distance = t;

location(~idx_reflect, :) = NaN;
direction(~idx_reflect, :) = NaN;
distance(~idx_reflect, :) = Inf;

end