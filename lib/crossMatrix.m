function t_ = crossMatrix(t)

t_ = zeros(3);
t_([2 6 7]) = [t(3) t(1) t(2)];
t_ = t_ - t_';

end