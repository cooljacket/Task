%% we read the single primitive skeleton data for file.
%  file_address: file address number
%  Dataset:  Dataset == 1: MSR
%            Dataset == 2: XX

function D = Read_data(file_address, Data_set, act_lab)

D = [];

if Data_set == 1
    load_name=sprintf('depth_data/a%02d_s%02d_e%02d_skeleton3D.txt',file_address(1),file_address(2),file_address(3));

    if exist(load_name,'file') == 0
       display('read data error');
       return ;
    end
    
    fp=fopen(load_name);
    if (fp>0)
       A=fscanf(fp,'%f');
       fclose(fp);
    end;

    l = size(A,1)/4;
    A = reshape(A,4,l);
    temp = zeros(3,20);
    
    for i  = 1:l/20
        st = 20*(i-1)+1;
        en = st +19;
        t = A(1:3,st:en);
        if t == temp
            continue;
        end
        D = [D;file_address(1) t(1,:) t(2,:) t(3,:),1,en];
    end

elseif Data_set == 2
    load_name=sprintf('skeleton_data/MHAD_ske/skl_s%02d_a%02d_r%02d.mat',file_address(1),file_address(2),file_address(3));
    if exist(load_name,'file') == 0
       display(load_name);
       return;
    end
    load(load_name);
    D = ones(size(ske,1),1)*file_address(2);
    ske = ske/1000;
    D = [D,ske];
else
    load_name = sprintf('skeleton_data/UTkinect_ske/joints_s%02d_e%02d.txt',file_address(1),file_address(2));  
    
    if exist(load_name,'file') == 0
       display('read data error');
       return ;
    end
    
    fp = fopen(load_name);
    if (fp>0)
       A=fscanf(fp,'%f');
       fclose(fp);
    end;
    
    l = size(A,1)/61;
    A = reshape(A, 61,l);
    A = A';
    current_action = 1;
    j = 1;
    for i = 1:size(A,1)
        B = A(i,2:61);
        C = reshape(B,3,20);
        line = [C(1,:) C(2,:) C(3,:)];
        if i > 1
            if A(i,1) == A(i-1,1)
                continue;
            end
        end
        if A(i,1) >= act_lab(current_action,1) & A(i,1) <= act_lab(current_action,2)
            D(j,:) = [current_action,line];
        elseif A(i,1) < act_lab(current_action,1)
            D(j,:) = [11,line];
        else
            D(j,:) = [11,line];
            if current_action < 10
                current_action = current_action + 1;
            end
        end
        j = j + 1;
    end
   
end

end