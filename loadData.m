function [ trains, label ] = loadData( )
%LOADDATA 此处显示有关此函数的摘要
%   此处显示详细说明
    
    trains = [];

    load posiSam01
    trains(:,:,:,:,1) = vols;
    load posiSam02
    trains(:,:,:,:,2) = vols;
    load posiSam03
    trains(:,:,:,:,3) = vols;
    load posiSam04
    trains(:,:,:,:,4) = vols;
    load posiSam06
    trains(:,:,:,:,5) = vols;
    load posiSam08
    trains(:,:,:,:,6) = vols;
    load posiSam10
    trains(:,:,:,:,7) = vols;
    load posiSam11
    trains(:,:,:,:,8) = vols;
    load posiSam13
    trains(:,:,:,:,9) = vols;
    load posiSam14
    trains(:,:,:,:,10) = vols;
    load posiSam15
    trains(:,:,:,:,11) = vols;
    load posiSam18
    trains(:,:,:,:,12) = vols;
    load posiSam19
    trains(:,:,:,:,13) = vols;
    load posiSam20
    trains(:,:,:,:,14) = vols;
    load posiSam21
    trains(:,:,:,:,15) = vols;
    load posiSam22
    trains(:,:,:,:,16) = vols;
    load posiSam23
    trains(:,:,:,:,17) = vols;
    load posiSam25
    trains(:,:,:,:,18) = vols;
    load posiSam26
    trains(:,:,:,:,19) = vols;
    load posiSam27
    trains(:,:,:,:,20) = vols;
    load posiSam28
    trains(:,:,:,:,21) = vols;
    load posiSam29
    trains(:,:,:,:,22) = vols;
    load posiSam30
    trains(:,:,:,:,23) = vols;
    load posiSam31
    trains(:,:,:,:,24) = vols;
    load posiSam32
    trains(:,:,:,:,25) = vols;
    load posiSam33
    trains(:,:,:,:,26) = vols;
    load posiSam34
    trains(:,:,:,:,27) = vols;
    load posiSam35
    trains(:,:,:,:,28) = vols;
    load posiSam37
    trains(:,:,:,:,29) = vols;

    %
    % save posiList.mat posiSam
    %

    load nageSam40
    trains(:,:,:,:,30) = vols;
    load nageSam41
    trains(:,:,:,:,31) = vols;
    load nageSam42
    trains(:,:,:,:,32) = vols;
    load nageSam43
    trains(:,:,:,:,33) = vols;
    load nageSam44
    trains(:,:,:,:,34) = vols;
    load nageSam46
    trains(:,:,:,:,35) = vols;
    load nageSam47
    trains(:,:,:,:,36) = vols;
    load nageSam50
    trains(:,:,:,:,37) = vols;
    load nageSam51
    trains(:,:,:,:,38) = vols;
    load nageSam53
    trains(:,:,:,:,39) = vols;
    load nageSam54
    trains(:,:,:,:,40) = vols;
    load nageSam55
    trains(:,:,:,:,41) = vols;
    load nageSam56
    trains(:,:,:,:,42) = vols;
    load nageSam57
    trains(:,:,:,:,43) = vols;
    load nageSam58
    trains(:,:,:,:,44) = vols;
    load nageSam60
    trains(:,:,:,:,45) = vols;
    load nageSam61
    trains(:,:,:,:,46) = vols;
    load nageSam62
    trains(:,:,:,:,47) = vols;
    load nageSam63
    trains(:,:,:,:,48) = vols;
    load nageSam64
    trains(:,:,:,:,49) = vols;
    load nageSam65
    trains(:,:,:,:,50) = vols;
    load nageSam66
    trains(:,:,:,:,51) = vols;
    load nageSam67
    trains(:,:,:,:,52) = vols;
    load nageSam69
    trains(:,:,:,:,53) = vols;
    load nageSam70
    trains(:,:,:,:,54) = vols;
    load nageSam72
    trains(:,:,:,:,55) = vols;
    load nageSam74
    trains(:,:,:,:,56) = vols;
    load nageSam76
    trains(:,:,:,:,57) = vols;
    load nageSam78
    trains(:,:,:,:,58) = vols;
    load nageSam79
    trains(:,:,:,:,59) = vols;
    load nageSam80
    trains(:,:,:,:,60) = vols;
    
    
    label = [];
    for posiNum = 1 : 29
        label = [label; [1]];
    end
    for nageNum = 1 : 31
        label = [label; [-1]];
    end
    
    
end
