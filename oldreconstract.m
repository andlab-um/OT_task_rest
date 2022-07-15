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
      %delete=[2,9,14,27,28];
      delete=[1,2,3,5,7,9,10,11,12,14,18,19,20,23,25,26,27,28,31,32,34];
      b(delete,:)=[];
      XrestPL=b';
      
% %     OT静息态成分及最后的X
%       delete=[8,9,12,15,23,33];
%       b(delete,:)=[];
%       XrestOT=b';
    
        for c=1:29
        t=(2:2:58);
        e=t(1,c);
        namefunc = strcat('PLot_ica_br',int2str(e),'.mat');
        load(['E:\data\OT\OT_Functional\ICA\new\testPL_OTdefaultmask\',namefunc]) ;%使用任务态默认生成mask的被试的ica数据
        yorigin=(compSet.ic(27,:))';
        ypredict=XrestPL*agg_beta27(:,i);%与myreconstruct不同的是，这里使用的是第i个被试的静息态数据和第i个被试的30个主成分的betamap
        %把自己预测自己得出的y的提取出来
%         tf=isequal(1,c);
%         if tf>0
%             predict=[predict,ypredict];
%         else
%             predict=predict;
%         end
        
        [rho,pval] = corr(ypredict,yorigin);
        r=[r,rho];
        p=[p,pval];
        end
    rz=[rz;r];
    pz=[pz;p];
    
end
%把每个被试两个session的相关系数平均起来,第一行是第一个人预测所有人，第二行是第二个人预测所有人，以此类推。
menold=[];
for g=1:29
    h=g+29;
    mn=mean([rz(g,:);rz(h,:)]);
    menold=[menold;mn];
end
save('E:\data\OT\predictresult\newstandard\PLtoPL\28DDMN\menold.mat','menold');
%save('E:\data\OT\predictresult\newstandard\OTtoOT1\26VDMN\predict.mat','predict');
%算自己预测自己和自己预测他人之间的差
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

%将预测自己和预测他人的均值都提取出来
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
