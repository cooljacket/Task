function ToSVMFormat(remove11Label)
% Change the train data into the format that can be used for libsvm
% by Jacket, 08/13/2015

	Data_set = 3;
	t = 7;
	action_num = 10;
	load('data/aver');
	load('data/act_label');
	load('data/list_train_data');
	train_data = Get_data(list_train_data, t, Data_set, aver, act_label);
	fileName = 'data/UTK.svm';
	if remove11Label == 1
		train_data = train_data(train_data(:, 1) <= action_num, :);
		fileName = 'data/UTK_remove11Label.svm';
	end
	fid = fopen(fileName, 'w');
	if fid == 0
		error('Failed to open the file to write...')
	end

	for row = 1 : size(train_data, 1)
		fprintf(fid, '%d', train_data(row, 1) );
		for col = 2 : size(train_data, 2)
			fprintf(fid, ' %d:%f', col-1, train_data(row, col));
		end
		fprintf(fid, '\n');
	end
	
	fclose(fid);
end