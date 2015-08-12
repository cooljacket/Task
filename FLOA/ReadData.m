function [label, Data] = ReadData(list_data)
% Read skeleton data according the key parameters in file name
% The format of file name is like: s1_a1_e2_ske.mat
% Return the label vector and the data matrix
% By Jacket, 08/12/2015

	label = [];
	Data = [];
	for i = 1 : size(list_data, 1)
		fileName = sprintf('skeleton_data/FLOA_ske/s%d_a%d_t%d', list_data(i, :));
		load(fileName);			% data, size(data) = [numOfFrames * 45];
		Data = [Data; data];
		label = [label; ones(size(data, 1), 1) * list_data(i, 2)];
	end
end