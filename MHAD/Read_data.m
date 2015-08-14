%% we read the single primitive skeleton data for file.

function D = Read_data(file_address, Data_set)

D = [];

if Data_set == 2
    load_name=sprintf('skeleton_data/MHAD_ske/skl_s%02d_a%02d_r%02d.mat',file_address(1),file_address(2),file_address(3));
    if exist(load_name,'file') == 0
       display(load_name);
       return;
    end
    load(load_name);
    D = ones(size(ske,1),1)*file_address(2);
    ske = ske / 1000;
    D = [D, ske];
end
