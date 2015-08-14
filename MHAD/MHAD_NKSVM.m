function [accuracy] = MHAD_NKSVM(refreshDataOrNot)
% usage: [accuracy] = MHAD_NKSVM(refreshDataOrNot)
% refreshDataOrNot = 0, use the saved data while 1 means to calculate again
% by Jacket, 2015/8/7

	Data_set = 2;
	t = 7;
	action_num = 11;
	load('data/aver');
	
	if refreshDataOrNot
		load('data/list_train_data');
		train_data = Get_data(list_train_data, t, Data_set, aver);

		svm_options = '-c 2048.0 -g 0.015625 -b 1';
		model = svmtrain(train_data(:, 1), train_data(:, 2:end), svm_options);
		save('data/model', 'model');
	else
		load('data/model');
	end

	load('data/list_test_data');
	testCase = size(list_test_data, 1);
	result = zeros(testCase, 1);
	prediction = zeros(testCase, 1);
	for i = 1 : testCase
		test_data = Get_data(list_test_data(i, :), t, Data_set, aver);
		[~, ~, decision] = svmpredict(test_data(:, 1), test_data(:, 2:end), model, '-b 1');
		[~, pre_label] = max(sum(decision));
		prediction(i) = pre_label;
		result(i) = ( pre_label == list_test_data(i, 2) );
	end

	accuracy = sum(result) / testCase;
	disp(sprintf('The SVM accuracy is: %f%% (with svm options: %s)\n', accuracy * 100, svm_options) );
	save('data/prediction', 'prediction');
	save('data/result', 'result');
	save('data/accuracy', 'accuracy');

end

% The SVM accuracy is: 77.200000% (with default settings)
% The SVM accuracy is: 76.800000% (with svm options: -c 32.0 -g 0.015625 -b 1)
% The SVM accuracy is: 77.200000% (with svm options: -c 256.0 -g 0.015625 -b 1)
% The SVM accuracy is: 76.800000% (with svm options: -c 2048.0 -g 0.015625 -b 1)
% 