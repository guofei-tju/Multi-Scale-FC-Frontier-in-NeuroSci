function [ features ] = featureFac( vol )
%FEATURE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    features = [];
    
    aalList = getAAL333List();
    
%     szv = size(vols)
%     for si = 1 : szv(5)
%         features = [features; feature3(vols(:,:,:,:,si), aalList)];
%     end
    
    features = feature3(vol, aalList);
    
    
%     features = zscore(features')';
end

