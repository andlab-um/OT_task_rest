%从59个被试中分别选出接受OT和PL处理的被试
OTname={'1','2','3','4','9','10','15','16','21','22','23','24','25','26','27','28','32','33','38','39','44','45','46','47','48','49','50','51','56','57'};
PLname={'5','6','7','8','11','12','13','14','17','18','19','20','29','30','31','34','35','36','37','40','41','42','43','52','53','54','55','58','59'};
%% 计算ic间的FC矩阵及差异

%rest的时间相关矩阵
Rdifagg=zeros(9,9);
for i=1:29
%PL的网络间相关性
  namerest = strcat('rest_ica_br',PLname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAresting\',namerest]);
    b=compSet.tc;
%%%PL静息态成分及最后的X     
    BGN=b(:,5);
    VN=b(:,24);
    vdmn=b(:,[18,23]);
    VDMN=(mean(vdmn,2));
    ddmn=b(:,[13,28]);
    DDMN=(mean(ddmn,2));
    sn=b(:,[1,31]);
    SN=(mean(sn,2));
    ASN=b(:,6);
    AN=b(:,15);
    HVN=b(:,36);
    PN=b(:,7);
    
   %XnetworkPL=[BGN,VN,VDMN,DDMN,SN,ASN,AN,HVN,PN];
   XnetworkPL=[VDMN,DDMN,PN];
    RPL=corrcoef(XnetworkPL);
    
    %fisher 变换
    zPL=0.5*log((1+RPL)./(1-RPL));
    for d=1:3
        zPL(d,d)=1;%将对角线数值设为1
    end
    %记录每个被试的网络间相关的z值
    RPLagg{i}=zPL;
    
    %OT网络间相关性
    namerest = strcat('rest_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAresting\',namerest]);
    b=compSet.tc;

    BGN=b(:,5);
    VN=b(:,24);
    vdmn=b(:,[18,23]);
    VDMN=(mean(vdmn,2));
    ddmn=b(:,[13,28]);
    DDMN=(mean(ddmn,2));
    sn=b(:,[1,31]);
    SN=(mean(sn,2));
    ASN=b(:,6);
    AN=b(:,15);
    HVN=b(:,36);
    PN=b(:,7);

    %XnetworkOT=[BGN,VN,VDMN,DDMN,SN,ASN,AN,HVN,PN];
    XnetworkOT=[VDMN,DDMN,PN];
    ROT=corrcoef(XnetworkOT);
    
    %fisher 变换
    zOT=0.5*log((1+ROT)./(1-ROT));
    for d=1:3
        zOT(d,d)=1;
    end
    
    ROTagg{i}=zOT;
    %算两个条件矩阵的差值
%      Rdiff=ROT-RPL;
%      Rdifagg=Rdifagg+Rdiff;
end
Rdif=Rdifagg/29;

i=30;%补上OT的第30个被试
namerest = strcat('rest_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAresting\',namerest]);
    b=compSet.tc;

    BGN=b(:,5);
    VN=b(:,24);
    vdmn=b(:,[18,23]);
    VDMN=(mean(vdmn,2));
    ddmn=b(:,[13,28]);
    DDMN=(mean(ddmn,2));
    sn=b(:,[1,31]);
    SN=(mean(sn,2));
    ASN=b(:,6);
    AN=b(:,15);
    HVN=b(:,36);
    PN=b(:,7);

    %XnetworkOT=[BGN,VN,VDMN,DDMN,SN,ASN,AN,HVN,PN];
    XnetworkOT=[VDMN,DDMN,PN];
    ROT=corrcoef(XnetworkOT);
    
    %fisher 变换
    zOT=0.5*log((1+ROT)./(1-ROT));
    for d=1:9
        zOT(d,d)=1;
    end
    
    ROTagg{i}=zOT;
save('E:\data\OT\newresult\correlation\time\Rdif.mat','Rdif');

%task的相关矩阵
taskrdifagg=zeros(3,3);
for i=1:29
    %提取每个被试的任务态tc
    namerest = strcat('task_ica_br',PLname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAtask\',namerest]);
    b=compSet.tc;

 	pn=b(:,29);
    ddmn=b(:,27);
    vdmn=b(:,10);
    taskPL=[pn,ddmn,vdmn];
    taskrPL=corrcoef(taskPL);
    
    zPL=0.5*log((1+taskrPL)./(1-taskrPL));
    for d=1:3
        zPL(d,d)=1;
    end
    
    taskRPLagg{i}=zPL;
    
    namerest = strcat('task_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAtask\',namerest]);
    b=compSet.tc;
    pn=b(:,29);
    ddmn=b(:,27);
    vdmn=b(:,10);
    taskOT=[pn,ddmn,vdmn];
    taskrOT=corrcoef(taskOT);
    
    %fisher 变换
    zOT=0.5*log((1+taskrOT)./(1-taskrOT));
    for d=1:3
        zOT(d,d)=1;
    end
    
    taskROTagg{i}=zOT;
    
    taskrdiff=taskrOT-taskrPL;
    taskrdifagg=taskrdifagg+taskrdiff;
end
taskrdifagg=taskrdifagg/29;

i=30;%补上OT的第30个被试
namerest = strcat('task_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAtask\',namerest]);
    b=compSet.tc;
    pn=b(:,29);
    ddmn=b(:,27);
    vdmn=b(:,10);
    taskOT=[pn,ddmn,vdmn];
    taskrOT=corrcoef(taskOT);
    
    %fisher 变换
    zOT=0.5*log((1+taskrOT)./(1-taskrOT));
    for d=1:3
        zOT(d,d)=1;
    end
    
    taskROTagg{i}=zOT;
save('E:\data\OT\newresult\correlation\time\taskrdifagg.mat','taskrdifagg');
%% 检验OT与PL组的FC矩阵间是否有显著差异

%将任务态脑网络连接做组间t检验并记录p值
c=[];
g=[];
otp=zeros(3,3);
otT=zeros(3,3);
for x=1:3
   for y=(x+1):3
        for i=1:29
        a=taskROTagg{i};
        e=taskRPLagg{i};
        b=a(y,x);%取OT组每个被试的所有pairs of networks的相关值
        f=e(y,x);%取PL组每个被试的所有pairs of networks的相关值
            c=[c;b];
            g=[g;f];
        end
      [h,p,ci,ststs]=ttest2(c(:,1),g(:,1));
      otp(y,x)=p;
       otT(y,x)=ststs.tstat(1,1);
      c=[];
      g=[];
    end
end

%将静息态脑网络连接做组间t检验并记录p值
c=[];
g=[];
otp=zeros(9,9);
otT=zeros(9,9);
for a=1:30
    for x=1:9
       for y=(x+1):9
            for i=1:29
            d=ROTagg{i};
            e=RPLagg{i};
            b=d(y,x);
            f=e(y,x);
                c=[c;b];
                g=[g;f];
            end
          [h,p,ci,ststs]=ttest2(c(:,1),g(:,1));
          otp(y,x)=p;
           otT(y,x)=ststs.tstat(1,1);
          c=[];
          g=[];
       end   
    end
end
%% 计算OT组和PL组的subject variation是否有显著差异
%task state
PLsub=[];  
OTsub=[];  
 for i=1:29
     a=tril(taskRPLagg{i});
    % a=[taskRPLagg{i}(:,1);taskRPLagg{i}(:,2);taskRPLagg{i}(:,5);taskRPLagg{i}(:,6);taskRPLagg{i}(:,7);taskRPLagg{i}(:,8)];
     a=a(find(a~=1));
     a=a(find(a~=0));
     PLsub=[PLsub,a];
     a=[];
 end
for i=1:30
     a=tril(taskROTagg{i});
    % a=[taskROTagg{i}(:,1);taskROTagg{i}(:,2);taskROTagg{i}(:,5);taskROTagg{i}(:,6);taskROTagg{i}(:,7);taskROTagg{i}(:,8)];
     a=a(find(a~=1));
     a=a(find(a~=0));
     OTsub=[OTsub,a];
     a=[];
end
 
 %resting state
PLsub=[];  
OTsub=[];  
 for i=1:29
     a=tril(RPLagg{i});
     %a=[RPLagg{i}(:,3);RPLagg{i}(:,4);RPLagg{i}(:,9)];
     a=a(find(a~=1));
     a=a(find(a~=0));
     PLsub=[PLsub,a];
     a=[];
 end
for i=1:30
     a=tril(ROTagg{i});
     %a=[ROTagg{i}(:,3);ROTagg{i}(:,4);ROTagg{i}(:,9)];
     a=a(find(a~=1));
     a=a(find(a~=0));
     OTsub=[OTsub,a];
     a=[];
end
 
OTsub=corrcoef(OTsub);
PLsub=corrcoef(PLsub);
 
OT=tril(OTsub);
OT=OT(find(OT~=1));
OT=OT(find(OT~=0));

PL=tril(PLsub);
PL=PL(find(PL~=1));
PL=PL(find(PL~=0));
[h,p,ci,ststs]=ttest2(OT(:,1),PL(:,1))