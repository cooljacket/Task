function test()
	filename1 = 'skeleton_data/UTkinect_ske/actionLabel1.txt';
	filename2 = 'skeleton_data/UTkinect_ske/actionLabel2.txt';

	fp1 = fopen(filename1);
	fp2 = fopen(filename2);
	if (fp1 > 0)
		A = fscanf(fp1, '%f');
		fclose(fp1);
	end;
	if (fp2 > 0)
		B = fscanf(fp2, '%f');
		fclose(fp2);
	end;

	r = A == B
end