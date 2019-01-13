function [ braAvgList ] = getAvgMtxMN( vol, aalList )
%GETAVGMTXMN 此处显示有关此函数的摘要
%   此处显示详细说明
    
    aalBraNum = 116;
    timeNum = 220;

%     aalList = getAAL333List();

    braAvgList = [];
    
    for bi = 1 : aalBraNum
        braMask = [];
        braAvg = [];
        voxelNum = getAAL333VoxelNum(aalList(:,:,:,bi));
        for ti = 1 : timeNum
            braMask(:,:,:,ti) = vol(:,:,:,ti).*aalList(:,:,:,bi);
            voxelVali = getAAL333VoxelValue(braMask(:,:,:,ti));
            braAvg = [braAvg, voxelVali / voxelNum];
%             voxelVali
%             voxelNum
        end
%         braAvg
        braAvgList = [braAvgList; braAvg];
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

