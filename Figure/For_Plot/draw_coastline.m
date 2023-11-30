function draw_coastline
load('coastline.mat');
N=592;
hold on
for i = 1:N
  x = S(i).X ;
  y = S(i).Y ;
  patch(x,y,rand(1,3))
end