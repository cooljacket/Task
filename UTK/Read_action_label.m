function Read_action_label()
	filename = 'skeleton_data/UTkinect_ske/actionLabel2.txt';

	if exist(filename, 'file') == 0
		display('No action_label exist');
		return ;
	end

	fp = fopen(filename);
	if (fp > 0)
		A = fscanf(fp, '%f');
		fclose(fp);
	end;

	l =  numel(A) / 2;
	A = reshape(A, 2, l);
	act_label = A';
	save('data/act_label', 'act_label');
end