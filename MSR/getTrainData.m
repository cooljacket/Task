function [train_data] = getTrainData(KmeansOrNot, refresh)

	if ~refresh
		if KmeansOrNot
			load('data/KTrain_data');
		else
			load('data/train_data');
			return ;
        end
	end
	
	Data_set = 1;
	t = 7;
	action_num = 20;
	kmeansTime = 120;
	load('list_train_data.mat');
	load('aver.mat');
	train_data = Get_data(list_train_data, t, Data_set, aver);

	if ~KmeansOrNot
		save('data/train_data', 'train_data');
		return ;
	end


	[~, train_w] = Kmeans_weighting(train_data, kmeansTime);
	min_w = min([min(train_w) + 0.2, 0.3]);
	train_data(train_w < min_w, 1) = action_num + 1;

	% if exist('data', 'dir') ~= 0
	% 	[~, ~] = rmdir('data', 's');
	% end

	mkdir('data');
	save('data/KTrain_data', 'train_data');
	save('data/KTrain_w', 'train_w');

end