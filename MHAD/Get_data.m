%% get the train or test data  
function train_data = Get_data(list, t, Data_set, aver)

if Data_set == 2
   J = [1  1  1  2  3  4  5 5 5  6  8 9  10 11 12 12 15 16 17 18 19 19 22 23 24 25 26 27 29 30 31 32 33 34 
     2  22 29 3  4  5  6 8 15 7  9 10 11 12 13 14 16 17 18 19 20 21 23 24 25 26 27 28 30 31 32 33 34 35];
    lo = [18 21 53 56 88 91  11 13 46 48 81 83   2 8 37 45 72 78   36 31 71 66 106 101   29 24 64 59 99 94];
end

% get the training data
train_data = [];

for i = 1:size(list,1)
    
    A = Read_data(list(i,:), Data_set);
    if numel(A) == 0
        continue;
    end
    A = normi(A,aver,J);
  %  A = Length_normi(A);
    
    l = size(A,1);
    len = 1 + (6*8 + 6*8 + 6*t*2)*5;
    tempdata = ones(l-2*t,len);
    
    for j = t+1:l-t
        count = 1;
        for p = 1:5
            for k = 1:6
                for p1 = 1:5
                    if p == p1
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
