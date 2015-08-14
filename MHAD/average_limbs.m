
function aver = average_limbs(Data_set,J)

line = size(J,2);
aver = zeros(line,1);
if Data_set == 1 || Data_set == 3
    points = 20;
else
    points = 35;
end

A = ske(Data_set);
l = size(A,1);
for frame = 1:l/points
    d = points*(frame-1);
    for i = 1:line
        r = A(d+J(1,i),:) - A(d+J(2,i),:);
        aver(i) = aver(i) + sqrt(r*r');
    end;
end;

aver = aver*points/l;
   
end

function C = ske(Data_set)

    C = [];
    if Data_set == 2
        for i = 1:12
            B = Read_data([i,1,1],Data_set);
            for j = 1:10
                C = [C;reshape(B(j,2:106),35,3)];
            end
        end
    end
end