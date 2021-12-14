function cam_virtual = makeVirtualCamera(cam, mirror)

    
t = (mirror.d - dot(cam.C, mirror.n))/dot(mirror.n, mirror.n);

C_new = cam.C + 2*t*mirror.n';


R = cam.R;
n = mirror.n;

R_new = [R(1,:) - 2*dot(R(1,:),n)*n; ...
         R(2,:) - 2*dot(R(2,:),n)*n; ...
         R(3,:) - 2*dot(R(3,:),n)*n];

K_new = cam.K;
M_new = cam.M;
N_new = cam.N;
inv_K_new = cam.inv_K;

cam_virtual = makeCamera(K_new, R_new, C_new, M_new, N_new, inv_K_new);



end
