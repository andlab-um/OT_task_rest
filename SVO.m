%每组都有哪些被试
lowuu=[];
lowuf=[];
lowfu=[];
lowff=[];
highuu=[];
highuf=[];
highfu=[];
highff=[];
for i=1:37
    folderName{i} = ['highff_',num2str(i),'.csv'];
    opts = detectImportOptions(folderName{i});
    opts.SelectedVariableNames = 17;
    M = readmatrix(folderName{i},opts);
    highff = [highff;M(1,1)];
end
save('E:\myjustice\experiment_1\manuscript\SVO_self.mat','self');

%将原始数据转为给self分配的数额和给other分配的数额
SELF=[];
OTHER=[];
for i=1:15 %15道题
    Self=[];
    Other=[];   
    for j=1:288 %被试数
        a=raw_data(j,i);
        turn_self=self(a,i);
        turn_other=other(a,i);
        
        Self=[Self;turn_self];
        Other=[Other;turn_other];
    end
    SELF=[SELF,Self];
    OTHER=[OTHER,Other]; 
end

%计算每个被试前6道题的SVO
SVO_first=[];
for i=1:288
    svo_first = atan((mean(OTHER(i,1:6))-50)/(mean(SELF(i,1:6))-50))*180/pi
    SVO_first=[SVO_first;svo_first];
end
save('E:\myjustice\experiment_1\manuscript\SVO_self.mat','self');