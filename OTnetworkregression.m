%OT
network_beta1 = [];  
network_beta17 = [];
network_beta19 = [];
network_beta26 = [];
networkR1=[];
networkR17=[];
networkR19=[];
networkR26=[];
for i=1:30
    namerest = strcat('OTot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\OT\',namerest]);
    b=compSet.ic;
    %OT静息态成分及最后的X
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
    x1 = ones(size(XnetworkOT,1),1);
    XnetworkOT=[x1,XnetworkOT];
    
    for j=1:2
    t=(j:2:60);
    e=t(1,i);
    namefunc = strcat('an_ica_br',int2str(e),'.mat');
    load(['E:\data\OT\OT_Functional\ICA\new\testOT_OTdefaultmask\shanghuigui\',namefunc]) ;%使用PL任务态默认生成mask的被试的OTica数据
    a=compSet.ic;
    yfOTic1= a(1,:)';
    yfOTic17= a(17,:)';
    yfOTic19= a(19,:)';
    yfOTic26= a(26,:)';
%算beta值并评估模型
%将60个session的betamap放到一起
    [b,bint,r,rint,stats] = regress(yfOTic1,XnetworkOT);
    network_beta1 = [network_beta1,b];
    networkR1=[networkR1;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic17,XnetworkOT);
    network_beta17 = [network_beta17,b];
    networkR17=[networkR17;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic19,XnetworkOT);
    network_beta19 = [network_beta19,b];
    networkR19=[networkR19;stats];
    
    [b,bint,r,rint,stats] = regress(yfOTic26,XnetworkOT);
    network_beta26 = [network_beta26,b];
    networkR26=[networkR26;stats];
    end

end
save('E:\data\OT\predictresult\newstandard\OTtoOT1\1PN\networkR1.mat','networkR1');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\17ASN\networkR17.mat','networkR17');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\19SN\networkR19.mat','networkR19');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\networkR26.mat','networkR26');

save('E:\data\OT\predictresult\newstandard\OTtoOT1\1PN\network_beta1.mat','network_beta1');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\17ASN\network_beta17.mat','network_beta17');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\19SN\network_beta19.mat','network_beta19');
save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\network_beta26.mat','network_beta26');

networkt1=[];
networkt26=[];
networkt19=[];
networkt17=[];
%第一行是用于对照的空模型常数项，不纳入分析，因此从第二行开始
for i=2:14

    %%得到13个网络的beta的均值和方差，由循环一行一行的得到
    data1 =network_beta1(i,:);
    %%做t检验
     h1 = ttest(data1);
     networkt1 = [networkt1,h1];
    %保存t检验结果
    save('E:\data\OT\predictresult\newstandard\OTtoOT1\1PN\networkt1.mat','networkt1');

     data26 =network_beta26(i,:);
      h26 = ttest(data26);
      networkt26 = [networkt26,h26];
      save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\networkt26.mat','networkt26');
 
     data19 =network_beta19(i,:);
      h19 = ttest(data19);
      networkt19 = [networkt19,h19];
      save('E:\data\OT\predictresult\newstandard\OTtoOT1\19SN\networkt19.mat','networkt19');

     data17 =network_beta17(i,:);
      h17 = ttest(data17);
      networkt17 = [networkt17,h17];
      save('E:\data\OT\predictresult\newstandard\OTtoOT1\17ASN\networkt17.mat','networkt17');
end
%画13个成分的均值-方差箱型图,叠加上t检验显著的信息
labelOT=readtable('E:\data\OT\predictresult\newstandard\OTtoOT1\labelOT.txt');
boxfig26=network_beta26';
p = boxplot(boxfig26,'BoxStyle' ,'filled','Colorgroup',labelOT.Var1,'OutlierSize',1,'Symbol','.','Widths',0.1,'Labels',labelOT.Var1);
hold on
sz=8;
%调整星号位置
t=0.4*networkt1;
%星号颜色为黑色
c=[0,0,0];
g=(1:1:13);
scatter(g,t,sz,c,'*');
hold off