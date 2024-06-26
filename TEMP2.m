%城市坐标
% city_coordinate = [
%                 33.13, 34.79;
%                 33.49, 21.37;
%                 18.00, 18.77;
%                 33.50, 32.44;
%                 23.70, 33.89; 
%                 15.74, 23.67;
%                 29.82, 25.18; 
%                 34.87, 24.29; 
%                 26.21, 28.28; 
%                 31.24, 25.33;
%                 27.52, 25.81; 
%                 21.31, 26.84;
%                 28.42, 16.14;
%                 31.32, 34.27; 
%                 19.08, 29.68; 
%                 35.13, 20.58; 
%                 25.62, 24.34;
%                 32.73, 24.49;
%                 20.90, 20.34; 
%                 35.27, 28.83;
%                 31.28, 17.80; 
%                 7.47, 19.59; 
%                 11.04, 27.19;
%                 26.20, 6.50;
%                 4.76, 19.93;
%                 38.39, 13.62;
%                 23.41, 8.95; 
%                 30.05, 10.20;
%                 35.64, 38.37; 
%                 21.89, 5.54;
%                 5.97, 10.30; 
%                 33.63, 10.17;
%                 32.57, 9.74; 
%                 37.17, 14.00;
%                 7.86, 10.04];
city_coordinate = [
    33.13  34.79;
    33.49  21.37;
    18.00  18.77;
    33.50  32.44;
    23.70  33.89;
    15.74  23.67;
    29.82  25.18;
    34.87  24.29;
    26.21  28.28;
    31.24  25.33;
    27.52  25.81;
    21.31  26.84;
    28.42  16.14;
    31.32  34.27;
    19.08  29.68;
    35.13  20.58;
    25.62  24.34;
    32.73  24.49;
    20.90  20.34;
    35.27  28.83;
    31.28  17.80;
    7.47   19.59;
    11.04  27.19;
    26.20  6.50;
    4.76   19.93;
    38.39  13.62;
    23.41  8.95;
    30.05  10.20;
    35.64  38.37;
    21.89  5.54;
    5.97   10.30;
    33.63  10.17;
    32.57  9.74;
    37.17  14.00;
    7.86   10.04
];
deed = [9 7 9 10 8 10 10 8 9 8 9 8 6 9 10 7 7 10 7 8 10 6 4 5 6 6 7 6 5 8 6 5 7 5 4];
idx = [11 28 12 18 6 16 23 20 25 12 16 14 22 26 10];
site_points = city_coordinate(idx, :);
distanceMatrix = AppointDisM(city_coordinate, site_points);
[a,b]=min(distanceMatrix');
need = zeros(size(site_points, 1), 1);
for i = 1:size(b, 2)
    need(b(i)) = need(b(i)) + deed(b(i));
end

