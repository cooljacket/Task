function MHAD()

%% initialize variables

% Dataset: Dataset = 1: MSR
%          Dataset = 2: MHAD
Data_set = 2;
% the number of trees
numoftree = 100;
% feature_ratio: the ratio of feature for each tree
feature_ratio = 0.1;
% data_rattio: the ratio of training data for each tree
data_ratio = 0.65;
% the number of aciton
action_num = 12;
% the ratio of experiment data
s  = 5;
% the max depth of tree
max_height = 12;
% thres: entropy threshold
thres = 0.00001;
% the length of trajectory(2*t + 1)
t = 7;

J = [1  1  1  2  3  4  5 5 5  6  8 9  10 11 12 12 15 16 17 18 19 19 22 23 24 25 26 27 29 30 31 32 33 34 
     2  22 29 3  4  5  6 8 15 7  9 10 11 12 13 14 16 17 18 19 20 21 23 24 25 26 27 28 30 31 32 33 34 35];

PCA_D = 150;

% Get the list of primitive data
list_test_data = [];
list_train_data = [];
% Get the list of primitive data
for s = 1:12
    for a = 1:11
        for r = 1:5
            if s <= 7
                if (s == 4 & a == 8 & r == 5) | a == 9
                    continue;
                end
                list_train_data = [list_train_data;s a r];
            else
                if a == 9
                    continue;
                end
                list_test_data =[list_test_data;s a r];
            end
        end
    end
end

save('list_test_data.mat','list_test_data');
save('list_train_data.mat','list_train_data');

aver = average_limbs(Data_set,J);
save('aver','aver');

result = zeros(5,1);
descriptor = {'Pose','EigenJoints','Moving_Pose','ours'};

for d = 1:4
    
    temp = eval(['Get_data_',descriptor{d},'(list_train_data,t,Data_set,aver)']);

    if d == 3
       len = size(temp,2);
       [COEFF,SCORE,latent,tsquare] = princomp(temp(:,2:len),'econ');
       me = mean(temp(:,2:len),1);
       train_data = [temp(:,1),SCORE(:,1:PCA_D)];
       save(['train_data/COEFF',num2str(d)],'COEFF');
       save(['train_data/me',num2str(d)],'me');
    else
        train_data = temp;
    end
    
    [cw,w] = Kmeans_weighting(train_data,30);
    save(['k_means/w',num2str(d),'.mat'],'w');

    train_data = [train_data,w];
   
    min_w = min([min(w)+0.2, 0.3]);
    ww = find( w< min_w );
    if numel(ww) > 1000
        lo = randperm(numel(ww));
        wf = ww(lo(1001:numel(ww)));
        ww = ww(lo(1:1000));
        train_data(ww,1) = 12;
        train_data(wf,:) = [];
    else
        train_data(ww,1) = 12;
    end
    
    save(['train_data/train_data',num2str(d),'.mat'],'train_data');

    % Get the train feature
    train_feature = Get_feature(train_data);
    save(['train_data/train_feature',num2str(d),'.mat'],'train_feature');

    % Create Forest
    Forest = Create_Forest( train_data, train_feature, numoftree, feature_ratio, data_ratio, max_height,thres);
   % save(['forest/forest',num2str(d)],'Forest','-v7.3');

    result = Predict_video(d,PCA_D,Forest,result,descriptor);
    display(d)
    display(result(d));
end



