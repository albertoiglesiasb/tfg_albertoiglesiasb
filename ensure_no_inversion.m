function member = ensure_no_inversion(member, Cfg)
    for i = 1:Cfg.NUM_POINTS
        if member.z_upper(i) < member.z_lower(i)
            distance = abs(member.z_upper(i) - member.z_lower(i));
            correction = max(0.01, distance * 0.3); % Mantener una distancia mínima proporcional
            member.z_upper(i) = member.z_lower(i) + correction;
            if i == 1 || i == Cfg.NUM_POINTS
                member.z_upper(i) = member.z_lower(i) + 0.1*abs(member.z_lower(i));
            end
        end
    end
end