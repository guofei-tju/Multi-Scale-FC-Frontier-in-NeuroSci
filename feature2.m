function [ features ] = feature2( vol )
%FEATURE1 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

load aal_list

bl = cell(116,1);

size_aal = size(aal_list); % 116*1

for i = 1 : size_aal(1)
   bi   = [];  % ���� ĳ���� ���� ��ֵ ����
   ai = aal_list{i}; % �ڼ�������
   si = size(ai);    % n*3
   for j = 1 : si(1)  % ����ĳ������ �����ص�
       elem = [];  % ���� ĳ���� ���� ��ֵ Ԫ��/��Ա
       vi = size(vol); % x,y,z,time 
       for k = 1 : vi(4)
           [ai(j,1), ai(j,2), ai(j,3), k]
           elem = [elem, vol(ai(j,1), ai(j,2), ai(j,3), k)];
       end    
       bi = [bi; elem];
   end
   bl{i} = bi;
end

brainMeanMatrix = [];
for i = 1 : 116
   bi = bl{i};
   brainMeanMatrix = [brainMeanMatrix; mean(bi)];
end


brainMeanMatrix



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

