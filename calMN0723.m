load('avgMNList.mat')

sn = 60;
braNum = 116;
timeNum = 220;

c1 = 1.03; % miu + c1 * sigma   32 1.03-1.04 40         11 1.10 36    5.05 0.95

actvList = [];

for i = 1 : sn
%     avgMNList(:,:,sn)
%     actv = [];
    for bi = 1 : braNum
        braAvg = 0;
        for ti = 1 : timeNum
            braAvg = braAvg + avgMNList(bi,ti,i);
        end
        braAvg = braAvg / timeNum;
        fc = 0; % fang cha
        
        for ti = 1 : timeNum
            fc = fc + (braAvg - avgMNList(bi,ti,i))^2;
        end
        fc = fc / timeNum-1;
        bzc = fc^0.5; % biao zhun cha
        
        thres = braAvg + c1 * bzc;
        for ti = 1 : timeNum
            if avgMNList(bi,ti,i) >= thres
                actvList(bi,ti,i) = 1;
            else
                actvList(bi,ti,i) = 0;
            end
        end
        
    end
end

% actvList(:,:,3)
gapList = [3,3,3,3];
% gapList = [1,2,3,13];    32 1.03 42
% gapList = [1,2,3,13]; % 5833
coActvList = zeros(braNum,braNum,4,sn);

for i = 1 : sn
    for bi = 1 : braNum-1
        for bi2 = bi+1 : braNum
            
            for ti = 1 : timeNum
                if actvList(bi,ti,i) > 0 % ==1
                    tMax = ti + gapList(4);
                    if ti + gapList(4) > timeNum
                        tMax = timeNum;
                    end
                    for ti2 = ti : tMax
                        if actvList(bi2,ti2,i) > 0 % ==1
                            gap = ti2 - ti;
                            if gap < gapList(1) % ==0
                                coActvList(bi,bi2,1,i) = coActvList(bi,bi2,1,i) +1;
                            elseif gap < gapList(2) % 1 <= gap < 4  1-3
                                coActvList(bi,bi2,2,i) = coActvList(bi,bi2,2,i) +1;
                            elseif gap < gapList(3) % 4 <= gap < 11  4-10
                                coActvList(bi,bi2,3,i) = coActvList(bi,bi2,3,i) +1;
                            elseif gap <= gapList(4) % 11 <= gap <= 20  11-20
                                coActvList(bi,bi2,4,i) = coActvList(bi,bi2,4,i) +1;
                            end
                        end
                    end
                end
                
                if actvList(bi2,ti,i) > 0 % ==1
                    tMax = ti + gapList(4);
                    if ti + gapList(4) > timeNum
                        tMax = timeNum;
                    end
                    for ti2 = ti : tMax
                        if actvList(bi,ti2,i) > 0 % ==1
                            gap = ti2 - ti;
                            if gap < gapList(1) % ==0
                                coActvList(bi2,bi,1,i) = coActvList(bi2,bi,1,i) +1;
                            elseif gap < gapList(2) % 1 <= gap < 4  1-3
                                coActvList(bi2,bi,2,i) = coActvList(bi2,bi,2,i) +1;
                            elseif gap < gapList(3) % 4 <= gap < 11  4-10
                                coActvList(bi2,bi,3,i) = coActvList(bi2,bi,3,i) +1;
                            elseif gap <= gapList(4) % 11 <= gap <= 20  11-20
                                coActvList(bi2,bi,4,i) = coActvList(bi2,bi,4,i) +1;
                            end
                        end
                    end
                end
                
            end
            
        end
    end
end

coActvList_P1 = getCoActvList_P(coActvList, 1);
coActvList_P2 = getCoActvList_P(coActvList, 2);
coActvList_P3 = getCoActvList_P(coActvList, 3);

simi11 = [];
simi12 = [];
simi13 = [];
simi14 = [];
simi15 = [];
simi21 = [];
simi22 = [];
simi23 = [];
simi31 = [];
simi32 = [];
simi33 = [];
simi35 = [];

fealist = [];

for i = 1 : sn
    
