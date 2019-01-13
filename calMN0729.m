load('avgMNList.mat')

sn = 60;
braNum = 116;
timeNum = 220;

avgMNNorm = [];
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
        
        plist = [];
        for ti = 1 : timeNum
            avgMNNorm(bi,ti,i) = (avgMNList(bi,ti,i) - braAvg) / bzc;
        end
        
    end
end

avgMMPCC2 = [];
for i = 1 : sn 
    for bi = 1 : braNum
        for bj = bi : braNum
            pcc2 = 0;
            
            p2max = 0;  % todo  0 abs   and   pi * pi-1
%             p2min = 1; 
            for ti = 1 : timeNum
                p2i = abs(avgMNNorm(bi,ti,i) * avgMNNorm(bj,ti,i));
                if p2i > p2max 
                    p2max = p2i;
                end
                if p2i < p2min 
                    p2min = p2i;
                end
            end
            
            for ti = 1 : timeNum
                if ti ==1 
                    pcc2 = avgMNNorm(bi,ti,i) * avgMNNorm(bj,ti,i);
                else
            temp=avgMNNorm(bi,ti,i)*avgMNNorm(bj,ti,i)* (avgMNNorm(bi,ti-1,i)*avgMNNorm(bj,ti-1,i)-p2min)/(p2max-p2min);
%             temp=avgMNNorm(bi,ti,i)*avgMNNorm(bj,ti,i)* (avgMNNorm(bi,ti-1,i)*avgMNNorm(bj,ti-1,i)+1)/(p2max+1);
                    pcc2 = pcc2 + temp;
                end
            end
            avgMMPCC2(bi,bj,i) = pcc2;
            avgMMPCC2(bj,bi,i) = pcc2;
        end
    end
end

simiMtx = [];
simiMtx2 = [];
simiMtx3 = [];
simiMtx4 = [];
for i = 1 : sn
    for j = i : sn % i dui jiao xian
        smi = [];
        for bi = 1 : braNum
            for bj = 1 : braNum
                smi(bi,bj) = corr(avgMMPCC2(:,bi,i), avgMMPCC2(:,bj,j), 'type', 'pearson');
            end
        end
        % how to deal smi[]
        sv1 = 0;
        sv2 = 0;
        sv3 = 0;
        sv4 = 0;
        for si = 1 : braNum-1
            for sj = si+1 : braNum
                sv1 = sv1 - abs(smi(si,sj) - smi(sj,si));
                sv4 = sv4 + smi(si,sj) * smi(sj,si);
            end
        end
        sv1 = sv1 / (braNum-1) * 2;  % n-1 / 2
        sv3 = sv1 / (2); %
        for si = 1 : braNum
            sv1 = sv1 + smi(si,si);
            sv2 = sv2 + smi(si,si);
            sv3 = sv3 + smi(si,si);
            sv4 = sv4 + smi(si,si) * smi(si,si);
        end
        simiMtx(i,j) = sv1;
        simiMtx(j,i) = sv1;
        % to delete
        simiMtx2(i,j) = sv2;
        simiMtx2(j,i) = sv2;
        simiMtx3(i,j) = sv3;
        simiMtx3(j,i) = sv3;
        simiMtx4(i,j) = sv4;
        simiMtx4(j,i) = sv4;
    end
end


label = [];
result = [];
for posiNum = 1 : 29
    label = [label; [1]];
end
for nageNum = 1 : 31
    label = [label; [-1]];
end

for index = 1 : 60
    lab = label;
    lab(index, :) = [];
%     km = simi11 + simi32;
    km = simiMtx;
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

