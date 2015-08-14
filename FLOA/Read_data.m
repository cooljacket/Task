%% we read the single primitive skeleton data for file.
%  file_address: file address number
%  Dataset:  Dataset == 1: MSR
%            Dataset == 2: XX

function D = Read_data(file_address, Data_set)

if Data_set == 5
    load_name=sprintf('skeleton_data/FLOA_ske/s%d_a%d_r%d_ske', file_address(1), file_address(2), file_address(3));
    load(load_name);
    
    l = size(vs, 1);
    vs = vs / 1000;

    if l < 20
        add = ((20 - l)+1)/2;
        for i = 1:add
            vs = [vs(1,:); vs; vs(size(vs, 1), :)];
        end
    end 
    D = [file_address(2) * ones(size(vs, 1), 1), vs];
end