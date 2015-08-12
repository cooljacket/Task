function FLOA()
%% initialize variables

% Dataset: Dataset = 1: MSR
%          Dataset = 2: XX
Data_set = 5;
% the number of trees
numoftree = 150;
% feature_ratio: the ratio of feature for each tree
feature_ratio = 0.1;
% data_rattio: the ratio of training data for each tree
data_ratio = 0.65;
% the number of aciton
action_num = 10;
% the ratio of experiment data
s  = 5;
% the max depth of tree
max_height = 10;
% thres: entropy threshold
thres = 0.00001;
% the length of trajectory(2*t + 1)
t = 7;


% Get the list of primitive data 
J =[3   3  3   2  2  2  4  5  7  8  10  11  13  14;
        10  2  13  1  7  4  5  6  8  9  11  12  14  15];
    
filename = 'skeleton_data/FLOA_ske/list.mat';
load(filename);

for a = 9:10

[list_train_data,list_test_data] = Data_list(list,s,a);

save('list_test_data.mat','list_test_data');
save('list_train_data.mat','list_train_data');

aver = average_limbs(Data_set, J);
save('aver','aver');
%Get the train data
%Get the train data
train_data = Get_data(list_train_data,t,Data_set,aver);
save('train_data','train_data');

part = [1,0,0,0,0;
        2,0,0,0,0;
        3,0,0,0,0;
        4,0,0,0,0;
        5,0,0,0,0;
        1,2,0,0,0;
        1,3,0,0,0;
        1,4,0,0,0;
        1,5,0,0,0;
        2,3,0,0,0;
        2,4,0,0,0;
        2,5,0,0,0;
        3,4,0,0,0;
        3,5,0,0,0;
        4,5,0,0,0;
        1,2,3,0,0;
        1,3,4,0,0;
        1,4,5,0,0;
        1,2,4,0,0;
        1,2,5,0,0;
        1,3,5,0,0;
        2,3,4,0,0;
        2,4,5,0,0;
        3,4,5,0,0;
        2,3,5,0,0;
        1,2,3,4,0;
        1,2,3,5,0;
        1,2,4,5,0;
        1,3,4,5,0;
        2,3,4,5,0;
        1,2,3,4,5;
        ];

save('part','part');
for r = 1:31
load('train_data');
temp = train_data(:,1);

for p = 1:5
    if part(r,p) ~=0
        temp = [temp,train_data(:,(part(r,p)-1)*180+2:(part(r,p)*180)+1)];
    else
        break;
    end
end

train_data = temp;

[cw,w] = Kmeans_weighting(train_data,130);
save(['k_means/w',num2str(r),'.mat'],'w');
save(['k_means/cw',num2str(r),'.mat'],'cw');


train_data = [train_data,w];

min_w = min([min(w)+0.2, 0.3]);
train_data(w< min_w) = 10;

save(['train_data/train_data',num2str(r),'.mat'],'train_data');

% Get the train feature
train_feature = Get_feature(train_data);
save(['train_data/train_feature',num2str(r),'.mat'],'train_feature');

% Create Forest
Forest = Create_Forest( train_data, train_feature, numoftree, feature_ratio, data_ratio, max_height,thres);
save(['forest/forest',num2str(a),'_',num2str(r),'.mat'],'Forest');

end

Predict_video(a);
Result(a);

end



%%  electing train_data and test_data
%   data:  object list data matrix
%   list_train_data: the index number of train suquences
%   list_test_data: the index number of train suquences
function [list_train_data,list_test_data] = Data_list(data,s,a)

list_train_data = [];
list_test_data = [];

for i = 1:size(data,1)
    if data(i,1) <= 2*s
    if  data(i,1) ~= a
        list_train_data = [list_train_data;data(i,:)];
    else
        list_test_data = [list_test_data;data(i,:)];
    end
    end
end