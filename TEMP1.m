%% 设置问题参数并运行PSO算法

site_points = load('site_points.mat'); % 可选基地坐标
site_points = site_points.site_points;

swarmSize = 50; % 粒子群规模
maxIter = 100; % 最大迭代次数
dim = size(site_points, 1); % 探索维度
[gbest, gbestValue] = PSO(@milkRunObjective, swarmSize, maxIter, dim);
disp('最优访问顺序:');
disp(gbest);
disp('最小总距离:');
disp(gbestValue);

%% 定义问题的目标函数
function f = milkRunObjective(x)
    % 这里的x表示每个节点的访问顺序
    % 定义节点之间的距离矩阵
    distanceMatrix = load('distanceMatrix.mat');
    distanceMatrix = distanceMatrix.distanceMatrix; % 节点距离矩阵
    n = length(x); % 节点数量
    totalDistance = 0;
    for i = 2:n
        totalDistance = totalDistance + distanceMatrix(x(i-1), x(i));
    end
    % 目标函数为最小化总距离
    f = totalDistance;
end

%% 定义粒子群算法
function [gbest, gbestValue] = PSO(milkRunObjective, swarmSize, maxIter, dim)
    % milkRunObjective    目标函数
    % swarmSize           粒子群规模
    % maxIter             最大迭代数量
    % dim                 探索维度

    % 初始化粒子群
    particles = zeros(swarmSize, dim);
    for i = 1:swarmSize
        particles(i, :) = randperm(dim, dim);
    end
    velocities = zeros(swarmSize, dim);
    pbest = particles;
    pbestValue = zeros(swarmSize, 1);
    for i = 1:swarmSize
        pbestValue(i) = milkRunObjective(pbest(i,:));
    end
    [gbestValue, gbestIdx] = min(pbestValue);
    [glostValue, glostIdx] = max(pbestValue);
    gbest = pbest(gbestIdx, :);
    glost = pbest(glostIdx, :);
    
    % 开始迭代
    for iter = 1:maxIter
        % 更新速度和位置
        w = 0.5 + rand()/2;
        c1 = rand();
        c2 = rand();
        for i = 1:swarmSize
            velocities(i,:) = w * velocities(i,:) ...
                + c1 * rand() .* (pbest(i,:) - particles(i,:)) ...
                + c2 * rand() .* (gbest - particles(i,:));
            particles(i,:) = particles(i,:) + velocities(i,:);
        end
        % 更新个体和全局最优解
        for i = 1:swarmSize
            currentValue = milkRunObjective(particles(i,:));
            if currentValue < pbestValue(i)
                pbest(i,:) = particles(i,:);
                pbestValue(i) = currentValue;
            end
        end
        [currentBestValue, currentBestIdx] = min(pbestValue);
        if currentBestValue < gbestValue
            gbestValue = currentBestValue;
            gbest = pbest(currentBestIdx, :);
        end
    end
end