function PreData()
% To: deal with thr raw data in Florence_dataset_WorldCoordinates.txt, divide each coordinat by 1000
% each dimension in the data matrix is like following:
% Head: f1-f3
% Neck: f4-f6
% Spine: f7-f9
% Left Shoulder: f10-f12
% Left Elbow: f13-f15
% Left Wrist: f16-f18
% Right Shoulder: f19-f21
% Right Elbow: f22-f24
% Right Wrist: f25-f27
% Left Hip: f28-f30
% Left Knee: f31-f33
% Left Ankle: f34-f36
% Right Hip: f37-f39
% Right Knee: f40-f42
% Right Ankle: f43-f45
% But this setting doesn't fit shiXiong's original codes, so I don't use it in this lab
% By Jacket, 08/13/2015
	
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
			data = [data; content(i, 4:end) / 1000];
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