function [p1,p2] = cross_percentage()
    p1 = rand;
    p2 = rand;
    while p1 + p2 < 0.4
        p1 = rand;
        p2 = rand;
    end
end