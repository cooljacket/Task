function [accuracy] = UTK_NKSVM(refreshDataOrNot)
	% usage: [accuracy] = UTK_NKSVM(refreshDataOrNot)
	% refreshDataOrNot = 0, use the saved data while 1 means to calculate again
	% by Jacket, 2015/8/7

	Data_set = 3;
	t = 7;
	action_num = 10;
	load('data/aver');
	load('data/act_label');

	if refreshDataOrNot
		load('data/list_train_data');
		train_data = Get_data(list_train_data, t, Data_set, aver, act_label);

		% I remove the redundant frames with label 11
		train_data = train_data(train_data(:, 1) <= action_num, :);
		model = svmtrain(train_data(:, 1), train_data(:, 2:end), '-b 1');
		save('data/model', 'model');
		save('data/train_data', 'train_data');
	else
		load('data/model');
	end

	load('data/list_test_data');
	testCase = size(list_test_data, 1);
	result = [];
	prediction = [];
	for i = 1 : testCase
		test_data = Get_data(list_test_data(i, :), t, Data_set, aver, act_label);
		% Everytime read one action sequence file, each file contains all the 10 actions
		% The format of files is like: joints_s01_e01.txt, where s stands for subject
		% Each subject plays the same action for 2 times, use e to indicate this
		for action = 1 : action_num
			tData = test_data(test_data(:, 1) == action, :);
			test_label = tData(:, 1);
			[~, ~, decision] = svmpredict(test_label, tData(:, 2:end), model, '-b 1');
			[~, pre_label] = max(sum(decision));
			prediction = [prediction; pre_label];
			result = [result; (pre_label == action)];
		end
	end

	accuracy = sum(result) / (testCase * action_num);
	disp(sprintf('The SVM accuracy is: %f%%\n', accuracy*100) );
	save('data/prediction', 'prediction');
	save('data/result', 'result');
	save('data/accuracy', 'accuracy');

end

% The SVM accuracy is: 20.000000% (train_data with the extra label 11)
% The SVM accuracy is: 64.000000% (remove the 11 label from train_data)