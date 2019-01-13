function [ features ] = feature3( vol, aalList )
%FEATURE3 此处显示有关此函数的摘要
%   此处显示详细说明
    
%     load aal333
    
    features = [];

    aalBraNum = 116;
    timeNum = 220;

%     aalList = getAAL333List();

    braAvgList = [];
    braVariList = [];
    voxelValList = [];
    
    for bi = 1 : aalBraNum
        braMask = [];
        braAvg = [];
        braVari = [];
        voxelVal = [];
        voxelNum = getAAL333VoxelNum(aalList(:,:,:,bi));
        for ti = 1 : timeNum
            braMask(:,:,:,ti) = vol(:,:,:,ti).*aalList(:,:,:,bi);
            voxelVali = getAAL333VoxelValue(braMask(:,:,:,ti));
            braAvg = [braAvg, voxelVali / voxelNum];
            
            %20180703  brain fea
            braVari = [braVari, calVariance(braMask(:,:,:,ti))];
            voxelVal = [voxelVal, voxelVali];
        end
        braAvgList = [braAvgList; braAvg];
        braVariList = [braVariList; braVari];
        voxelValList = [voxelValList; voxelVal];
%         bi
    end
    
    voxelPerList = [];
    for i = 1 : timeNum
        vl = 0;
        for j = 1 : aalBraNum
            vl = vl + voxelValList(j,i);
        end
        for j = 1 : aalBraNum
            voxelPerList(j,i) = voxelValList(j,i)/vl;
        end
        
    end
    
    %20180703
    mtx1 = [];
    mtxVari1 = [];
    mtxPer1 = [];
    for mi = 1 : aalBraNum-1
        for mj = mi+1 : aalBraNum
            mtx1(mi,mj) = corr(braAvgList(mi,:)',braAvgList(mj,:)','type','pearson');
            mtx1(mj,mi) = mtx1(mi,mj);
            mtxVari1(mi,mj) = corr(braVariList(mi,:)',braVariList(mj,:)','type','pearson');
            mtxVari1(mj,mi) = mtxVari1(mi,mj);
            mtxPer1(mi,mj) = corr(voxelPerList(mi,:)',voxelPerList(mj,:)','type','pearson');
            mtxPer1(mj,mi) = mtxPer1(mi,mj);
        end
    end
    
    mtx2 = [];
    mtxVari2 = [];
    mtxPer2 = [];
    for mi = 1 : aalBraNum-1
        for mj = mi+1 : aalBraNum
            ri = mtx1(mi,:);
            rj = mtx1(mj,:);
            ri(mi) = [];
            ri(mj-1) = [];
            rj(mi) = [];
            rj(mj-1) = [];
            mtx2(mi,mj) = corr(ri',rj','type','pearson');
            mtx2(mj,mi) = mtx2(mi,mj);
            %mtxVari2
            rvi = mtxVari1(mi,:);
            rvj = mtxVari1(mj,:);
            rvi(mi) = [];
            rvi(mj-1) = [];
            rvj(mi) = [];
            rvj(mj-1) = [];
            mtxVari2(mi,mj) = corr(rvi',rvj','type','pearson');
            mtxVari2(mj,mi) = mtxVari2(mi,mj);
            %mtxPer2
            rpi = mtxPer1(mi,:);
            rpj = mtxPer1(mj,:);
            rpi(mi) = [];
            rpi(mj-1) = [];
            rpj(mi) = [];
            rpj(mj-1) = [];
            mtxPer2(mi,mj) = corr(rpi',rpj','type','pearson');
            mtxPer2(mj,mi) = mtxPer2(mi,mj);
        end
    end
    
    mtx3 = [];
    for mi = 1 : aalBraNum-1
        for mj = mi+1 : aalBraNum
            ri = mtx2(mi,:);
            rj = mtx2(mj,:);
            ri(mi) = [];
            ri(mj-1) = [];
            rj(mi) = [];
            rj(mj-1) = [];
            mtx3(mi,mj) = corr(ri',rj','type','pearson');
            mtx3(mj,mi) = mtx3(mi,mj);
        end
    end
    
    % window
%     windowSize = 1;
%     windowGap = 1;
%     mtxWin1 = [];
%     for mi = 1 : aalBraNum
%         for init = 0 : windowGap : timeNum-windowSize
%             mtx1(mi,mj) = corr(braAvgList(mi,init+1:init+windowSize)',braAvgList(mj,init+1:init+windowSize)','type','pearson');
%         end
%     end
    
    
    % union m3 v2 p2
    % mtxVari mtxPer
    cn2 = aalBraNum*(aalBraNum-1)/2;
    index_f = 0;
    for mi = 1 : aalBraNum-1
        for mj = mi+1 : aalBraNum
            index_f = index_f + 1;
            features(index_f) = mtx1(mi,mj); %, mtx2(mi,mj), mtx3(mi,mj)];
            features(index_f + cn2*1) = mtx2(mi,mj);
            features(index_f + cn2*2) = mtx3(mi,mj);
            features(index_f + cn2*3) = mtxVari1(mi,mj);
            features(index_f + cn2*4) = mtxVari2(mi,mj);
            features(index_f + cn2*5) = mtxPer1(mi,mj);
            features(index_f + cn2*6) = mtxPer2(mi,mj);
        end
    end
    
end

function [ voxelNum ] = getAAL333VoxelNum( brainMask )
    
    vn = 0;
    
    x = 61;  
    y = 73;
    z = 61;
    
    for xi = 1 : x
        for yi = 1 : y
            for zi = 1 : z
                if(brainMask(xi,yi,zi) >= 1)
                    vn = vn + 1;
                end
            end
        end
    end
    
    voxelNum = vn;
end

function [ voxelValue ] = getAAL333VoxelValue( brainMask )
    
    vv = 0;
    
    x = 61;  
    y = 73;
    z = 61;
    
    for xi = 1 : x
        for yi = 1 : y
            for zi = 1 : z
                if(brainMask(xi,yi,zi) > 0)
                    vv = vv + brainMask(xi,yi,zi);
                end
            end
        end
    end
    
    voxelValue = vv;
end

function variance = calVariance( brainMask )
    
    vari = 0;
    
    vv = 0;
    vn = 0;
    
    x = 61;  
    y = 73;
    z = 61;
    
    for xi = 1 : x
        for yi = 1 : y
            for zi = 1 : z
                if(brainMask(xi,yi,zi) > 0)
                    vv = vv + brainMask(xi,yi,zi);
                    vn = vn + 1;
                end
            end
        end
    end
    
    mean = vv/vn;
    
    for xi = 1 : x
        for yi = 1 : y
            for zi = 1 : z
                if(brainMask(xi,yi,zi) > 0)
                    vari = vari + (brainMask(xi,yi,zi) - mean)^2;
                end
            end
        end
    end
    
    variance = vari/vn;
end
