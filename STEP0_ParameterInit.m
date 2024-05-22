%% 初始化数据
site_points = [
    27.52 25.81
    30.05 10.20
    20.31 19.84
    32.73 24.49
    15.74 23.67
    31.13 15.58
    11.04 27.19
    35.27 28.83
    4.760 19.93
    21.31 26.84
    35.13 20.58
    31.32 34.27
    7.470 19.59
    38.39 13.62
    31.24 25.33
]; % 站点坐标设置

start_point = [20.00 15.00]; % 配送起点坐标设置
distanceMatrix = AppointDisM(site_points, site_points);
start_distanceMatrix = AppointDisM(site_points, start_point);

InitSpeed = 40; % 公里每小时
MaxCapacity = 150; % 单车辆最大容纳电池数量
RoadTortuosity = 1.2; % 道路曲折系数

swarmSize = 300; % 粒子群规模
maxIter = 150; % 最大迭代次数
numTours = 3; % 旅行商数量

AlgorithmFlag = 0; % 选择粒子群更新算法【0:普通粒子群更新算法 1:加速度粒子群更新算法】

% 保存distanceMatrix为.mat文件
save('site_points.mat', 'site_points');
save('distanceMatrix.mat', 'distanceMatrix');
save('start_distanceMatrix.mat', 'start_distanceMatrix');
save('start_point.mat', 'start_point');

% 保存参数到可加载工作空间
% 保存变量到工作空间
save('InitParams.mat', 'InitSpeed', 'MaxCapacity', 'RoadTortuosity', 'swarmSize', 'maxIter', 'numTours', 'AlgorithmFlag');
