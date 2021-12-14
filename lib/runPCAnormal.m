function points = runPCAnormal(points, data, label, virtual)

K = 10;
points.normal_pca = computePCAnormal(points, data, label, virtual, K);
points.normal = points.normal_pca;

end