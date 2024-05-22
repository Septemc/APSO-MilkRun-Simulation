function distances = AppointDisM(PointData1, PointData2)
    % PointData1            input       距离矩阵行元素 格式：每行为 经度，纬度
    % PointData2            input       距离矩阵列元素 格式：每行为 经度，纬度
    % distances            output       距离矩阵

    % 初始化距离矩阵
    distances = zeros(size(PointData1, 1), size(PointData2, 1));
    for i = 1:size(PointData1, 1)
        for j = 1:size(PointData2, 1)
            % 计算经纬度坐标之间的距离
            d = distance(PointData1(i, 2), PointData1(i, 1), PointData2(j, 2), PointData2(j, 1));
            % 将距离从度转换为公里
            distances(i, j) = d;
        end
    end
end