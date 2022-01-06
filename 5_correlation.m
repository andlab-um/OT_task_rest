%In this script, we test the connectivity among 13 resting state networks, and the connectivity among ICs in task state.
%The inputs of this script include all resting and task ICs obtained by GIFT.
%Three main outputs will be obtained by this script:
%1. the correlation matrix among networks for both group(ROTagg.mat and RPLagg.mat) on the individual-level in the resting state.
%2. the averaged correlation matrix among networks for both group(ROTmean.mat and RPLmean.mat) on the group-level in the resting state, and the difference between groups(Rdif.mat).
%3. the averaged correlation matrix among networks for both group(taskOTr.mat and taskOTr.mat) on the group-level in the task state.

Rdifagg=zeros(13,13);
ROTagg=zeros(13,13);
RPLagg=zeros(13,13);
for i=1:29
%the correlation coefficients among networks for the PL group
  namerest = strcat('PLot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\PL\',namerest]);
    b=compSet.ic;
%%%average the value of ICs belonging to one network    
     bgn=b(21,:);
    BGN=bgn';
    vn=b([6,20,26],:);
    VN=(mean(vn))';
    recn=b([5,32],:);
    RECN=(mean(recn))';
    vdmn=b([17,22],:);
    VDMN=(mean(vdmn))';
    ddmn=b([1,13,12,24,35],:);
    DDMN=(mean(ddmn))';
    sn=b([4,16,23,30,34],:);
    SN=(mean(sn))';
    asn=b([7,33],:);
    ASN=(mean(asn))';
    an=b(8,:);
    AN=an';
    hvn=b([18,10],:);
    HVN=(mean(hvn))';
    lecn=b([3,15],:);
    LECN=(mean(lecn))';
    ln=b([11,19],:);
    LN=(mean(ln))';
    pn=b([25,29],:);
    PN=(mean(pn))';
    psn=b([31,23],:);
    PSN=(mean(psn))';
    %Computing the correlation matrix
   XnetworkPL=[BGN,VN,RECN,VDMN,DDMN,SN,ASN,AN,HVN,LECN,LN,PN,PSN];
    RPL=corrcoef(XnetworkPL);
    RPLagg=RPL+RPLagg;

%the correlation coefficients among networks for the OT group
    namerest = strcat('OTot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\OT\',namerest]);
    b=compSet.ic;
    bgn=b([4,5,13,32],:);
    BGN=(mean(bgn))';
    vn=b([14,26],:);
    VN=(mean(vn))';
    recn=b(28,:);
    RECN=recn';
    vdmn=b([7,22,29],:);
    VDMN=(mean(vdmn))';
    ddmn=b([3,17,30,34,35],:);
    DDMN=(mean(ddmn))';
    sn=b([1,16,18,19,27],:);
    SN=(mean(sn))';
    asn=b([21,36],:);
    ASN=(mean(asn))';  
    an=b(20,:);
    AN=an';  
    hvn=b([6,10],:);
    HVN=(mean(hvn))';
    lecn=b([2,24],:);
    LECN=(mean(lecn))';
    ln=b(11,:);
    LN=ln'; 
    pn=b(25,:);
    PN=pn';
    psn=b(31,:);
    PSN=psn';
    
    XnetworkOT=[BGN,VN,RECN,VDMN,DDMN,SN,ASN,AN,HVN,LECN,LN,PN,PSN];
    ROT=corrcoef(XnetworkOT);
    ROTagg=ROT+ROTagg;
    %computing the differences between matrices in OT and PL group
    Rdiff=ROT-RPL;
    Rdifagg=Rdifagg+Rdiff;
end
Rdif=Rdifagg/29;
ROTmean=ROTagg/29;
RPLmean=RPLagg/29;
save('E:\data\OT\predictresult\newmethod\Rdif.mat','Rdif');
save('E:\data\OT\predictresult\newmethod\ROTmean.mat','ROTmean');
save('E:\data\OT\predictresult\newmethod\RPLmean.mat','RPLmean');

%correlation matrix in the task state
otr=zeros(4,4);
otp=zeros(4,4);
for i=1:30
    namerest = strcat('an_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Functional\ICA\new\testOT_OTdefaultmask\shanghuigui\',namerest]);
    b=compSet.ic;
%    PL group, when handling PL condition, change I = 1:30 to I = 1:29
% 	pn=(b(27,:))';
%     ddmn=(b(28,:))';
%     sn=(b(13,:))';
%     vdmn=(b(22,:))';
%     taskPL=[pn,ddmn,sn,vdmn];
%     [rho,pval]=corrcoef(taskPL);
%     plr=plr+rho;
%     plp=plp+pval;

%    OT group
    pn=(b(1,:))';
    asn=(b(17,:))';
    sn=(b(19,:))';
    vdmn=(b(26,:))';
    taskOT=[pn,asn,sn,vdmn];
    [rho,pval]=corrcoef(taskOT);
    otr=otr+rho;
     otp=otp+pval;
end
taskOTr=otr/30;
p=otp/30;
taskPLr=plr/29;
p=plp/29;
