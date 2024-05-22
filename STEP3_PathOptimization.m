clc
clear
%% 迭代求解最优解
site_points = load('site_points.mat'); % 充电站坐标
site_points = site_points.site_points;
distanceMatrix = load('distanceMatrix.mat');
distanceMatrix = distanceMatrix.distanceMatrix; % 节点距离矩阵
start_distanceMatrix = load('start_distanceMatrix.mat');
start_distanceMatrix = start_distanceMatrix.start_distanceMatrix; % 起始节点距离矩阵

numCities = size(site_points, 1); % 城市数量
% 加载工作空间中的初始参数
load('InitParams.mat');

[gbest, gbestValue] = PSO(@milkRunObjective, swarmSize, maxIter, numTours, numCities, AlgorithmFlag);

disp('最优访问顺序:');
disp(decoing(gbest));

disp(['总成本:', num2str(gbestValue)]);

