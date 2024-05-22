% Milk Run Simulation in MATLAB

% 假设数据
N = 5; % 供应商数量
d = [10 20 30 40 50]; % 供应商位置（距离中心仓库的距离）
w = [6 7 8 9 10]; % 每个供应商的货物重量
t = [1 1.5 2 1.5 1]; % 在每个供应商处装货/卸货的时间
r = [2 3 1 1 2]; % 车辆的行驶速度

% 初始化变量
time = 0; % 当前时间
route = []; % 车辆路线
load = 0; % 车辆当前载重

% 循环决策过程
while(1)
    % 1. 选择下一个供应商
    [min_d, idx] = min(d);
    if load + w(idx) > 10 % 假设车辆最大载重为10
        break; % 如果载重超过限制，结束循环
    end
    
    % 2. 前往
    time = time + (d(idx) / r(1)); % 假设车辆速度为r(1)
    
    % 3. 装货/卸货
    time = time + t(idx);
    load = load + w(idx); % 更新载重
    route = [route idx]; % 更新路线
    
    % 4. 离开供应商
    time = time + (d(idx) / r(1));
    
    % 5. 检查是否所有供应商都访问完毕
    if sum(d(:) == 0) == N
        break;
    end
end

% 输出结果
fprintf('路线: ');
for i = 1:length(route)
    fprintf('%d ', route(i));
end
fprintf('\n行驶时间: %.2f s\n', time);
fprintf('载重: %.2f kg\n', load);
