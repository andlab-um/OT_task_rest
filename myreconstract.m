%The inputs of this script include all resting and task ICs obtained by GIFT, and the aggbeta.mat(the outputs of script "1. OTaggbeta").
%Three main outputs will be obtained by this script:
%1. men.mat is a 30*30 (in the OT group) or 29*29(in the PL group) correlation matrix, because of the resting data of every subject are combined with all subjects' models respectively to obtain the predicted activation of all 30(or 29) subjects. 
%2. predict.mat stores the self-predicted task activation. The predicted task activation of each subject are calculated using his own resting data and model. predict.mat is a 57549 (voxels) * 30(subjects in OT group) or a 57549 (voxels) * 29(subjects in PL group) matrix for drawing the predicted task brain activation map. 
%3. percentage.mat showed the increasing degree of self-predicted accuracy relative to other-predicted accuracy. It is calculated by subtracting averaged other-predicted accuracy from the self-predicted accuracy and then calculating the percentage increase over the averaged other-predicted accuracy. This process is performed in each subject, thus percentage.mat is a 30 (subjects in OT group) * 1 or a 29 (subjects in PL group) * 1 matrix.

% Due to there are 2 sessions, the first loop need to run twice for every task IC.
% This script is analysing the data of placebo group. 
% When using it to deal with data of the oxytocin group, all "for i=1:29" need changing to "for i=1:30", setting c=1：30，t=(j:2:60), ypredict=XrestPL*agg_beta28(:,c+30)

%OTtoOT
rz=[];
pz=[];
%predict=[];
for i=1:29
    r=[];
    p=[];
    %提取每个被试的静息态ic
    namerest = strcat('PLot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\PL\',namerest]);
    b=compSet.ic;
%     PL静息态成分及最后的X
      delete=[2,9,14,27,28];
      b(delete,:)=[];
      XrestPL=b';
      
        for c=1:29
            for j=1:2;
            t=(j:2:58);
            e=t(1,c);
            namefunc = strcat('PLot_ica_br',int2str(e),'.mat');
            load(['E:\data\OT\OT_Functional\ICA\new\testPL_OTdefaultmask\',namefunc]) ;% Task ICs
            yorigin=(compSet.ic(28,:))';%Note that you need to change the values here to predict different components, such as DDMN, the 28th component in the PL task state, and agG_beta28 for betamap
            ypredict=XrestPL*agg_beta28(:,c+29);%X是57549*30的矩阵，agg是第e个人的30个主成分，30*1的矩阵，列向量。每个人用自己的静息态数据和别人的beta map，预测出来和别人的real对比。若t是奇数列，则为e，若t是偶数列，则为e+30
            %把自己预测自己得出的y的提取出来，每个被试都有一个，用于画预测脑图。如当i=c=1时，就是第一个被试的静息态预测第一个被试的任务态。
    %         tf=isequal(i,c);
    %         if tf>0
    %             predict=[predict,ypredict];
    %         else
    %             predict=predict;
    %         end
         %算预测值和实际观测值的相关系数rho及是否显著pval  
            [rho,pval] = corr(ypredict,yorigin);
            r=[r,rho];
            p=[p,pval];
            end
        end
    rz=[rz;r];
    pz=[pz;p];
    
end
%把每个被试两个session的相关系数平均起来,第一行是第一个人预测所有人，第二行是第二个人预测所有人，以此类推。
men=[];
for g=1:29
    h=g+29;
    mn=mean([rz(g,:);rz(h,:)]);
    men=[men;mn];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\men.mat','men');
%save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\predict.mat','predict');
%算自己预测自己和自己预测他人之间的差
difference=[];
precentage=[];
for i=1:29
a=men(:,i);
delete=i;
a(delete,:)=[];
difold=men(i,i)-mean(a);
difference=[difference;difold];
precentold=difold/mean(a);
precentage=[precentage;precentold];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\difference.mat','difference');
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\precentage.mat','precentage');

%将预测自己和预测他人的均值都提取出来
predictself=[];
predictother=[];
for i=1:29
    predictself=[predictself;men(i,i)];
    a=men(:,i);
    delete=i;
    a(delete,:)=[];
    predictother=[predictother;mean(a)];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\predictself.mat','predictself');
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\predictother.mat','predictother');
