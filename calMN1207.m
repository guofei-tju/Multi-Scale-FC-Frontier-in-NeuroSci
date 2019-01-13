load('avgMNList.mat')

sn = 60;
braNum = 116;
timeNum = 220;

clst = [0,1];
szc = size(clst);
cid = szc(2);
    
actvList = [];

for i = 1 : sn
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
        
        
        for ti = 1 : timeNum
            thres1 = 0;
            for ci = 1 : cid
                thres2 = braAvg + ci * bzc;
                if avgMNList(bi,ti,i) >= thres1 && avgMNList(bi,ti,i) < thres2
                    actvList(bi,ti,i) = ci;
                end
                thres1 = thres2;
            end
            if avgMNList(bi,ti,i) >= thres1
                actvList(bi,ti,i) = cid+1;
            end
        end
        
    end
end

% gapList = [1,2,3,13];

selfTransitionList = zeros(braNum,cid+1,cid+1,sn);

for i = 1 : sn
    for bi = 1 : braNum
        
        ti0 = actvList(bi,1,i);
        for ti = 2 : timeNum
            ti1 = actvList(bi,ti,i);
            selfTransitionList(bi,ti0,ti1,i) = selfTransitionList(bi,ti0,ti1,i) +1;
            ti0 = ti1;
        end
        
        for ci0 = 1 : cid+1
            for ci1 = 1 : cid+1
                selfTransitionList(bi,ci0,ci1,i) = selfTransitionList(bi,ci0,ci1,i) / (timeNum-1);
            end
        end
            
    end
end

fealist = [];

for i = 1 : sn
    for j = i : sn
        simi11s(i,j) = calSimiMtx(selfTransitionList(:,:,:,i), selfTransitionList(:,:,:,j), 1);
        simi11s(j,i) = simi11s(i,j);
        simi12s(i,j) = calSimiMtx(selfTransitionList(:,:,:,i), selfTransitionList(:,:,:,j), 2);
        simi12s(j,i) = simi12s(i,j);
        simi13s(i,j) = calSimiMtx(selfTransitionList(:,:,:,i), selfTransitionList(:,:,:,j), 3);
        simi13s(j,i) = simi13s(i,j);
        simi14s(i,j) = calSimiLinear(selfTransitionList(:,:,:,i), selfTransitionList(:,:,:,j), 1);
        simi14s(j,i) = simi14s(i,j);
        simi15s(i,j) = 1 - calSimiMtx(selfTransitionList(:,:,:,i), selfTransitionList(:,:,:,j), 4);
        simi15s(j,i) = simi15s(i,j);
        
        
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
    km = simi15s;
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

tt
t
myAcc = t/60



function simiValue = calSimiMtx(coActvP1, coActvP2, type)
	simiValue = 0;
    sz = size(coActvP1);
    
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
