% 指定文件路径
filename1 = 'poi-成都市成华区.xlsx';
filename2 = 'poi-成都市金牛区.xlsx';
filename3 = 'poi-成都市锦江区.xlsx';
filename4 = 'poi-成都市青羊区.xlsx';
filename5 = 'poi-成都市武侯区.xlsx';

% 使用readmatrix函数读取CSV文件
data1 = readmatrix(filename1);
data1 = data1(:, 2:3);

data2 = readmatrix(filename2);
data2 = data2(:, 2:3);

data3 = readmatrix(filename3);
data3 = data3(:, 2:3);

data4 = readmatrix(filename4);
data4 = data4(:, 2:3);

data5 = readmatrix(filename5);
data5 = data5(:, 2:3);


% 合并所有类型的需求点
data = [data1;data2;data3;data4;data5];

% 创建图像
figure;

% 绘制数据点
hold on;
plot(data(:, 1), data(:, 2), 'ro', 'MarkerSize', 1);
hold off;


% 添加标题和轴标签
title('Data Visualization');
xlabel('X轴');
ylabel('Y轴');


% 聚类数目
k = 100;

% 使用k-means算法进行聚类
[idx, centroids] = kmeans(data, k);

% 创建图像
figure;

% 绘制聚类结果和代表点
hold on;
for i = 1:k
    cluster_points = data(idx == i, :);
    plot(cluster_points(:, 1), cluster_points(:, 2), 'o', 'MarkerSize', 1);
    plot(centroids(i, 1), centroids(i, 2), 'kx', 'MarkerSize', 8, 'LineWidth', 2);
end
hold off;

% 添加标题和轴标签
title('聚类待选点');
xlabel('X轴');
ylabel('Y轴');

