function FLOA()
% frame level descriptor v0.00 = original skeleton data
% by jacket, 08/11/2015

subject_num = 10;
correct_num = 0;
test_num = 0;
load('skeleton_data/FLOA_ske/list');

for subject_out = 1 : subject_num
	dirName = sprintf('data/subject_out%d', subject_out);
	mkdir(dirName);
	dirName = [dirName, '/'];

	list_train_data = list(list(:, 1) ~= subject_out, :);
	[train_label, train_data] = ReadData(list_train_data);
	model = svmtrain(train_label, train_data, '-b 1');
	save([dirName, 'model'], 'model');
	% dirName = [dirName, '/'];
	% load([dirName, 'model']);

	list_test_data = list(list(:, 1) == subject_out, :);
	testCase = size(list_test_data, 1);
	prediction = zeros(testCase, 1);
	result = zeros(testCase, 1);
	for action = 1 : testCase
		[test_label, test_data] = ReadData(list_test_data(action, :));
		[~, ~, decision] = svmpredict(test_label, test_data, model, '-b 1');
		[~, pre_label] = max(sum(decision));
		prediction(action) = pre_label;
		% list_test_data format is like: s1_a1_t2
		result(action) = ( pre_label == list_test_data(action, 2) );
	end

	correct_num = correct_num + sum(result);
	test_num = test_num + testCase;
	save([dirName, 'prediction'], 'prediction');
	save([dirName, 'result'], 'result');

end

	accuracy = correct_num / test_num;
	disp( sprintf('FLOA accuracy is: %f%%\n', accuracy * 100) );
	save('data/accuracy', 'accuracy');

end
% FLOA accuracy is: 56.074766%