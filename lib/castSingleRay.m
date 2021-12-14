function direction = castSingleRay(Cam, x)


fx = Cam.K(1,1);
fy = Cam.K(2,2);
px = Cam.K(1,3);
py = Cam.K(2,3);

direction = (x(1)-px)/fx*Cam.R(1,:) + (x(2)-py)/fy*Cam.R(2,:) + Cam.R(3,:);
direction = direction ./ repmat(sqrt(sum(direction.^2, 2)), [1 3]);
direction = direction';


end
