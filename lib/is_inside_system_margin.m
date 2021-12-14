function is_inside = is_inside_system_margin(point_list, systemParams, margin)
% check if points are in the imaging system
    nPoint = size(point_list, 1);
    n = systemParams.n;
    d = systemParams.d;
    
    is_inside = true(nPoint, 1);
    for iPoint = 1:nPoint
        point = point_list(iPoint, :);
        if any(isnan(point))
            is_inside(iPoint) = false;
            continue;
        end
        if point(3) < 0
            is_inside(iPoint) = false;
            continue;
        end

        for i = 1:length(n)
            is_inside_i = dot(point, n{i}) + d{i};
            if is_inside_i < margin %
                is_inside(iPoint) = false;
                break;
            end 
        end
    end
end
