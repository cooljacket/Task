function [accuracy] = FLOA_NKSVM()
	% usage: [accuracy] = FLOA_NKSVM(refreshDataOrNot)
	% refreshDataOrNot = 0, use the saved data while 1 means to calculate again
	% by Jacket, 2015/8/7

	Data_set = 5;
	t = 7;
	%action_num = 9;
	subject_num = 10;
	load('skeleton_data/FLOA_ske/list');
	load('aver');
	numOfFrames = 0;
	correctCase = 0;

	for subject = 1 : subject_num
		dirName = sprintf('data/subject%d', subject);	% s_a_e
		mkdir(dirName);
		list_train_data = list(list(:, 1) ~= subject, :);
		train_data = Get_data(list_train_data, t, Data_set, aver);

		model = svmtrain(train_data(:, 1), train_data(:, 2:end), '-b 1');
		save([dirName '/model.mat'], 'model');
		save([dirName, '/train_data'], 'train_data');
		
		list_test_data = list(list(:, 1) == subject, :);
		testCase = size(list_test_data, 1);
		result = zeros(testCase, 1);
		prediction = zeros(testCase, 1);
		numOfFrames = numOfFrames + testCase;

		for i = 1 : testCase
			test_data = Get_data(list_test_data(i, :), t, Data_set, aver);
			[~, ~, decision] = svmpredict(test_data(:, 1), test_data(:, 2:end), model, '-b 1');
			[~, pre_label] = max(sum(decision));
			prediction(i) = pre_label;
			result(i) = ( pre_label == list_test_data(i, 2) );
		end

		correctCase = correctCase + sum(result);
		save([dirName, '/prediction'], 'prediction');
		save([dirName, '/result'], 'result');
	end

	accuracy = correctCase / numOfFrames;
	disp(sprintf('The SVM accuracy is: %f%%\n', accuracy * 100) );
	save('data/accuracy', 'accuracy');

end

% The SVM accuracy is: 14.418605%