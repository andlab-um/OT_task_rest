%The inputs of this script include all resting and task ICs obtained by GIFT.
%The outputs of this script include:
%1. the contribution of all the resting ICs in predicting every task ICs, thus every task IC has a agg_beta.mat. 
%2. the determination coefficients R square for each task IC, stored in the R.mat.
%3. the results of the one-sample t-test which is performed to test whether the beta value of each resting ICs is significantly larger than zero, stored in the t.mat.

    agg_beta1 = [];
    agg_beta17 = [];
    agg_beta19 = [];
    agg_beta26 = [];
    R1=[];
    R17=[];
    R19=[];
    R26=[];
    
    for i=1:30
    %load all resting ICs of each subject in the OT group as predictors
    namerest = strcat('OTot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\OT\',namerest]);
    b=compSet.ic;
    %Delete the ICs that does not meet requirements
%     delete=[2,9,14,27,28];%for PL group
     delete=[8,9,12,15,23,33];%for OT group
    b(delete,:)=[];
    XrestOT=b';
    x1 = ones(size(XrestOT,1),1);%This step is to obtain the determination coefficient R squared. In order to avoid interference, betamap of 30 principal components calculated by XrestOT= b' will be used for subsequent analysis.
    XrestOT=[x1,XrestOT];

%Extract the task ICs of each subject

%First extract the odd sequence(session 1) and then the even sequence(session 2).
   for j=1:2
    t=(j:2:60);
    e=t(1,i);
    namefunc = strcat('an_ica_br',int2str(e),'.mat');
    load(['E:\data\OT\OT_Functional\ICA\new\testOT_OTdefaultmask\shanghuigui\',namefunc]);
    a=compSet.ic;
    
    yfOTic1= a(1,:)';%The predicted task IC
    yfOTic17= a(17,:)';
    yfOTic19= a(19,:)';
    yfOTic26= a(26,:)';
%Calculate beta and evaluate the model
    [b,bint,r,rint,stats] = regress(yfOTic1,XrestOT);%b is the beta value, the first column of stats is the determination coefficients R squared
 
    agg_beta1 = [agg_beta1,b];
    R1=[R1;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic17,XrestOT);
    agg_beta17 = [agg_beta17,b];
    R17=[R17;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic19,XrestOT);
    agg_beta19 = [agg_beta19,b];
    R19=[R19;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic26,XrestOT);
    agg_beta26 = [agg_beta26,b];
    R26=[R26;stats];
   end
end
save('E:\data\OT\predictresult\newstandard\OTtoOT1\1PN\R1.mat','R1');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\17ASN\R17.mat','R17');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\19SN\R19.mat','R19');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\R26.mat','R26');

save('E:\data\OT\predictresult\newstandard\OTtoOT1\1PN\agg_beta1.mat','agg_beta1');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\17ASN\agg_beta17.mat','agg_beta17');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\19SN\agg_beta19.mat','agg_beta19');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\agg_beta26.mat','agg_beta26');

%one-sample t test is performed for beta of each resting IC
t1=[];
t26=[];
t19=[];
t17=[];
for i=1:30  
    data1 =agg_beta1(i,:);
     h1 = ttest(data1);
     t1 = [t1,h1];
    save('E:\data\OT\predictresult\newstandard\OTtoOT1\1PN\t1.mat','t1');

     data26 =agg_beta26(i,:);
      h26 = ttest(data26);
      t26 = [t26,h26];
      save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\t26.mat','t26');
 
     data19 =agg_beta19(i,:);
      h19 = ttest(data19);
      t19 = [t19,h19];
      save('E:\data\OT\predictresult\newstandard\OTtoOT1\19SN\t19.mat','t19');

     data17 =agg_beta17(i,:);
      h17 = ttest(data17);
      t17 = [t17,h17];
      save('E:\data\OT\predictresult\newstandard\OTtoOT1\17ASN\t17.mat','t17');
end

%plot results(beta value for each resting IC and the result of t-test)
label=readtable('E:\data\OT\predictresult\oldstandard\OTtoOT1\label.csv');
boxfig1=agg_beta1';
p = boxplot(boxfig1,'BoxStyle' ,'filled','Colorgroup',labelPL.Var1,'OutlierSize',1,'Symbol','.','Widths',0.1,'Labels',labelPL.Var1);
hold on
sz=8;
%Adjust the asterisk position
t=0.4*t1;
%The asterisk is black in color
c=[0,0,0];
g=(1:1:30);
scatter(g,t,sz,c,'*');
hold off
