% Main results obtained by this script include:
%1:functional connectivity among networks for each subject in both OT and PL groups(you can change code in 30th and 60th row to decide on networks that you want to check).
%2:the difference and significance between functional connectivity for two groups.
%3:the between-subject similarity of functional connectivity in both groups, and whether the difference between this index for two groups is significant.

%The subjects receiving OT and PL treatment were selected from 59 subjects respectively
OTname={'1','2','3','4','9','10','15','16','21','22','23','24','25','26','27','28','32','33','38','39','44','45','46','47','48','49','50','51','56','57'};
PLname={'5','6','7','8','11','12','13','14','17','18','19','20','29','30','31','34','35','36','37','40','41','42','43','52','53','54','55','58','59'};

%% Calculate functional connectivity matrix and difference between networks

%functional connectivity matrix in the resting state
Rdifagg=zeros(9,9);
for i=1:29
%PL group
  namerest = strcat('rest_ica_br',PLname{1,i},'.mat');
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
    
   XnetworkPL=[BGN,VN,VDMN,DDMN,SN,ASN,AN,HVN,PN];
    RPL=corrcoef(XnetworkPL);%Calculate the correlation coefficient among networks
    
    %fisher transformation
    zPL=0.5*log((1+RPL)./(1-RPL));
    for d=1:size(XnetworkPL,2)
        zPL(d,d)=1;%Set the diagonal value to 1
    end
    %The z values of r 
    RPLagg{i}=zPL;
    
    %OT group
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

    XnetworkOT=[BGN,VN,VDMN,DDMN,SN,ASN,AN,HVN,PN];
    ROT=corrcoef(XnetworkOT);
    
    zOT=0.5*log((1+ROT)./(1-ROT));
    for d=1:size(XnetworkOT,2)
        zOT(d,d)=1;
    end
    
    ROTagg{i}=zOT;
    %Compute the difference between the two conditional matrices
%      Rdiff=ROT-RPL;
%      Rdifagg=Rdifagg+Rdiff;
end
Rdif=Rdifagg/29;

i=30;%Make up the 30th subject in the OT group
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

    XnetworkOT=[BGN,VN,VDMN,DDMN,SN,ASN,AN,HVN,PN];
    ROT=corrcoef(XnetworkOT);

    zOT=0.5*log((1+ROT)./(1-ROT));
    for d=1:9
        zOT(d,d)=1;
    end
    
    ROTagg{i}=zOT;
save('E:\data\OT\newresult\correlation\time\Rdif.mat','Rdif');

%functional connectivity matrix in the task state
taskrdifagg=zeros(3,3);
for i=1:29
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

    zOT=0.5*log((1+taskrOT)./(1-taskrOT));
    for d=1:3
        zOT(d,d)=1;
    end
    
    taskROTagg{i}=zOT;
    
    taskrdiff=taskrOT-taskrPL;
    taskrdifagg=taskrdifagg+taskrdiff;
end
taskrdifagg=taskrdifagg/29;

i=30;%Make up the 30th subject in the OT group
namerest = strcat('task_ica_br',OTname{1,i},'.mat');
    load(['E:\data\OT\newresult\ICAtask\',namerest]);
    b=compSet.tc;
    pn=b(:,29);
    ddmn=b(:,27);
    vdmn=b(:,10);
    taskOT=[pn,ddmn,vdmn];
    taskrOT=corrcoef(taskOT);

    zOT=0.5*log((1+taskrOT)./(1-taskrOT));
    for d=1:3
        zOT(d,d)=1;
    end
    
    taskROTagg{i}=zOT;
save('E:\data\OT\newresult\correlation\time\taskrdifagg.mat','taskrdifagg');
          
%% Testing whether there is significant difference between FC matrix of OT and PL group

%T test was performed on task-state brain network connections and P values were recorded
c=[];
g=[];
otp=zeros(3,3);
otT=zeros(3,3);
for x=1:3
   for y=(x+1):3
        for i=1:29
        a=taskROTagg{i};
        e=taskRPLagg{i};
        b=a(y,x);%The correlation coefficients of all Pairs of networks of each subject in OT group were obtained
        f=e(y,x);%The correlation coefficients of all Pairs of networks of each subject in PL group were obtained
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

%T test was performed on resting-state brain network connections and P values were recorded
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
%% Calculate whether the between-subject similarity of OT group and PL group is significantly different
%task state
PLsub=[];  
OTsub=[];  
 for i=1:29
     a=tril(taskRPLagg{i});%Extract the upper triangular matrix
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
