n1 = input('Enter no of rows ');
n2 = input('Enter no of columns ');
disp('Input your path one number at a time, going down the columns')
for nn = 1: n1*n2
 x(nn) = input(['Enter number ' num2str(nn) '\n']);
end
D = reshape(x,n1,n2);
%D = rand(5)*50
idxGlobalMin = min(min(D));
idxGlobalMax = max(max(D));
n = size(D,1);
t = zeros(n,1);
for i = 1:n 
 r1 = D(i,:);
 x= find(r1 == min(r1), 1 );
 r1(x) = [];
 y= find(r1 == max(r1), 1 );
 r1(y) = [];
  t(i)= mean(r1);
end 
disp('Estimated Temprature ')
disp(t);
fprintf('idxGlobalMin = %f\n', min(min(D)))
fprintf('idxGlobalMax = %f\n', max(max(D)))
