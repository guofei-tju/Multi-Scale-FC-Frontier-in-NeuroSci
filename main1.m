load trains1;
% mib = 20000; %26681
mib = 1+6670*0; 
mif = 6670*7;
% mif = 30400 ; %30400
% features = [zscore(trains(1:22,:));zscore(trains(23:34,:));zscore(trains(35:51,:));zscore(trains(52:54,:));zscore(trains(55:57,:));zscore(trains(58:60,:))];
features = [zscore(trains(1:27,mib:mif));zscore(trains(28:31,mib:mif));zscore(trains(32:45,mib:mif));zscore(trains(46:60,mib:mif))];
% features = zscore(trains(:,mib:mif));

% gyh = zscore(trains(:,mib:mif));
% coeff = pca(gyh);
% size(coeff)
% features = gyh.*coeff';

label = [];
for posiNum = 1 : 29
    label = [label; [1]];
end
for nageNum = 1 : 31
    label = [label; [-1]];
end

% [ vols, label ] = loadData();
% features = featureFac( vols );

result = [];

% cmd = ['-c 1 -t 2 -b 1']; 
cmd = ['-c 1 -t 0 -b 1']; 
% gap = 1;
% for index = 1 : gap : 60-gap+1
%     lab = label;
%     tra = features;
%     for gi = 0 : gap-1
%         lab(index, :) = [];
%         tra(index, :) = [];
%     end
%     
%     model = svmtrain(lab,tra,cmd);
%     
%     for pi = 0 : gap-1
%         [predicted_label, accuracy, decision_scores] = svmpredict(label(index + pi, 1), features(index + pi, :), model, '-b 1')
%         result = [result; predicted_label];
%     end
% end

for index = 1 : 60
    lab = label;
    lab(index, :) = [];
    tra = features;
    tra(index, :) = [];
    model = svmtrain(lab,tra,cmd);
    
    [predicted_label, accuracy, decision_scores] = svmpredict(label(index, 1), features(index, :), model, '-b 1')
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

% [bestacc,bestc,bestg] = SVMcg(label, [posiSam; nageSam], 0.05, 0.45, 0, 0.2, 60, 0.1, 0.04, 0.002, 2 )