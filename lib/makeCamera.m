function cam = makeCamera(K, R, C, M, N, inv_K)

% X_c = R(X_w - C) = RX_w + t (R = [x_cam'; y_cam'; z_cam'];)

cam.K = K;
cam.R = R;
cam.C = C;
cam.M = M;
cam.N = N;
cam.inv_K = inv_K;


end
