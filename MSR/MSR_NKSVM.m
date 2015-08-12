function [accuracy] = MSR_NKSVM(refreshDataOrNot)
	% usage: [accuracy] = MSR_NKSVM(refreshDataOrNot)
	% refreshDataOrNot = 0, use the saved data while 1 means to calculate again
	% by Jacket, 2015/8/7

	Data_set = 1;
	t = 7;
	action_num = 20;
	load('data/aver');

	if refreshDataOrNot
		load('data/list_train_data');
		train_data = Get_data(list_train_data, t, Data_set, aver);
		model = svmtrain(train_data(:, 1), train_data(:, 2:end), '-b 1');
		save('data/train_data', 'train_data');
		save('data/model', 'model');
	else
		load('data/model');
	end

	load('data/list_test_data');
	testCase = size(list_test_data, 1);
	% prepare the space for the matrix will make the program faster
	result = zeros(testCase, 1);
	prediction = zeros(testCase, 1);
	for i = 1 : testCase
		test_data = Get_data(list_test_data(i, :), t, Data_set, aver);
		[~, ~, decision] = svmpredict(test_data(:, 1), test_data(:, 2:end), model, '-b 1');
		[~, pre_label] = max(sum(decision));
		prediction(i) = pre_label;
		result(i) = ( pre_label == list_test_data(i, 1) );
	end

	accuracy = sum(result) / testCase;
	disp(sprintf('The SVM accuracy is: %f%%\n', accuracy*100) );
	save('data/prediction', 'prediction');
	save('data/result', 'result');
	save('data/accuracy', 'accuracy');

end

% The SVM accuracy is: 77.289377%