%     coActv = coActvList_P1(:,:,:,i);
%     sz = size(coActv);
%     feaTemp = [];
%     for ii = 1 : sz(1)
%         for kk = 1 : sz(3)
%             feaTemp = [feaTemp, coActv(ii,:,kk)];
%         end
%     end
%     fealist(i,:) = feaTemp;
    
    for j = i : sn
        
        simi11(i,j) = calSimiMtx(coActvList_P1(:,:,:,i), coActvList_P1(:,:,:,j), 1);
        simi11(j,i) = simi11(i,j);
        simi12(i,j) = calSimiMtx(coActvList_P1(:,:,:,i), coActvList_P1(:,:,:,j), 2);
        simi12(j,i) = simi12(i,j);
        simi13(i,j) = calSimiMtx(coActvList_P1(:,:,:,i), coActvList_P1(:,:,:,j), 3);
        simi13(j,i) = simi13(i,j);
        simi14(i,j) = calSimiLinear(coActvList_P1(:,:,:,i), coActvList_P1(:,:,:,j), 1);
        simi14(j,i) = simi14(i,j);
        simi15(i,j) = calSimiMtx(coActvList_P1(:,:,:,i), coActvList_P1(:,:,:,j), 4);
        simi15(j,i) = simi15(i,j);
        
        simi21(i,j) = calSimiMtx(coActvList_P2(:,:,:,i), coActvList_P2(:,:,:,j), 1);
        simi21(j,i) = simi21(i,j);
        simi22(i,j) = calSimiMtx(coActvList_P2(:,:,:,i), coActvList_P2(:,:,:,j), 2);
        simi22(j,i) = simi22(i,j);
        simi23(i,j) = calSimiMtx(coActvList_P2(:,:,:,i), coActvList_P2(:,:,:,j), 3);
        simi23(j,i) = simi23(i,j);
        simi24(i,j) = calSimiLinear(coActvList_P2(:,:,:,i), coActvList_P2(:,:,:,j), 1);
        simi24(j,i) = simi24(i,j);
        
        simi31(i,j) = calSimiMtx(coActvList_P3(:,:,:,i), coActvList_P3(:,:,:,j), 1);
        simi31(j,i) = simi31(i,j);
        simi32(i,j) = calSimiMtx(coActvList_P3(:,:,:,i), coActvList_P3(:,:,:,j), 2);
        simi32(j,i) = simi32(i,j);
        simi33(i,j) = calSimiMtx(coActvList_P3(:,:,:,i), coActvList_P3(:,:,:,j), 3);
        simi33(j,i) = simi33(i,j);
        simi34(i,j) = calSimiLinear(coActvList_P3(:,:,:,i), coActvList_P3(:,:,:,j), 1);
        simi34(j,i) = simi34(i,j);
        simi35(i,j) = 1- calSimiMtx(coActvList_P3(:,:,:,i), coActvList_P3(:,:,:,j), 5);
        simi35(j,i) = simi35(i,j);
        
    end
end

% save simiMtx32.mat simi32

label = [];
result = [];
for posiNum = 1 : 29
    label = [label; [1]];
end
for nageNum = 1 : 31
    label = [label; [-1]];
end

% [las fitinfo] = lasso(fealist,label,'CV',20);
% fealist = fealist.* las(:,fitinfo.Index1SE)';

% ttttf = [];
% for tttti = 1 : 13
%     ttttf = [ttttf, fealist(:,indexxx(tttti))];
% end
% fealist = ttttf;

for index = 1 : 60
    lab = label;
    lab(index, :) = [];
    km = simi35;
%     km = fealist*fealist';
%     for dj = 1 : 60 %% 0
%         km(dj,dj) = 1;
%     end
    km(:, index) = [];
    kt = km(index, :);
    km(index, :) = [];
    
