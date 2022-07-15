% The inputs of this script include all resting and task ICs obtained by GIFT, and the aggbeta.mat(the outputs of script”1_OTaggbeta”).
% Three main outputs will be obtained by this script:
% 1. menold.mat is a 30*30 (in the OT group) or 29*29(in the PL group) correlation matrix, because of the resting data of every subject are combined with his own models to obtain the predicted activation of all 30(or 29) subjects. 
% 2. predict.mat stores the self-predicted task activation. The predicted task activation of each subject are calculated using his own resting data and model. predict.mat is a 57549 (voxels) * 30(subjects in OT group) or a 57549 (voxels) * 29(subjects in PL group) matrix for drawing the predicted task brain activation map. 
% 3. percentageold.mat showed the increasing degree of self-predicted accuracy relative to other-predicted accuracy. It is calculated by subtracting averaged other-predicted accuracy from the self-predicted accuracy and then calculating the percentage increase over the averaged other-predicted accuracy. This process is performed in each subject, thus percentage.mat is a 30 (subjects in OT group) * 1 or a 29 (subjects in PL group) * 1 matrix.

% Due to there are 2 sessions, the first loop need to run twice for every task IC.

rz=[];
pz=[];
%predict=[];
for j=1:2
    for i=1:29
        r=[];
        p=[];
        %     resting ICs for each subject
        namerest = strcat('PLot_ica_br',int2str(i),'.mat');
        load(['E:\data\OT\OT_Resting\ICA_results_2\PL\',namerest]);
        b=compSet.ic;

        delete=[1,2,3,5,7,9,10,11,12,14,18,19,20,23,25,26,27,28,31,32,34];
        b(delete,:)=[];
        XrestPL=b';
     
        for c=1:29
            t=(j:2:58);
            e=t(1,c);
            namefunc = strcat('PLot_ica_br',int2str(e),'.mat');
            load(['E:\data\OT\OT_Functional\ICA\new\testPL_OTdefaultmask\',namefunc]) ;
            
            % detailed instruction see script "3.my reconstruct"
            yorigin=(compSet.ic(27,:))';
            
            if j<2
                ypredict=XrestPL*agg_beta27(:,i);
            else
                ypredict=XrestPL*agg_beta27(:,i+29);
            end
            %把自己预测自己得出的y的提取出来
    %         tf=isequal(1,c);
    %         if tf>0
    %             predict=[predict,ypredict];
    %         else
    %             predict=predict;
    %         end 
    
% Unlike the "3.my reconstruct", here using the resting state data of subject i and the betamap of the 30 principal components of subject i
            [rho,pval] = corr(ypredict,yorigin);
            r=[r,rho];
            p=[p,pval];
        end
        rz=[rz;r];
        pz=[pz;p];
    end     
end

menold=[];
for g=1:29
    h=g+29;
    mn=mean([rz(g,:);rz(h,:)]);
    menold=[menold;mn];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\menold.mat','menold');
%save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\predict.mat','predict');

differenceold=[];
precentageold=[];
for i=1:29
a=menold(:,i);
delete=i;
a(delete,:)=[];
difold=menold(i,i)-mean(a);
differenceold=[differenceold;difold];
precentold=difold/mean(a);
precentageold=[precentageold;precentold];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\differenceold.mat','differenceold');
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\precentageold.mat','precentageold');

predictselfold=[];
predictotherold=[];
for i=1:30
    predictselfold=[predictselfold;menold(i,i)];
    a=menold(:,i);
    delete=i;
    a(delete,:)=[];
    predictotherold=[predictotherold;mean(a)];
end
save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\predictselfold.mat','predictselfold');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\predictotherold.mat','predictotherold');
