function sma = mavg2(data, w)
    % mavg2 calculates the simple moving average of a data vector.
    % 
    % data - input data vector (can be a row or column vector)
    % w - window size (if even, it will be incremented by 1 to make it odd)
    %
    % Returns:
    % sma - simple moving average of the input data, preserving the input orientation

    % If w is even, increment it by 1 to make it odd
    if mod(w, 2) == 0
        w = w + 1;
        disp(['Window size was even, adjusted to odd value: ', num2str(w)]);
    end

    % Determine if the input is a row or column vector
    isRowVector = isrow(data);
    
    % If the input is a row vector, transpose it to a column vector
    if isRowVector
        data = data';
    end

    % Initialize the output vector
    sma = zeros(size(data));
    
    % Calculate half window size
    halfWindow = (w - 1) / 2;

    % Pad the data with NaNs at the edges to handle boundary effects
    paddedData = padarray(data, halfWindow, NaN, 'both');

    % Calculate the moving average
    for i = 1:length(data)
        sma(i) = nanmean(paddedData(i:i + w - 1));
    end

    % If the input was a row vector, transpose the output back to a row vector
    if isRowVector
        sma = sma';
    end
end