% model4 = svmtrain(label, [(1:100)', trl*trl'], ['-t 4 -b 1']);
% [pred_label, acc, dec_scores] = svmpredict(tlb, [(1:10)',tl*trl'], model4, '-b 1');
    model = svmtrain(lab, [(1:59)',km], ['-t 4 -b 1']);
    
    [predicted_label, accuracy, decision_scores] = svmpredict(label(index, 1), [1, kt], model, '-b 1')
    result = [result; predicted_label];
end

t = 0;
tt = [];
for i = 1 : 60
    if label(i,1) - result(i,1) == 0
        t = t+1;
    else
        tt = [tt; i];
    end
end

t
tt
myAcc = t/60


% coActvList = zeros(braNum,braNum,4,sn);
function coActvList_P = getCoActvList_P(mtx, type)
    coActvList_P = [];
    
    sz = size(mtx);
    
    if type == 1
        for s = 1 : sz(4)
            for i = 1 : sz(1)
                for j = 1 : sz(2)
                    if i == j
                        for k = 1 : sz(3)
                            coActvList_P(i,j,k,s) = 0;
                        end
                    else
                        ct = 0;
                        for k = 1 : sz(3)
                            ct = ct + mtx(i,j,k,s);
                        end 
                        for k2 = 1 : sz(3)
                            if ct == 0 
                                coActvList_P(i,j,k2,s) = 0;
                            else
                                coActvList_P(i,j,k2,s) = mtx(i,j,k2,s) / ct;
                            end
                        end
                    end
                end
            end
        end
    elseif type == 2
        for s = 1 : sz(4)
            for i = 1 : sz(1)
                ct = 0;
                for j = 1 : sz(2)
                    for k = 1 : sz(3)
                        ct = ct + mtx(i,j,k,s);
                    end
                end
                for j2 = 1 : sz(2)
                    if i == j2
                        for k2 = 1 : sz(3)
                            coActvList_P(i,j2,k2,s) = 0;
                        end
                    else
                        for k2 = 1 : sz(3)
                            if ct == 0
                                coActvList_P(i,j2,k2,s) = 0;
                            else
                                coActvList_P(i,j2,k2,s) = mtx(i,j2,k2,s) / ct;
                            end
                        end
                    end
                end
            end
        end
    elseif type == 3
        for s = 1 : sz(4)
            ct = 0;
            for i = 1 : sz(1)
                for j = 1 : sz(2)
                    for k = 1 : sz(3)
                        ct = ct + mtx(i,j,k,s);
                    end
                end
            end
            
            for i2 = 1 : sz(1)
                for j2 = 1 : sz(2)
                    if i2 == j2
                        for k2 = 1 : sz(3)
                            coActvList_P(i2,j2,k2,s) = 0;
                        end
                    else
                        for k2 = 1 : sz(3)
                            if ct == 0
                                coActvList_P(i2,j2,k2,s) = 0;
                            else
                                coActvList_P(i2,j2,k2,s) = mtx(i2,j2,k2,s) / ct;
                            end
                        end
                    end
                end
            end
            
        end
        
    end
    
end

function simiValue = calSimiMtx(coActvP1, coActvP2, type)
	simiValue = 0;
    sz = size(coActvP1);
    
%     if type == 1
%         1
%     elseif type == 2
%         2
%     elseif type == 3
%         3
%     end
    
    for i = 1 : sz(1)
        for j = 1 : sz(2)
            for k = 1 : sz(3)
                pq = calSimiEtp(coActvP1(i,j,k),coActvP2(i,j,k));
                qp = calSimiEtp(coActvP2(i,j,k),coActvP1(i,j,k));
                pp = calSimiEtp(coActvP1(i,j,k),coActvP1(i,j,k));
                qq = calSimiEtp(coActvP2(i,j,k),coActvP2(i,j,k));
                pf = calSimiEtp(coActvP1(i,j,k),(coActvP1(i,j,k)+coActvP2(i,j,k))/2 );
                qf = calSimiEtp(coActvP2(i,j,k),(coActvP1(i,j,k)+coActvP2(i,j,k))/2);
                
%                 if simiValue >=0 && simiValue <=1
%                     123;
%                 else
%                     11111111111
%                     coActvP1(i,j,k)
%                     coActvP2(i,j,k)
%                     simiValue
%                     12;
%                 end
                if type == 1
                    simiValue = simiValue + pq + qp;
%                     simiValue = simiValue + pq * qp;
                elseif type == 2
                    simiValue = simiValue + pq + qp - pp - qq;
%                     simiValue = simiValue + (pq - pp) * (qp - qq);
                elseif type == 3
                    simiValue = simiValue + abs(qq - pp);
                elseif type == 4
                    simiValue = simiValue + qq * pp;
                elseif type == 5
                    simiValue = simiValue + (-pp+pf - qq+qf)/2;
                end
            end
        end
    end
%     simiValue = -simiValue;%
end

function simiValue = calSimiLinear(coActvP1, coActvP2, type)
	simiValue = 0;
    sz = size(coActvP1);
    
%     if type == 1
%         1
%     elseif type == 2
%         2
%     elseif type == 3
%         3
%     end
    
    for i = 1 : sz(1)
        for j = 1 : sz(2)
            for k = 1 : sz(3)
                if type == 1
                    simiValue = simiValue + coActvP1(i,j,k) * coActvP2(i,j,k);
                elseif type == 2
%                     simiValue = simiValue + pq + qp - pp - qq;
%                     simiValue = simiValue + (pq - pp) * (qp - qq);
                elseif type == 3
%                     simiValue = simiValue + abs(qq - pp);
                end
            end
        end
    end
%     simiValue = -simiValue;%
end

function simiEtp = calSimiEtp(p1, p2) % p1 log p2
    simiEtp = 0;
    if p1 >=1 || p2 >=1 || p1 <=0 || p2 <=0
        simiEtp = 0;
    else
        simiEtp = -1 * p1 * log2(p2); % 2 e dou keyi
    end
end

% 
% aalList = getAAL333List();
% 
% load posiSam01
% avgMNList(:,:,1) = getAvgMtxMN(vols, aalList);
% 1
% load posiSam02
% avgMNList(:,:,2) = getAvgMtxMN(vols, aalList);
% 2
% load posiSam03
% avgMNList(:,:,3) = getAvgMtxMN(vols, aalList);
% 3
% load posiSam04
% avgMNList(:,:,4) = getAvgMtxMN(vols, aalList);
% 4
% load posiSam06
% avgMNList(:,:,5) = getAvgMtxMN(vols, aalList);
% 5
% load posiSam08
% avgMNList(:,:,6) = getAvgMtxMN(vols, aalList);
% load posiSam10
% avgMNList(:,:,7) = getAvgMtxMN(vols, aalList);
% load posiSam11
% avgMNList(:,:,8) = getAvgMtxMN(vols, aalList);
% load posiSam13
% avgMNList(:,:,9) = getAvgMtxMN(vols, aalList);
% load posiSam14
% avgMNList(:,:,10) = getAvgMtxMN(vols, aalList);
% 10
% load posiSam15
% avgMNList(:,:,11) = getAvgMtxMN(vols, aalList);
% load posiSam18
% avgMNList(:,:,12) = getAvgMtxMN(vols, aalList);
% load posiSam19
% avgMNList(:,:,13) = getAvgMtxMN(vols, aalList);
% load posiSam20
% avgMNList(:,:,14) = getAvgMtxMN(vols, aalList);
% load posiSam21
% avgMNList(:,:,15) = getAvgMtxMN(vols, aalList);
% 15
% load posiSam22
% avgMNList(:,:,16) = getAvgMtxMN(vols, aalList);
% load posiSam23
% avgMNList(:,:,17) = getAvgMtxMN(vols, aalList);
% load posiSam25
% avgMNList(:,:,18) = getAvgMtxMN(vols, aalList);
% load posiSam26
% avgMNList(:,:,19) = getAvgMtxMN(vols, aalList);
% load posiSam27
% avgMNList(:,:,20) = getAvgMtxMN(vols, aalList);
% 20
% load posiSam28
% avgMNList(:,:,21) = getAvgMtxMN(vols, aalList);
% load posiSam29
% avgMNList(:,:,22) = getAvgMtxMN(vols, aalList);
% load posiSam30
% avgMNList(:,:,23) = getAvgMtxMN(vols, aalList);
% load posiSam31
% avgMNList(:,:,24) = getAvgMtxMN(vols, aalList);
% load posiSam32
% avgMNList(:,:,25) = getAvgMtxMN(vols, aalList);
% 25
% load posiSam33
% avgMNList(:,:,26) = getAvgMtxMN(vols, aalList);
% load posiSam34
% avgMNList(:,:,27) = getAvgMtxMN(vols, aalList);
% load posiSam35
% avgMNList(:,:,28) = getAvgMtxMN(vols, aalList);
% load posiSam37
% avgMNList(:,:,29) = getAvgMtxMN(vols, aalList);
% 
% 2
% load nageSam40
% avgMNList(:,:,30) = getAvgMtxMN(vols, aalList);
% load nageSam41
% avgMNList(:,:,31) = getAvgMtxMN(vols, aalList);
% load nageSam42
% avgMNList(:,:,32) = getAvgMtxMN(vols, aalList);
% load nageSam43
% avgMNList(:,:,33) = getAvgMtxMN(vols, aalList);
% load nageSam44
% avgMNList(:,:,34) = getAvgMtxMN(vols, aalList);
% 2.5
% load nageSam46
% avgMNList(:,:,35) = getAvgMtxMN(vols, aalList);
% load nageSam47
% avgMNList(:,:,36) = getAvgMtxMN(vols, aalList);
% load nageSam50
% avgMNList(:,:,37) = getAvgMtxMN(vols, aalList);
% load nageSam51
% avgMNList(:,:,38) = getAvgMtxMN(vols, aalList);
% load nageSam53
% avgMNList(:,:,39) = getAvgMtxMN(vols, aalList);
% 2.1
% load nageSam54
% avgMNList(:,:,40) = getAvgMtxMN(vols, aalList);
% load nageSam55
% avgMNList(:,:,41) = getAvgMtxMN(vols, aalList);
% load nageSam56
% avgMNList(:,:,42) = getAvgMtxMN(vols, aalList);
% load nageSam57
% avgMNList(:,:,43) = getAvgMtxMN(vols, aalList);
% load nageSam58
% avgMNList(:,:,44) = getAvgMtxMN(vols, aalList);
% 2.15
% load nageSam60
% avgMNList(:,:,45) = getAvgMtxMN(vols, aalList);
% load nageSam61
% avgMNList(:,:,46) = getAvgMtxMN(vols, aalList);
% load nageSam62
% avgMNList(:,:,47) = getAvgMtxMN(vols, aalList);
% load nageSam63
% avgMNList(:,:,48) = getAvgMtxMN(vols, aalList);
% load nageSam64
% avgMNList(:,:,49) = getAvgMtxMN(vols, aalList);
% 2.2
% load nageSam65
% avgMNList(:,:,50) = getAvgMtxMN(vols, aalList);
% load nageSam66
% avgMNList(:,:,51) = getAvgMtxMN(vols, aalList);
% load nageSam67
% avgMNList(:,:,52) = getAvgMtxMN(vols, aalList);
% load nageSam69
% avgMNList(:,:,53) = getAvgMtxMN(vols, aalList);
% load nageSam70
% avgMNList(:,:,54) = getAvgMtxMN(vols, aalList);
% 2.25
% load nageSam72
% avgMNList(:,:,55) = getAvgMtxMN(vols, aalList);
% load nageSam74
% avgMNList(:,:,56) = getAvgMtxMN(vols, aalList);
% load nageSam76
% avgMNList(:,:,57) = getAvgMtxMN(vols, aalList);
% load nageSam78
% avgMNList(:,:,58) = getAvgMtxMN(vols, aalList);
% load nageSam79
% avgMNList(:,:,59) = getAvgMtxMN(vols, aalList);
% load nageSam80
% avgMNList(:,:,60) = getAvgMtxMN(vols, aalList);
% 
% save avgMNList.mat avgMNList