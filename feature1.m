function [ features ] = feature1( vol )
%FEATURE1 此处显示有关此函数的摘要
%   此处显示详细说明

% rand(1)
features = [];
for i = 4 : 10 : 55
    for j = i+5 : 5 : 55
        v1 = [];
        v2 = [];
        for k = 1 : 220
            v1 = [v1; vol(i,i,i,k)];
            v2 = [v2; vol(j,j,j,k)];
        end
        
%         corr([v1;0.001],[v2;0.001],'type','pearson')
        features = [features, corr([v1;0.001],[v2;0.001],'type','pearson')];
    end
end

% features = [vol(10,10,10,1), 2, 3]

end

