function [gbest, gbestValue] = SearchLocalOptimalSolutions(milkRunObjective, swarmSize, numTours, numCities)
    % 初始化粒子
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
    pbest = particles;
    pbestValue = zeros(swarmSize, 1);
    for i = 1:swarmSize
        pbestValue(i) = milkRunObjective(pbest(i,:));
    end
    [gbestValue, gbestIdx] = min(pbestValue);
    gbest = pbest(gbestIdx, :);

    maxIter = 10;
    % 开始迭代
    for iter = 1:maxIter
        % 普通粒子群参数设置
        w = 0.8; % 惯性因子
        c1 = 1.3;
        c2 = 1.5;
        % 更新速度和位置
        for i = 1:swarmSize
            velocities(i,:) = w * velocities(i,:) ...
                + c1 * rand() .* (pbest(i,:) - particles(i,:)) ...
                + c2 * rand() .* (gbest - particles(i,:));
            particles(i,:) = particles(i,:) + velocities(i,:);
        end

        % 约束 检查particles变量的值，并确保它们在1到3.99之间
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
    end
end