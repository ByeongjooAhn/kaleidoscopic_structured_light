function [points, label_p_all, label_c_used, dp_twoview, dc_twoview] = reconstructPoints(data, label, virtual, mode)

fprintf('\nTriangulation...\n');
[op_list, dp_list] = pixel2ray(data.xp_list, label.p_list, virtual.mirror_id_p, virtual.Projs);
[oc_list, dc_list] = pixel2ray(data.xc_list, label.c_list, virtual.mirror_id_c, virtual.Cams);

label_c_used = [];
dp_twoview = [];
dc_twoview = [];

if mode == 1 % noncross view
    [points, label_p_all] = reconstructNoncross(op_list, dp_list, oc_list, dc_list, label);
    
elseif mode == 2 % multi view
    [points, label_p_all] = reconstructCrossMulti(op_list, dp_list, oc_list, dc_list, label);

elseif mode == 3 % all two view
    [points, label_p_all, dp_twoview, dc_twoview] = reconstructCrossAll(op_list, dp_list, oc_list, dc_list, label);
    
elseif mode == 4 % all multi-view ransac
    [points, label_p_all, label_c_used] = reconstructCrossMultiRANSAC(op_list, dp_list, oc_list, dc_list, label);

elseif mode == 5 % ransac with collected pixels (pc)
    [points, label_p_all, label_c_used] = reconstructCollectedRANSAC(op_list, dp_list, oc_list, dc_list, label, data.point_list);

elseif mode == 6 % collected pixels (pc)
    [points, label_p_all, label_c_used] = reconstructCollected(op_list, dp_list, oc_list, dc_list, label, data.point_list);

end

% add all pc


end
