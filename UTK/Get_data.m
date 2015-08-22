%% get the train or test data  
function train_data = Get_data(list, t, Data_set, aver, act_lab)

if Data_set == 1
   J=[ 7 7 7 4 3 3 3  1 8  10 2 9  11 5  14 16 6  15 17;
       5 6 4 3 1 2 20 8 10 12 9 11 13 14 16 18 15 17 19];
    lo = [6,7,8,9,10,13,14,15,16,19,20,21,26,27,28,29,30,13,34,35,36,39,40,41,46,47,48,49,50,53,54,55,56,59,60,61];
elseif Data_set == 2
    J = [1  1  1  2  3  4  5 5 5  6  8 9  10 11 12 15 16 17 18 19 22 23 24 25 26 27 29 30 31 32 33 34 
         2  22 29 3  4  5  6 8 15 7  9 10 11 12 13 16 17 18 19 20 23 24 25 26 27 28 30 31 32 33 34 35];

    lo = [2 8 12 14 15 21 23 25 29 30 32 36 37 43 47 49 50 56 58 60 64 65 67 71 72 78 82 84 85 91 93 95 99 100 102 106];
else
    J = [1 1  1  2 3 3 3 5 6 7 9  10 11 13 14 15 17 18 19;
         2 17 13 3 4 5 9 6 7 8 10 11 12 14 15 16 18 19 20];
    %  lo = [2 5 7 9 11 13 14 15 17 18 19 21 22 25 27 29 31 33 34 35 37 38 39 41 42 45 47 49 51 53 54 55 57 58 59 61];
    lo =[7 9 27 29 47 49  11 13 31 33 51 53   15 17 35 37 55 57   19 21 39 41 59 61  2 5 22 25 42 45 ];
end

% get the training data
train_data = [];

for i = 1:size(list,1)
        
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