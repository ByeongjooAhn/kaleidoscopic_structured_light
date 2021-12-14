function label_possible = computeLabelPossibleBackproject(x, label_noobject_backproject, M, N)

    % compute index
    in_x = @(x) inside(x, 1, N);
    in_y = @(y) inside(y, 1, M);
    
    % check the neighboring indices
    round_x = round(x(1));
    round_y = round(x(2));

    r = 0;
    ind_neighbor = NaN((2*r+1)^2, 1);
    count = 1;
    for rr = -r:r
        ind_neighbor(count:count+2*r) = sub2ind([M N], in_y(round_y+(-r:r)'), in_x(round_x+repmat(rr, [2*r+1, 1])));
        count = count + 2*r + 1;
    end
    
    label_noobject_now = label_noobject_backproject;
    label_possible = NaN(length(label_noobject_now), 1);
    nPossible = ceil(log10(max(label_noobject_now)));
    for j = 1:nPossible
        label_possible(j) = floor(label_noobject_now/(10^j))*10;
    end
    
end

function x = inside(x, l, u)
    x = min(max(l, x), u);
end

