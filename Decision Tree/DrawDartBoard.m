N=6;
%M = floor(2*rand(N));
%M = ones(N);
%M(2,6) = 0;
%r = linspace(0,1,N);
r = (2:N)'/N;
%t = linspace(0,2*pi,N);
%t = pi*(-N:N)/N;
t = pi*(-N:N)/N;
%x = r'*cos(t);
%y = r'*sin(t);
x = r*cos(t);
y = r*sin(t);
C = r*cos(2*t);
%M = floor(2*rand(size(x)));
%M = round(2*rand(size(x)));
%M = 2*rand(size(x));
M = ones(size(x));
%M(1,12) = 0;
%M(2,12) = 0;
%M(3,12) = 0;
%M(4,12) = 0;

%{
x1 = [-0.3333 -0.2277 0 0.2277 0.3333 0.2277 0 -0.2277 -0.3333;
      -0.1666 -0.0834 0 0.0834 0.1666 0.0834 0 -0.0834 -0.1666;];
y1 = [0 -0.2277 -0.3333 -0.2277 0 0.2277 0.3333 0.2277 0;
      0 -0.0834 -0.1666 -0.0834 0 0.0834 0.1666 0.0834 0;];
%}
x1 = [-0.3333 -0.2277 0 0.2277 0.3333 0.2277 0 -0.2277 -0.3333;
      -0.1666 -0.0834 0 0.0834 0.1666 0.0834 0 -0.0834 -0.1666;
      -0.1666 -0.1666 0 0 0.1666 0.1666 0 0 -0.1666;
      0 0 0 0 0 0 0 0 0;];
y1 = [0 -0.2277 -0.3333 -0.2277 0 0.2277 0.3333 0.2277 0;
      0 -0.0834 -0.1666 -0.0834 0 0.0834 0.1666 0.0834 0;
      0 0 -0.1666 -0.1666 0 0 0.1666 0.1666 0;
      0 0 0 0 0 0 0 0 0;];
M1 = ones(size(x1));
%M1(1,8) = 0;
%{
x2 = [-0.1666 0 0.1666 0 -0.1666;
      0 0 0 0 0;];
y2 = [0 -0.1666 0 0.1666 0;
      0 0 0 0 0;];
%}  
%x2 = [-0.1666 -0.1666 0 0 0.1666 0.1666 0 0 -0.1666;
%      0 0 0 0 0 0 0 0 0;];
%y2 = [0 0 -0.1666 -0.1666 0 0 0.1666 0.1666 0;
%      0 0 0 0 0 0 0 0 0;];

%M2 = ones(size(x2));

figure
subplot(1,2,1);
pcolor(x,y,M)
colormap(gray(2)), axis equal tight
subplot(1,2,2);
pcolor(x1,y1,M1), %figure; pcolor(x2,y2,M2)
colormap(gray(2)), axis equal tight
%colormap(gray(3)), axis equal tight

%tt = (1/24:1/12:1)'*2*pi;
%xx = sin(tt)*0.3;
%yy = cos(tt)*0.3;
%fill(xx,yy,'r')

%{
X = [0 1 0;
     0 0.5 0;
     1 1.5 1.5;
     0 2 0.5;];
Y = [0 0 1;
     1 0.5 2;
     0 1.5 1.5;
     0 0 0.5;];
 X1 = X*-1;
 Y1 = Y*-1;
 XNew = horzcat(X,X1,X1,X);
 YNew = horzcat(Y,Y,Y1,Y1);
 %fill(XNew,YNew,['r','r','r','r','r','r','r','b','r','r','r','r']);
 %}