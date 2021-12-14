function [o_list, d_list] = pixel2ray(x_list, label_list, mirror_id, Cams)

    nScan = size(x_list, 1);
    nObservation_max = size(label_list, 2);
    o_list = NaN(nScan, 3, nObservation_max);
    d_list = NaN(nScan, 3, nObservation_max);

    id_list = label2mirrorID(label_list, mirror_id);

    for iScan = 1:nScan
        for iObservation = 1:nObservation_max
            x = x_list(iScan, :, iObservation);
            id = id_list(iScan, iObservation);
            if ~id || isnan(x(1))
                continue;
            end
            
            Cam = Cams{id};

            o_list(iScan, :, iObservation) = Cam.C;
            d_list(iScan, :, iObservation) = castSingleRay(Cam, x);
        end
    end

end