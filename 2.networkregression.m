%The inputs of this script include all resting and task ICs obtained by GIFT.
%The outputs of this script include:
%1. the contribution of the resting networks in predicting every task ICs, thus every task IC has a network_beta.mat. 
%2. the determination coefficients R square for each task IC, stored in the networkR.mat.
%3. the results of the one-sample t-test which is performed to test whether the beta value of each resting network is significantly larger than zero, stored in the networkt.mat.
%OT
    network_beta10 = [];
    network_beta27 = [];
    network_beta29 = [];
    netR10=[];
    netR27=[];
    netR29=[];
    OTname={'1','2','3','4','9','10','15','16','21','22','23','24','25','26','27','28','32','33','38','39','44','45','46','47','48','49','50','51','56','57'};
    PLname={'5','6','7','8','11','12','13','14','17','18','19','20','29','30','31','34','35','36','37','40','41','42','43','52','53','54','55','58','59'};

for j=1:2   
    for i=1:length(OTname)
    namerest = strcat('rest_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAresting\',namerest]);
    b=compSet.ic;
    %averaged ICs belonging to one network
    BGN=b(5,:)';
    vdmn=b([18,23],:);
    VDMN=(mean(vdmn))';
    ddmn=b([13,28],:);
    DDMN=(mean(ddmn))';
    sn=b([1,31],:);
    SN=(mean(sn))';
    ASN=b(6,:)';  
    AN=b(15,:)';  
    HVN=b(36,:)';
    VN=b(24,:)'; 
    PN=b(7,:)';
    
    XnetworkOT=[SN,BGN,ASN,PN,DDMN,AN,VDMN,VN,HVN];
    x1 = ones(size(XnetworkOT,1),1);%this step is needed to calculate the determination coefficients.
    XnetworkOT=[x1,XnetworkOT];
   
    t=(j:2:118);
    otname=[1,2,3,4,9,10,15,16,21,22,23,24,25,26,27,28,32,33,38,39,44,45,46,47,48,49,50,51,56,57];%OT
    %otname=[5,6,7,8,11,12,13,14,17,18,19,20,29,30,31,34,35,36,37,40,41,42,43,52,53,54,55,58,59];%PL
    e=t(1,otname);
    y=e(1,i);
    namefunc = strcat('task_ica_br',int2str(y),'.mat');
    load(['E:\data\OT\newresult\ICAtask\',namefunc]) ;%使用PL任务态默认生成mask的被试的OTica数据
    a=compSet.ic;
    yfOTic10= a(10,:)';
    yfOTic27= a(27,:)';
    yfOTic29= a(29,:)';
%Calculate beta and evaluate the model
    [b,bint,r,rint,stats] = regress(yfOTic10,XnetworkOT);
    network_beta10 = [network_beta10,b];
    netR10=[netR10;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic27,XnetworkOT);
    network_beta27 = [network_beta27,b];
    netR27=[netR27;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic29,XnetworkOT);
    network_beta29 = [network_beta29,b];
    netR29=[netR29;stats];
   end
end
network_beta10(1,:)=[];
network_beta29(1,:)=[];
network_beta27(1,:)=[];
save('E:\data\OT\newresult\OTtoOT\10VDMN\netR10.mat','netR10');
save('E:\data\OT\newresult\OTtoOT\27DDMN\netR27.mat','netR27');
save('E:\data\OT\newresult\OTtoOT\29PN\netR29.mat','netR29');

save('E:\data\OT\newresult\OTtoOT\10VDMN\network_beta10.mat','network_beta10');
save('E:\data\OT\newresult\OTtoOT\27DDMN\network_beta27.mat','network_beta27');
save('E:\data\OT\newresult\OTtoOT\29PN\network_beta29.mat','network_beta29');

%one-sample t-teest
networkt10=[];
networkt29=[];
networkt27=[];
networkp10=[];
networkp29=[];
networkp27=[];
for i=1:9
    data10 =network_beta10(i,:);
     [h10,p10] = ttest(data10);
     networkt10 = [networkt10,h10];
     networkp10 = [networkp10,p10];
    save('E:\data\OT\newresult\OTtoOT\10VDMN\networkt10.mat','networkt10');
    save('E:\data\OT\newresult\OTtoOT\10VDMN\networkp10.mat','networkp10');

     data29 =network_beta29(i,:);
      [h29,p29] = ttest(data29);
      networkt29 = [networkt29,h29];
      save('E:\data\OT\newresult\OTtoOT\29PN\networkt29.mat','networkt29');
      networkp29 = [networkp29,p29];
      save('E:\data\OT\newresult\OTtoOT\29PN\networkp29.mat','networkp29');

     data27 =network_beta27(i,:);
      [h27,p27] = ttest(data27);
      networkt27 = [networkt27,h27];
      save('E:\data\OT\newresult\OTtoOT\27DDMN\networkt27.mat','networkt27');
      networkp27 = [networkp27,p27];
      save('E:\data\OT\newresult\OTtoOT\27DDMN\networkp27.mat','networkp27');
end


%Draw a mean-variance box plot for 13 networks and superimpose the results of t-test.
label=readtable('E:\data\OT\newresult\OTtoOT\label.csv');
boxfig1=network_beta29';
p = boxplot(boxfig1,'BoxStyle' ,'filled','Colorgroup',label.Var1,'OutlierSize',1,'Symbol','.','Widths',0.1,'Labels',label.Var1);
hold on
sz=8;
t=0.4*networkt29;%Adjust the asterisk position
c=[0,0,0];%The asterisk is black in color
g=(1:1:9);
scatter(g,t,sz,c,'*');
hold off
