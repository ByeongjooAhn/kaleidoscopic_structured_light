function [X, err_triangulation] = computeNearestPointFromRays(op, dp, oc_multi, dc_multi)

    % input should be 1x3xM matrix
    
    num_c = size(oc_multi, 3);
    A = zeros(3);
    B = zeros(1, 3);
    C = 0;
    
    dp = dp';
    op = op';
    Ap = eye(3) - dp*dp';
    A_Proj = Ap'*Ap;
    B_Proj = op'*(Ap'*Ap);
    C_Proj = op'*(Ap'*Ap)*op;
    
    A = A + A_Proj;
    B = B + B_Proj;
    C = C + C_Proj;
    
    for i = 1:num_c
        dc = dc_multi(:, :, i)';
        oc = oc_multi(:, :, i)';
        Ac = eye(3) - dc*dc';
        A_Cam = Ac'*Ac;
        B_Cam = oc'*(Ac'*Ac);
        C_Cam = oc'*(Ac'*Ac)*oc;

        A = A + A_Cam;
        B = B + B_Cam;
        C = C + C_Cam;
    end
    
    % compute point
    X = A\B';
    err_triangulation = X'*A*X - 2*B*X + C;
    X = X'; % 1x3 vector

end
