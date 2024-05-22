% 设置问题参数
num_cities = 16; % 城市数量
num_salesmen = 3; % 旅行商数量

distanceMatrix = load('distanceMatrix.mat');
distanceMatrix = distanceMatrix.distanceMatrix; % 节点距离矩阵

% 粒子群算法参数
num_particles = 50; % 粒子数量
max_iterations = 100; % 最大迭代次数

% 初始化粒子的位置和速度
particles = zeros(num_cities, num_salesmen, num_particles);
for p = 1:num_particles
    for s = 1:num_salesmen
        particles(:, s, p) = randperm(num_cities)';
    end
end

% 初始化全局最优解
global_best_cost = Inf;
global_best_path = zeros(num_cities, num_salesmen);

% 迭代更新粒子位置和速度
for iteration = 1:max_iterations

    % 更新每个粒子的位置和速度
    for p = 1:num_particles
        for s = 1:num_salesmen
            % 更新速度
            velocity = rand(num_cities,1) < 0.5; % 随机生成速度
            particles(:,s,p) = particles(:,s,p) + velocity;

            % 越界处理
            particles(:,s,p) = mod(particles(:,s,p)-1, num_cities) + 1;
        end
    end

    % 计算每个粒子的适应度
    costs = zeros(num_particles, 1);
    for p = 1:num_particles
        path = reshape(particles(:,:,p), num_cities*num_salesmen, 1);
        costs(p) = calculate_cost(path, distanceMatrix, num_salesmen);
    end

    % 更新局部最优解
    [particle_best_cost, particle_best_idx] = min(costs);
    particle_best_path = reshape(particles(:,:,particle_best_idx), num_cities, num_salesmen);
    
    % 更新全局最优解
    if particle_best_cost < global_best_cost
        global_best_cost = particle_best_cost;
        global_best_path = particle_best_path;
    end
    
    % 更新粒子位置和速度
    for p = 1:num_particles
        for s = 1:num_salesmen
            % 更新速度
            velocity = update_velocity(particles(:,:,p), global_best_path, s);
            particles(:,s,p) = particles(:, s, p) + velocity;
            
            % 越界处理
            particles(:,s,p) = mod(particles(:,s,p)-1, num_cities) + 1;
        end
    end
    
    % 显示当前迭代结果
    disp(['Iteration ' num2str(iteration) ': Best Cost = ' num2str(global_best_cost)]);
end

% 打印最优路径
disp('Optimal Path:');
disp(global_best_path);

% 计算路径长度
optimal_cost = calculate_cost(reshape(global_best_path, num_cities*num_salesmen, 1), distanceMatrix, num_salesmen);
disp(['Optimal Cost = ' num2str(optimal_cost)]);

function cost = calculate_cost(path, distances, num_salesmen)
    cost = 0;
    for s = 1:num_salesmen
        for i = 1:length(path)-1
            city1 = path(i, s);
            city2 = path(i+1, s);
            cost = cost + distances(city1, city2);
        end
    end
end

function velocity = update_velocity(position, global_best_path, salesman_idx)
    c1 = 2; % 加速度系数1
    c2 = 2; % 加速度系数2
    w = 0.7; % 惯性权重
    
    velocity = zeros(size(position));
    
    for i = 1:size(position,1)
        if rand < w
            % 更新速度
            prev_city = position(i, salesman_idx);
            next_city = global_best_path(i, salesman_idx);
            velocity(i, salesman_idx) = w * velocity(i, salesman_idx) + c1 * rand * (next_city - prev_city) + c2 * rand * (global_best_path(i, salesman_idx) - prev_city);
        else
            % 随机重置速度
            velocity(i, salesman_idx) = rand * size(position, 2);
        end
        
        % 限制速度范围
        velocity(i, salesman_idx) = max(1, min(size(position, 2), velocity(i, salesman_idx)));
    end
end
