%% 模拟一段时间内的换电站换电情况
lambda = [15, 12, 10, 8, 6, 10, 15, 20, 23, 26, 27, 24, 26, 29, 30, 31, 32, 28, 23, 21, 19, 18, 17, 16];  % 泊松分布参数
serDesks = 5;  % 初始换电台数量
old_numSimulations = 100;  % 模拟次数
start_time = 7; % 开始时间
end_time = 13; % 结束时间
sate_num = 15; % 充电站数量
charger_num = 50; % 初始电池数量
cur_deed = []; % 记录电池数量

for sate_idx = 1:sate_num
    success_num = 0; % 服务客户数量
    for idx = start_time:end_time
        % 初始化参数
        old_arrivalTime = exprnd(1/lambda(idx), old_numSimulations, 1); % 车辆到达时间
        arrivalTime = [];
        sum_time = 0;
        iter = 1;
        while(sum_time < 1)
            sum_time = sum_time + old_arrivalTime(iter);
            arrivalTime = [arrivalTime;old_arrivalTime(iter)];
            iter = iter + 1;
        end
        numSimulations = size(arrivalTime, 1);
        initialSOC = rand(numSimulations, 1) * 60 + 5; % 当前电量
        Desks_chargers = zeros(serDesks, 1); % 充电桩状态，0表示空闲
        Desks_queue = cell(serDesks, 1); % 排队队列，每行包含[充电所需时间，充电桩选择]
        Desks_queue_pos = ones(serDesks, 1);
        use_num = 0; % 换电台使用数量
       
        for sim = 1:numSimulations
            % 车辆到达
            currentTime = arrivalTime(sim);
            SOC = initialSOC(sim);
            
            % 车主充电决策
            if SOC < 45
                % 根据概率选择充电方式
                if rand < 0.65
                    % 更换电池
                    for i = 1:serDesks
                        try
                            if Desks_queue{i}(Desks_queue_pos(i))
                                Desks_queue{i}(Desks_queue_pos(i)) = Desks_queue{i}(Desks_queue_pos(i)) - currentTime;
                                while Desks_queue{i}(Desks_queue_pos(i)) <= 0
                                    Desks_chargers(i) = Desks_chargers(i) - 1;
                                    Desks_queue_pos(i) = Desks_queue_pos(i) + 1;
                                    Desks_queue{i}(Desks_queue_pos(i)) = Desks_queue{i}(Desks_queue_pos(i)) + Desks_queue{i}(Desks_queue_pos(i) - 1);
                                end
                            end
                        catch
                            continue;
                        end
                    end
                    
                    % 换电台选择
                    % 找到数组中值为零的元素的索引
                    zero_indices = find(Desks_chargers == 0);
                    
                    % 如果有零元素，则选择第一个零元素的索引
                    if ~isempty(zero_indices)
                        chargerChoice = zero_indices(1);
                    else
                        chargerChoice = find(Desks_chargers == min(Desks_chargers));
                        if length(chargerChoice) ~= 1
                            chargerChoice = chargerChoice(1);
                        end
                    end
                    
                    % 检查排队情况
                    waitNum = Desks_chargers(chargerChoice);
                    if rand > 0.7^waitNum
                        % 客户离开
                        continue;
                    end
                    % 排队
                    Desks_chargers(chargerChoice) = Desks_chargers(chargerChoice) + 1;
                    timeNeeded = 0.1; % 换电所需时间
                    Desks_queue{chargerChoice} = [Desks_queue{chargerChoice}; timeNeeded];
                    success_num = success_num + 1;
                    use_num = use_num + sum(Desks_chargers);
        
                    continue; % 下一车辆
                end
            end
        end
    end
    
    % 记录当前电池数量
    if success_num > charger_num
        success_num = charger_num;
    end
    cur_deed = [cur_deed; success_num, charger_num - success_num];
end
disp(num2str(cur_deed));
save('cur_deed.mat', 'cur_deed');