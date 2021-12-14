function [F, E, R, t] = computeFundamentalMatrix(cam1, cam2)

%x_2 F x_1 = 0

% Compute R,t from camera pose
R1 = cam1.R;
t1 = -R1*cam1.C;

R2 = cam2.R;
t2 = -R2*cam2.C;

% Homogeneous transformation
% P1 = [R1 t1; zeros(1, 3) 1];
inv_P1 = [R1' -R1'*t1; zeros(1, 3) 1];
P2 = [R2 t2; zeros(1, 3) 1];

% Relative T
P = P2*inv_P1;

% Relative R, t
R = P(1:3, 1:3);
t = P(1:3, 4);

% Essential matrix
t_ = crossMatrix(t);
E = t_*R;
F = cam2.inv_K'*E*cam1.inv_K;

end
