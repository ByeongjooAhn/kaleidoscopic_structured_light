function Cams = makeVirtualCameras(Cam0, Mirrors, id_list)
% Make virtual cameras from possible set of reflections (ids)
Cams = cell(size(id_list));

count = 0;
for idx_id = 1:length(id_list)
    id = id_list(idx_id);
    if id == 0 % real camera
        count = count + 1;
        Cams{count} = Cam0;
    elseif mod(id,10)~=9
        id = sprintf('%d', id);
        Cam_current = Cam0;
        for idx_r = 1:length(id)
            id_str = num2str(id);
            mirror_id = str2double(id_str(idx_r));
            if mirror_id ~= 0
                Cam_current = makeVirtualCamera(Cam_current, Mirrors{mirror_id});
            else
                break;
            end
        end
        count = count + 1;
        Cams{count} = Cam_current;
    end
end

Cams = Cams(~cellfun('isempty',Cams));

end