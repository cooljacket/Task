%% get the train or test data  
function train_data = Get_data(list, t, Data_set, aver)

if Data_set == 5
    J =[3   3  3   2  2  2  4  5  7  8  10  11  13  14;
        10  2  13  1  7  4  5  6  8  9  11  12  14  15];
   lo = [6 7 21 22 36 37  9 10 24 25 39 40  2 4 17 19 32 34  12 13 27 28 42 43  15 16 30 31 45 46];
end


% get the training data
train_data = [];

for i = 1:size(list,1)
    
    A = Read_data(list(i,:), Data_set);
    
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

    B  = A;

    for f = 1:l
        for i = 1:14
            st = [A(f,J(1,i)+1),A(f,J(1,i)+16),A(f,J(1,i)+31)];
            en = [A(f,J(2,i)+1),A(f,J(2,i)+16),A(f,J(2,i)+31)];
            r = st-en;
            c = -1*av(i)*r/sqrt(r*r');
            B(f,J(2,i)+1)=B(f,J(1,i)+1)+ c(1);
            B(f,J(2,i)+16)=B(f,J(1,i)+16)+ c(2);
            B(f,J(2,i)+31)=B(f,J(1,i)+31)+ c(3);
        end;
    end;

end