%The inputs of this script include all resting and task ICs obtained by GIFT, and the aggbeta.mat(the outputs of script”1_OTaggbeta”).
%Three main outputs will be obtained by this script:
%1. men.mat is a 30*30 (in the OT group) or 29*29(in the PL group) correlation matrix, because of the resting data of every subject are combined with all subjects' models respectively to obtain the predicted activation of all 30(or 29) subjects. 
%2. predict.mat stores the self-predicted task activation. The predicted task activation of each subject are calculated using his own resting data and model. predict.mat is a 57549 (voxels) * 30(subjects in OT group) or a 57549 (voxels) * 29(subjects in PL group) matrix for drawing the predicted task brain activation map. 
%3. percentage.mat showed the increasing degree of self-predicted accuracy relative to other-predicted accuracy. It is calculated by subtracting averaged other-predicted accuracy from the self-predicted accuracy and then calculating the percentage increase over the averaged other-predicted accuracy. This process is performed in each subject, thus percentage.mat is a 30 (subjects in OT group) * 1 or a 29 (subjects in PL group) * 1 matrix.

% Due to there are 2 sessions, the first loop need to run twice for every task IC.
rz=[];
pz=[];
yoriginmean=[];
ypredictmean=[];
predict29=[];
PLname={'5','6','7','8','11','12','13','14','17','18','19','20','29','30','31','34','35','36','37','40','41','42','43','52','53','54','55','58','59'}; 
OTname={'1','2','3','4','9','10','15','16','21','22','23','24','25','26','27','28','32','33','38','39','44','45','46','47','48','49','50','51','56','57'};
 for j=1:2
    for i=1:length(OTname)
    r=[];
    p=[];
    namerest = strcat('rest_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAresting\',namerest]);
    b=compSet.ic;
%    %    Delete the ICs that don't meet requirements
      delete=[2,3,4,8,9,10,11,12,14,16,17,19,20,21,22,25,26,27,29,30,32,33,34,35];
      b(delete,:)=[];
      XrestPL=b';

        for c=1:length(OTname)
        t=(j:2:118);
        otname=[1,2,3,4,9,10,15,16,21,22,23,24,25,26,27,28,32,33,38,39,44,45,46,47,48,49,50,51,56,57];%OT
        %otname=[5,6,7,8,11,12,13,14,17,18,19,20,29,30,31,34,35,36,37,40,41,42,43,52,53,54,55,58,59];%PL
        e=t(1,otname);
        y=e(1,c);
        namefunc = strcat('task_ica_br',int2str(y),'.mat');
        load(['E:\data\OT\newresult\ICAtask\',namefunc]) ;%% load all task ICs
        yorigin=(compSet.ic(29,:))';% Notice that you have to change the values here to predict different ICs
        
           if j<2
            ypredict=XrestPL*agg_beta29(:,c);%first run
           else
            ypredict=XrestPL*agg_beta29(:,c+30);%second run
           end
           
        %Storing all self-predicted task activation. When i=c=1, it's the resting data of the first subject predicting the task data of the first subject.
        tf1=isequal(6,c);
        tf2=isequal(i,c);
        if tf1+tf2>1
           predict29=[predict29,ypredict];
       end
        %Calculating the correlation coefficients(rho) between the predicted and actual task activation and its significance(pval).
        [rho,pval] = corr(ypredict,yorigin);
        r=[r,rho];
        p=[p,pval];
        end
    rz=[rz;r];
    pz=[pz;p];
    end
 end
 
 group_origin=mean(yoriginmean,2);
 group_predict=mean(ypredictmean,2);
 save('E:\data\OT\newresult\plot\brain\group\OTVDMN\group_origin.mat','group_origin');
 save('E:\data\OT\newresult\plot\brain\group\OTVDMN\group_predict.mat','group_predict');
 
%Now we average the correlation coefficients of the two sessions for each subject.
men10=[];
for g=1:29
    h=g+29;
    mn=mean([rz(g,:);rz(h,:)]);
    men10=[men10;mn];
end
save('E:\data\OT\newresult\OTtoOT\10VDMN\men10.mat','men10');
%save('E:\data\OT\newresult\PLtoPL\27DDMN\predict27.mat','predict27');

%calculate the increasing degree of self-predicted accuracy relative to other-predicted accuracy.
difference10=[];
precentage10=[];
for i=1:29
a=men10(:,i);
delete=i;
a(delete,:)=[];
difold=men10(i,i)-mean(a);
difference10=[difference10;difold];
precentold=difold/mean(a);
precentage10=[precentage10;precentold];
end
save('E:\data\OT\newresult\PLtoPL\10VDMN\difference10.mat','difference10');
save('E:\data\OT\newresult\PLtoPL\10VDMN\precentage10.mat','precentage10');

%Take the mean of predicting yourself and the mean of predicting others.
predictself10=[];
predictother10=[];
for i=1:29
    predictself10=[predictself10;men10(i,i)];
    a=men10(:,i);
    delete=i;
    a(delete,:)=[];
    predictother10=[predictother10;mean(a)];
end
save('E:\data\OT\newresult\OTtoOT\10VDMN\predictself10.mat','predictself10');
save('E:\data\OT\newresult\OTtoOT\10VDMN\predictother10.mat','predictother10');
