%
%Three main outputs will be obtained by this script:
%1. men.mat is a 30*30 (in the OT group) or 29*29(in the PL group) correlation matrix, because of the resting data of every subject are combined with all subjects' models respectively to obtain the predicted activation of all 30(or 29) subjects. 
%2. predict.mat stores the self-predicted task activation. The predicted task activation of each subject are calculated using his own resting data and model. predict.mat is a 57549 (voxels) * 30(subjects in OT group) or a 57549 (voxels) * 29(subjects in PL group) matrix for drawing the predicted task brain activation map. 
%3. percentage.mat showed the increasing degree of self-predicted accuracy relative to other- predicted accuracy. It is calculated by subtracting averaged other-predicted accuracy from the self-predicted accuracy and then calculating the percentage increase over the averaged other-predicted accuracy. This process is performed in each subject, thus percentage.mat is a 30 (subjects in OT group) * 1 or a 29 (subjects in PL group) * 1 matrix.

% Due to there are 2 sessions, the first loop need to run twice for every task IC.

rz=[];
pz=[];
predict=[];
for i=1:29
    r=[];
    p=[];
    %Extract a subject's resting ICs
    namerest = strcat('PLot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\PL\',namerest]);
    b=compSet.ic;
%    Delete the ICs that don't meet requirements(PL group)
      delete=[2,9,14,27,28];
      b(delete,:)=[];
      XrestPL=b';
      
% %     Delete the ICs that don't meet requirements(OT group)
%       delete=[8,9,12,15,23,33];
%       b(delete,:)=[];
%       XrestOT=b';
    
        for c=1:29
            t=(1:2:58);
            e=t(1,c);
            namefunc = strcat('PLot_ica_br',int2str(e),'.mat');
            load(['E:\data\OT\OT_Functional\ICA\new\testPL_OTdefaultmask\',namefunc]) ;% load all task ICs
            yorigin=(compSet.ic(28,:))';% Notice that you have to change the values here to predict different ICs
            %XrestPL is a 57549*29 matrix，agg_beta28(:,c) includes the beta values of the 30 resting ICs of subject c.
            %若t是奇数列(1:2:58)，则为c，若t是偶数列(2:2:58)，则为c+29，因为在求agg_beta时是先奇数（run1求出的30个成分的beta map）后偶（run2）
            ypredict=XrestPL*agg_beta28(:,c);
            %把自己预测自己得出的y的提取出来，每个被试都有一个，用于画预测脑图。如当i=c=1时，就是第一个被试的静息态预测第一个被试的任务态。
            tf=isequal(i,c);
            if tf>0
                predict=[predict,ypredict];
            else
                predict=predict;
            end
           %算预测值和实际观测值的相关系数rho及是否显著pval
            [rho,pval] = corr(ypredict,yorigin);
            r=[r,rho];
            p=[p,pval];
        end
    rz=[rz;r];
    pz=[pz;p];
    
end
%rz是58（被预测的每人两个run）*29（每个人一个静息态）的矩阵，现在把每个被试两个run的相关系数平均起来,第一列是第一个人预测所有人，第二列是第二个人预测所有人，以此类推。
men=[];
for g=1:29
    h=g+29;
    mn=mean([rz(g,:);rz(h,:)]);
    men=[men;mn];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\men.mat','men');
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\predict.mat','predict');
%算自己预测自己和自己预测他人之间的差，并除以预测他人的准确率以得到提高的百分比
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

%将预测自己和预测他人的均值都提取出来，这一步是为了画density的图，展现预测自己的准确率显著高于预测他人，但目前没有用到
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
