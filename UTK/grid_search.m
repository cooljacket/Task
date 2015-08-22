function [bestAccuracy, bestOption] = grid_search()
	log2c = [-5:15];
	log2g = [-15:3];
	bestAccuracy = 0.00;

	for cc = log2c
		for gamma = log2g
			svm_options = sprintf('-c %f -g %f -b 1', pow2(cc), pow2(gamma));
			accuracy = UTK_NKSVM(svm_options);
			if accuracy > bestAccuracy
				bestAccuracy = accuracy;
				bestOption = svm_options;
			end
		end
	end

	save('data/bestAccuracy', 'bestAccuracy');
	save('data/bestOption', 'bestOption');
end