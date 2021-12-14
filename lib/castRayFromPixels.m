function direction = castRayFromPixels(pixels, K, R)
% castRayFromCamera     Ray direction of camera pixels.
%
% Input:
%     Cam         Camera.
% 
% Output:
%     direction   Mx3 vector ray direction.

X = pixels(:,1);
Y = pixels(:,2);

fx = K(1,1);
fy = K(2,2);
px = K(1,3);
py = K(2,3);

direction =(X(:)-px)/fx*R(1,:) + (Y(:)-py)/fy*R(2,:) + repmat(R(3,:), [size(X(:), 1) 1]);
direction = direction ./ repmat(sqrt(sum(direction.^2, 2)), [1 3]);



end
