function [label, data, label_candidate, d_epipolar_list, num_candidate_list] = runEpipolarLabeling(data, virtual)
    tic;
    fprintf('\nLabeling...\n');
    
    % set margin to reject the points near mirrors
    virtual.margin = 1.5;
    
    % find label under threshold
    [label_candidate, d_epipolar_list, num_candidate_list] = runEpipolarLabelingBackproject(data, virtual);
    
    % check inside considering all candidates with same epipolar constraint
    [label, data, rejected] = checkInsideSystemAll(label_candidate, data, virtual);
    
    % check if there is repeated labels (i.e., incorrect detection)
    [label, data] = checkRepeatedLabel(label, data);
    
    toc;
end