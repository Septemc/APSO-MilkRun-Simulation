function y = decoing(x)
    [code_val, code_idx] = sort(x, 'ascend');
    idx = floor(code_val);
    y = cell(max(idx), 1);
    for i = 1:size(x, 2)
        y{idx(i)} = [y{idx(i)}, code_idx(i)];
    end
end