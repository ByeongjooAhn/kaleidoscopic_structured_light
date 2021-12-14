function id_list = label2mirrorID(label_list, mirror_id)

    [is_member, id_list] = ismember(label_list, mirror_id);
    if any(~is_member & ~isnan(label_list))
        error('Something is wrong');
    end
end