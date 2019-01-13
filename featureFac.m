function [ features ] = featureFac( vol )
%FEATURE 此处显示有关此函数的摘要
%   此处显示详细说明
    features = [];
    
    aalList = getAAL333List();
    
%     szv = size(vols)
%     for si = 1 : szv(5)
%         features = [features; feature3(vols(:,:,:,:,si), aalList)];
%     end
    
    features = feature3(vol, aalList);
    
    
%     features = zscore(features')';
end

