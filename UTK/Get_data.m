%% get the train or test data  
function train_data = Get_data(list, t, Data_set, aver, act_lab)

if Data_set == 3
    J = [1 1  1  2 3 3 3 5 6 7 9  10 11 13 14 15 17 18 19;
         2 17 13 3 4 5 9 6 7 8 10 11 12 14 15 16 18 19 20];
    %  lo = [2 5 7 9 11 13 14 15 17 18 19 21 22 25 27 29 31 33 34 35 37 38 39 41 42 45 47 49 51 53 54 55 57 58 59 61];
    lo =[7 9 27 29 47 49  11 13 31 33 51 53   15 17 35 37 55 57   19 21 39 41 59 61  2 5 22 25 42 45 ];
end

% get the training data
train_data = [];

for i = 1:size(list, 1)
        
    st_lo = ((list(i,1) -1)*2 + list(i,2))*10;
    A = Read_data(list(i,:), Data_set, act_lab(st_lo-9:st_lo,:));
    A = normi(A,aver,J);
    
    if numel(A) == 0
        continue;
    end
    
    
   l = size(A,1);
    len = 1 + (6*8 + 6*8 + 6*t*2)*5;
    tempdata = ones(l-2*t,len);
    
    for j = t+1:l-t
        count = 1;
        for p = 1:5
            for k = 1:6
                for p1 = 1:5
                    if p1 == p
                        continue;
                    end
                    tempdata(j-t,count+1) = A(j,lo((p-1)*6+k))-A(j,lo((p1-1)*6 + floor((k-1)/2)*2 + 1));
                    tempdata(j-t,count+2) = A(j,lo((p-1)*6+k))-A(j,lo((p1-1)*6 + floor((k-1)/2)*2 + 2));
                    count = count + 2;
                end
            end
            
            % trajectory
            for k = 1:6
                tra = A(j-t:j+t,lo((p-1)*6+k));
                d = fft(tra);
                tempdata(j-t,count+1:count+4) = real(d(2:5));
                tempdata(j-t,count+5:count+8) = imag(d(2:5));
                count = count + 8;
            end
            
            % dynamic feature 
            for tt = 1:t
                for k = 1:6
                    tempdata(j-t,count+1) = A(j,lo((p-1)*6+k))-A(j-tt,lo((p-1)*6+k));
                    tempdata(j-t,count+2) = A(j,lo((p-1)*6+k))-A(j+tt,lo((p-1)*6+k));
                    count = count + 2; 
                end
            end
        end
        tempdata(j-t,1) = A(j,1); 
    end
    train_data = [train_data;tempdata];
end
end


function B = normi(A,av,J)

    l = size(A,1);
    p = floor((size(A,2)-1)/3);
    
    B  = A;

    for f = 1:l
        for i = 1: size(J,2)
            st = [A(f,J(1,i)+1),A(f,J(1,i)+1+p),A(f,J(1,i)+1+2*p)];
            en = [A(f,J(2,i)+1),A(f,J(2,i)+1+p),A(f,J(2,i)+1+2*p)];
            r = st-en;
            c = -1*av(i)*r/sqrt(r*r');
            B(f,J(2,i)+1)=B(f,J(1,i)+1)+ c(1);
            B(f,J(2,i)+1 + p)=B(f,J(1,i)+1+p)+ c(2);
            B(f,J(2,i)+1 + 2*p)=B(f,J(1,i)+1+2*p)+ c(3);
        end
    end
end