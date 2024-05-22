%% 寻找局部最优解
site_points = load('site_points.mat'); % 充电站坐标
site_points = site_points.site_points;
distanceMatrix = load('distanceMatrix.mat');
distanceMatrix = distanceMatrix.distanceMatrix; % 节点距离矩阵
start_distanceMatrix = load('start_distanceMatrix.mat');
start_distanceMatrix = start_distanceMatrix.start_distanceMatrix; % 起始节点距离矩阵

numCities = size(site_points, 1); % 城市数量
% 加载工作空间中的初始参数
load('InitParams.mat');

lbest = [];
lbestValue = [];
disp('正在寻找局部最优解…');
for Idx = 1:10
    [gbest, gbestValue] = SearchLocalOptimalSolutions(@milkRunObjective, swarmSize, numTours, numCities);
    lbest = [lbest; gbest];
    lbestValue = [lbestValue; gbestValue];
    disp(['进度:', num2str(Idx), '/', num2str(10)]);
    disp('最优访问顺序:');
    disp(decoing(gbest));
    disp(['最小总距离:', num2str(gbestValue)]);
end
save('lbest.mat', 'lbest');