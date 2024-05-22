%% 定义粒子群算法
function [gbest, gbestValue] = PSO(milkRunObjective, swarmSize, maxIter, numTours, numCities, AlgorithmFlag)
    % milkRunObjective    目标函数
    % swarmSize           粒子群规模
    % maxIter             最大迭代数量
    % dim                 探索维度

    % 加载局部最优解
    lbest = load('lbest.mat');
    lbest = lbest.lbest;

    % 初始化粒子
    MutationProbability = 0.4; % 粒子变异概率

    lowerBound = 1; % 最小值
    upperBound = numTours + 1; % 最大值
    numElements = numCities; % 向量长度
    
    particles = zeros(swarmSize, numCities);
    % 生成随机向量编码
    for i = 1:swarmSize
        encoding = PSinit(lowerBound, upperBound, numElements, numTours);
        particles(i, :) = encoding;
    end
    velocities = zeros(swarmSize, numCities);
    particles = [particles; lbest];
    pbest = particles;
    pbestValue = zeros(swarmSize, 1);
    for i = 1:swarmSize
        pbestValue(i) = milkRunObjective(pbest(i,:));
    end
    [gbestValue, gbestIdx] = min(pbestValue);
    gbest = pbest(gbestIdx, :);

    traceData = [];

    % 开始迭代
    for iter = 1:maxIter
        % 粒子变异
        for i = 1:size(particles, 1)
            if rand() < MutationProbability
                encoding = PSinit(lowerBound, upperBound, numElements, numTours);
                particles(i, :) = encoding;
                velocities(i,:) = linspace(-3.0, 3.0, size(particles, 2));
            end
        end
        if AlgorithmFlag == 0
            % 普通粒子群参数设置
            w = 0.9; % 惯性因子
            c1 = 1.3;
            c2 = 1.5;
            % 更新速度和位置
            for i = 1:swarmSize
                velocities(i,:) = w * velocities(i,:) ...
                    + c1 * rand() .* (pbest(i,:) - particles(i,:)) ...
                    + c2 * rand() .* (gbest - particles(i,:));
                particles(i,:) = particles(i,:) + velocities(i,:);
            end
        end

        if AlgorithmFlag == 1
            % 加速度粒子群参数设置
            w_min = 0.4; % 最小惯性因子
            w_max = 0.9; % 最大惯性因子
            w = w_max - (iter-1) * (w_max - w_min) / (maxIter-1); % 惯性因子
            c1 = 1.496; % 个体认知
            c2 = 1.496; % 社会认知
            c3 = 0.5; % 排斥力参数
            c = 0.5; % 排斥力常数
            R = 1; % 排斥力大小
            b = 3; % 排斥力加速度变化率
            k = size(lbest, 1); % 局部最优解数量
    
            % 更新粒子位置和速度
            for i = 1:swarmSize
                % 计算排斥力产生的加速度
                repulsion_acc = zeros(1, size(particles, 2));
                for j = 1:k
                    repulsion_acc = repulsion_acc ...
                        + c3 * rand() * R ./ ((particles(i, :) - lbest(j, :)).^b + c);
                end
                acceleration = c1 * rand() .* (pbest(i,:) - particles(i,:)) ...
                        + c2 * rand() .* (gbest - particles(i,:)) ...
                        + repulsion_acc;
    
                % 更新速度和位置
                velocities(i,:) = w * velocities(i,:) + acceleration;
                particles(i,:) = particles(i,:) + velocities(i,:) + 0.5 * acceleration;
            end
        end
        
        % 解空间合理约束
        particles = max(particles, 1);
        particles = min(particles, numTours + 0.99);
        integer_parts = floor(particles);
        for j = 1:size(integer_parts, 1)
            if size(unique(integer_parts(j, :)), 2) < numTours
                encoding = PSinit(lowerBound, upperBound, numElements, numTours);
                particles(j, :) = encoding;
            end
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
        traceData = [traceData; gbestValue];
        % 创建迭代次数向量
        iterations = 1:size(traceData, 1);
        figure(1);
        plot(iterations, traceData, 'r-');
        hold on;
        xlabel('迭代次数');
        ylabel('最优总成本');
        hold off;

        figure(2);
        solution = decoing(gbest);
        numTours = size(solution, 1); % 旅行商数量
        start_point = load('start_point.mat');
        start_point = start_point.start_point; % 出发点坐标
        site_points = load('site_points.mat');
        site_points = site_points.site_points; % 充电站坐标
        plot(site_points(:, 1), site_points(:, 2), 'o', 'LineWidth', 1, ...
            'MarkerEdgeColor', 'b', ...
            'MarkerFaceColor', 'b', ...
            'MarkerSize', 6);
        hold on;
        plot(start_point(:, 1), start_point(:, 2), 'o', 'LineWidth', 1, ...
            'MarkerEdgeColor', 'r', ...
            'MarkerFaceColor', 'r', ...
            'MarkerSize', 6);
    
        % 定义颜色字符串数组
        color_str = ['r', 'b', 'g', 'k', 'y', 'm', 'c', 'k', 'grey', 'pink', 'orange', 'darkgreen', 'darkblue', 'darkmagenta', 'darkan'];

        for i = 1:size(gbest, 2)
            text(site_points(i, 1), site_points(i, 2) - 2, num2str(i), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        end
        for i = 1:numTours
            plot([start_point(1, 1), site_points(solution{i}(1), 1)], [start_point(1, 2), site_points(solution{i}(1), 2)], color_str(i));
            for j = 2:size(solution{i}, 2)
                plot([site_points(solution{i}(j - 1), 1), site_points(solution{i}(j), 1)], [site_points(solution{i}(j - 1), 2), site_points(solution{i}(j), 2)], color_str(i));
            end
            plot([start_point(1, 1), site_points(solution{i}(end), 1)], [start_point(1, 2), site_points(solution{i}(end), 2)], color_str(i));
        end
        hold off;
        disp(['当前迭代次数：', num2str(iter)]);
        pause(0.00001);
    end
end