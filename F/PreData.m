function PreData()
% To: prepare the list_train_data and list_test_data for the MSR.m to use
% In MSR Action3D Dataset, subject 1,3,5,7,9 is for training while 2,4,6,8,10 is for testing
% By Jacket, 08/11/2015
	
	fileName = 'skeleton_data/Florence_dataset_WorldCoordinates.txt';
	fid = fopen(fileName, 'r');
	if fid == 0
		error(['Can not open the file ', fileName]);
	end

	content = fscanf(fid, '%f');
	content = reshape(content, 48, length(content) / 48)';	% 48 = 3 + 3(dimPerJoint) * 15(joints)
	fclose(fid);
	dirName = 'skeleton_data/FLOA_ske/';
	[video, subject] = deal([1], [1]);
	[action, time, data, list] = deal([1], [1], [], [1, 1, 1]);

	for i = 1 : size(content)
		if content(i, 1) == video
			data = [data; content(i, 4:end)];
		else
			fileName = sprintf('s%d_a%d_t%d', subject, action, time);
			save([dirName, fileName], 'data');
			data = content(i, 4:end);
			video = content(i, 1);

			if content(i, 3) == action
				time = time + 1;
			else
				time = 1;
				subject = content(i, 2);
				action = content(i, 3);
			end

			list = [list; [subject, action, time]];
		end

	end

	list = list(1:end-1, :);
	save([dirName, 'list'], 'list');
end