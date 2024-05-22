function encoding = PSinit(lowerBound, upperBound, numElements, numTours)
    encoding = lowerBound + (upperBound - lowerBound) * rand(numElements, 1);
    num_T = size(unique(floor(encoding)), 1);
    while num_T < numTours
        encoding = lowerBound + (upperBound - lowerBound) * rand(numElements, 1);
        num_T = size(unique(floor(encoding)), 1);
    end
end