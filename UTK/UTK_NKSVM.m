function [accuracy] = UTK_NKSVM(svm_options)
	% by Jacket, 2015/8/7

	Data_set = 3;
	t = 7;
	action_num = 10;
	load('data/aver');
	load('data/act_label');
	
	if exist('data/train_data', 'file')
		load('data/train_data');
	else
		load('data/list_train_data');
		train_data = Get_data(list_train_data, t, Data_set, aver, act_label);
		save('data/train_data', 'train_data');
	end
	
	% I remove the redundant frames with label 11
	train_data = train_data(train_data(:, 1) <= action_num, :);
	% svm_options = '-c 64.0 -g 0.015625 -b 1';
	svm_options = '-b 1';
	model = svmtrain(train_data(:, 1), train_data(:, 2:end), svm_options);
	save('data/model', 'model');
	

	load('data/list_test_data');
	testCase = size(list_test_data, 1);
	result = [];
	prediction = [];
	for i = 1 : testCase
		test_data = Get_data(list_test_data(i, :), t, Data_set, aver, act_label);
		% Everytime read one action sequence file, each file contains the whole 10 actions
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
	disp(sprintf('The SVM accuracy is: %f%% (with svm options: %s)\n', accuracy * 100, svm_options) );
	save('data/prediction', 'prediction');
	save('data/result', 'result');
	save('data/accuracy', 'accuracy');

end

% with the 11th label
% The SVM accuracy is: 20.000000% (train_data with the extra label 11)
% The SVM accuracy is: 20.000000% (with svm options: -c 256.0 -g 0.015625 -b 1)

% =======================================================

% remove the 11th label
% The SVM accuracy is: 64.000000% (remove the 11 label from train_data) with default settings
% The SVM accuracy is: 61.000000% (with svm options: -c 16.0 -g 0.015625 -b 1)
% Finished