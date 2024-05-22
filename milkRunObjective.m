%% 定义问题的目标函数
function f = milkRunObjective(x)
    % 这里的x表示每个节点的访问顺序
    % 定义节点之间的距离矩阵
    distanceMatrix = load('distanceMatrix.mat');
    distanceMatrix = distanceMatrix.distanceMatrix; % 节点距离矩阵
    start_distanceMatrix = load('start_distanceMatrix.mat');
    start_distanceMatrix = start_distanceMatrix.start_distanceMatrix; % 起始节点距离矩阵
    cur_deed = load('cur_deed.mat');
    cur_deed = cur_deed.cur_deed; % 当前各站点电池数量

    % 参数设置
    InitSpeed = 40; % 公里每小时
    MaxCapacity = 150; % 单车辆最大容纳电池数量
    RoadTortuosity = 1.2; % 道路曲折系数
    StockoutCostPer = 10; % 元每小时
    DistanceCostPer = 7; % 元每公里

    num_T = size(unique(floor(x)), 2);
    x = decoing(x);
    numTours = size(x, 1); % 旅行商数量
    if num_T < numTours
        totalDistance = 1000000000000;
        f = totalDistance;
        return;
    end
    totalDistance = 0; % 总距离
    MaxTimeDeed = 0;

    StockoutCost = 0; % 缺货损失成本
    for i = 1:numTours
        current_totalDistance = 0;
        current_totalDistance = current_totalDistance + start_distanceMatrix(x{i}(1));
        currentTimeDeed = current_totalDistance * RoadTortuosity / InitSpeed;
        StockoutCost = StockoutCost + currentTimeDeed * StockoutCostPer * cur_deed(x{i}(1));
        for j = 2:size(x{i}, 2)
            current_totalDistance = current_totalDistance + distanceMatrix(x{i}(j - 1), x{i}(j));
            currentTimeDeed = current_totalDistance * RoadTortuosity / InitSpeed;
            StockoutCost = StockoutCost + currentTimeDeed * StockoutCostPer * cur_deed(x{i}(j));
        end
        current_totalDistance = current_totalDistance + start_distanceMatrix(x{i}(end));
        currentTimeDeed = current_totalDistance * RoadTortuosity / InitSpeed;
        totalDistance = totalDistance + current_totalDistance;
        StockoutCost = StockoutCost + currentTimeDeed * StockoutCostPer * cur_deed(x{i}(end));
        if currentTimeDeed > MaxTimeDeed
            MaxTimeDeed = currentTimeDeed;
        end
    end
    DistanceCost = totalDistance * DistanceCostPer; % 距离运输成本

    % 目标函数
    f = 0.8 * DistanceCost + 0.2 * StockoutCost;
end