%这个脚本主要得到的结果有三个：
%1、men.mat是一个30*30（OT条件每个被试将自己的静息态数据代入每个人的betamap，预测所有30个人的准确率，即相关系数）或29*29（PL条件）的矩阵。
%2、predict.mat是每个人用自己的静息态数据和betamap预测出来的任务态数据，用于画预测脑图，57549（个voxel）*30（人）。
%3、percentage.mat是每个人预测自己的准确率减去预测他人的准确率再除以预测他人的准确率，每个人都有一个值，因此是一个30（人）*1的矩阵
%由于有2个run，所以对于需要预测的每一个任务态成分来说，第一个for循环都需要运行2次，第一次设置参数t=(1:2:58)（即提取任务态的每个被试的奇数项，run1），ypredict=XrestPL*agg_beta(:,c)（agg_beta的前30列是run1的betamap）;第二次设置参数t=(2:2:58)（偶数项run2），ypredict=XrestPL*agg_beta(:,c+29)（后30列是run2的betamap）
%目前是PL条件，如果是OT条件则需要改成i=1：30，使用“OT静息态成分及最后的X”，c=1：30，t=(2:2:60)时ypredict=XrestPL*agg_beta28(:,c+30)，

rz=[];
pz=[];
predict=[];
for i=1:29
    r=[];
    p=[];
    %提取一个被试的静息态ic
    namerest = strcat('PLot_ica_br',int2str(i),'.mat');
    load(['E:\data\OT\OT_Resting\ICA_results_2\PL\',namerest]);
    b=compSet.ic;
%     PL静息态成分及最后的X
      delete=[2,9,14,27,28];
      b(delete,:)=[];
      XrestPL=b';
      
% %     OT静息态成分及最后的X
%       delete=[8,9,12,15,23,33];
%       b(delete,:)=[];
%       XrestOT=b';
    
        for c=1:29
            t=(1:2:58);
            e=t(1,c);
            namefunc = strcat('PLot_ica_br',int2str(e),'.mat');
            load(['E:\data\OT\OT_Functional\ICA\new\testPL_OTdefaultmask\',namefunc]) ;%使用任务态默认生成mask的被试的ica数据
            yorigin=(compSet.ic(28,:))';%注意预测不同成分时需要改这里的值，比如现在预测的是PL任务态里的第28个成分DDMN，就是第28行，下面用到的betamap也是对应的agg_beta28
            %下面的XrestPL是57549*30的矩阵，agg_beta28(:,c)是第c个人的30个主成分的beta值，30*1的矩阵。第i个人用自己的静息态数据和第c个人的beta map，预测出来的任务态成分和第c个人的任务态成分对比。
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
