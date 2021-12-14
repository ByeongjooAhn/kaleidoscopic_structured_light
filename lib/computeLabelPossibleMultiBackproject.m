function [label_possible_multi, is_c_edge] = computeLabelPossibleMultiBackproject(x, label_noobject_backproject, M, N)

    nObservation = size(x, 3);
    label_possible_multi = cell(nObservation, 1);
    is_c_edge = false(nObservation, 1);
    
    for i = 1:nObservation
        label_possible_multi{i} = computeLabelPossibleBackproject(x(:,:,i), label_noobject_backproject(i), M, N);
        is_c_edge(i) = isnan(label_possible_multi{i}(1));
    end
end


