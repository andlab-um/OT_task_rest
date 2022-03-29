%The inputs of this script include all resting and task ICs obtained by GIFT, and the aggbeta.mat(the outputs of script”1_OTaggbeta”).
%Three main outputs will be obtained by this script:
%1. menold.mat is a 30*30 (in the OT group) or 29*29(in the PL group) correlation matrix, because of the resting data of every subject are combined with his own models to obtain the predicted activation of all 30(or 29) subjects. 
%2. predict.mat stores the self-predicted task activation. The predicted task activation of each subject are calculated using his own resting data and model. predict.mat is a 57549 (voxels) * 30(subjects in OT group) or a 57549 (voxels) * 29(subjects in PL group) matrix for drawing the predicted task brain activation map. 
%3. percentageold.mat showed the increasing degree of self-predicted accuracy relative to other-predicted accuracy. It is calculated by subtracting averaged other-predicted accuracy from the self-predicted accuracy and then calculating the percentage increase over the averaged other-predicted accuracy. This process is performed in each subject, thus percentage.mat is a 30 (subjects in OT group) * 1 or a 29 (subjects in PL group) * 1 matrix.

% Due to there are 2 sessions, the first loop need to run twice for every task IC.
rz=[];
pz=[];
PLname={'5','6','7','8','11','12','13','14','17','18','19','20','29','30','31','34','35','36','37','40','41','42','43','52','53','54','55','58','59'}; 
OTname={'1','2','3','4','9','10','15','16','21','22','23','24','25','26','27','28','32','33','38','39','44','45','46','47','48','49','50','51','56','57'};
for j=1:2
    for i=1:length(OTname)
    r=[];
    p=[];
    %     resting ICs for each subject
    namerest = strcat('rest_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAresting\',namerest]);
    b=compSet.ic;
    delete=[2,3,4,8,9,10,11,12,14,16,17,19,20,21,22,25,26,27,29,30,32,33,34,35];
      b(delete,:)=[];
      XrestPL=b';
      
        for c=1:length(OTname)
        t=(j:2:118);
        otname=[1,2,3,4,9,10,15,16,21,22,23,24,25,26,27,28,32,33,38,39,44,45,46,47,48,49,50,51,56,57];
        e=t(1,otname);
        y=e(1,c);
        namefunc = strcat('task_ica_br',int2str(y),'.mat');
        load(['E:\data\OT\newresult\ICAtask\',namefunc]) ;
        %detailed comments see script "all_myconstructPL"
        yorigin=(compSet.ic(10,:))';

        if j<2
            ypredict=XrestPL*agg_beta10(:,i);
           else
            ypredict=XrestPL*agg_beta10(:,i+30);
           end
        %Unlike the "all_myreconstruct", here using the resting state data of subject i and the betamap of the 30 principal components of subject i

        [rho,pval] = corr(ypredict,yorigin);
        r=[r,rho];
        p=[p,pval];
        end
    rz=[rz;r];
    pz=[pz;p];
    end
end

menold10=[];
for g=1:30
    h=g+30;
    mn=mean([rz(g,:);rz(h,:)]);
    menold10=[menold10;mn];
end
save('E:\data\OT\newresult\OTtoOT\29PN\menold29.mat','menold29');
%save('E:\data\OT\newresult\PLtoPL\27DDMN\predictold27.mat','predictold27');

differenceold29=[];
precentageold29=[];
for i=1:30
a=menold10(:,i);
delete=i;
a(delete,:)=[];
difold=menold10(i,i)-mean(a);
differenceold29=[differenceold29;difold];
precentold=difold/mean(a);
precentageold29=[precentageold29;precentold];
end
save('E:\data\OT\newresult\OTtoOT\29PN\differenceold29.mat','differenceold29');
save('E:\data\OT\newresult\OTtoOT\29PN\precentageold29.mat','precentageold29');


predictselfold29=[];
predictotherold29=[];
for i=1:30
    predictselfold29=[predictselfold29;menold10(i,i)];
    a=menold10(:,i);
    delete=i;
    a(delete,:)=[];
    predictotherold29=[predictotherold29;mean(a)];
end
save('E:\data\OT\newresult\OTtoOT\29PN\predictselfold29.mat','predictselfold29');
save('E:\data\OT\newresult\OTtoOT\29PN\predictotherold29.mat','predictotherold29');
