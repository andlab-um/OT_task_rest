%此脚本的输入是OT条件下所有被试静息态和任务态的IC数据，包含的主要输出有：
%1、4个（从任务态中选出了4个成分）30（个静息态成分的beta值）*60（30个人，每个人2个run）的矩阵agg_beta。
%2、第一列为决定系数R方的矩阵R。
%3、将所有被试每个成分的beta做单样本t检验，得到p值（是否显著）
    agg_beta1 = [];
    agg_beta17 = [];
    agg_beta19 = [];
    agg_beta26 = [];
    R1=[];
    R17=[];
    R19=[];
    R26=[];
    
    for i=1:30
    %提取OT条件每个被试的静息态ic作为predictor
    namerest = strcat('OTot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\OT\',namerest]);
    b=compSet.ic;
    %删除几个不用的成分
%     delete=[2,9,14,27,28];
     delete=[8,9,12,15,23,33];
    b(delete,:)=[];
    XrestOT=b';
    x1 = ones(size(XrestOT,1),1);%加上一个全为1的常数项作为比较的空模型，这一步是为了得到决定系数R方，为了避免干扰，后续将使用XrestOT=b'算出的30个主成分的betamap进行分析。
    XrestOT=[x1,XrestOT];

%提取每个被试的任务态主成分

%先提取奇数序列再提取偶数序列，即每个被试的run1和run2(若要偶数序列则改成t=(2:2:60)）
   for j=1:2
    t=(j:2:60);
    e=t(1,i);
    namefunc = strcat('an_ica_br',int2str(e),'.mat');
    load(['E:\data\OT\OT_Functional\ICA\new\testOT_OTdefaultmask\shanghuigui\',namefunc]) ;%使用PL任务态默认生成mask的被试的OTica数据
    a=compSet.ic;
    
    yfOTic1= a(1,:)';%被预测的任务态成分
    yfOTic17= a(17,:)';
    yfOTic19= a(19,:)';
    yfOTic26= a(26,:)';
%算beta值并评估模型
    [b,bint,r,rint,stats] = regress(yfOTic1,XrestOT);%b为评估出来的beta，stats的第一列为决定系数R方
    %将60个session的betamap放到一起
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

%对每个成分的beta做独立样本t检验，以及是否通过了5%t检验（h=1通过，h-0未通过），这一步用的是不带常数项的agg_beta
t1=[];
t26=[];
t19=[];
t17=[];
for i=1:30
    %%得到30个主成分的beta的均值和方差，由循环一行一行的得到
    data1 =agg_beta1(i,:);%所有人的第i个主成分
    %%做t检验
     h1 = ttest(data1);
     t1 = [t1,h1];
    %保存t检验结果
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
%画30个成分的均值-方差箱型图,叠加上t检验显著的信息
label=readtable('E:\data\OT\predictresult\oldstandard\OTtoOT1\label.csv');%这是以OTrest为预测源的，包含30个主成分
boxfig1=agg_beta1';
p = boxplot(boxfig1,'BoxStyle' ,'filled','Colorgroup',labelPL.Var1,'OutlierSize',1,'Symbol','.','Widths',0.1,'Labels',labelPL.Var1);
hold on
sz=8;
%调整星号位置
t=0.4*t1;
%星号颜色为黑色
c=[0,0,0];
g=(1:1:30);
scatter(g,t,sz,c,'*');
hold off