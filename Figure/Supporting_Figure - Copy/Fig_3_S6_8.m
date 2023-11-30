load('C:\Users\22528618\Desktop\ST2_F\Result\result.mat')

load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\ST2_output.mat')


x=-3330000:20000:3330000;
y=-3330000:20000:3330000;
[X,Y]=meshgrid(x,y);

ax=ant_plot_4ss(x,y,1,STDSSB_th/1000,[0 1],'L17','km','b)',1,nan)




ax=ant_plot_4ss(x,y,1,STDMoho/1000,[0 4],'L17','km','b)',2,nan)




ant_plot_4ss(x,y,1,STDCrust_den,[0 0.03],'L17','g cm^{-3}','b)',3,nan)
ant_plot_4ss(x,y,1,STDBase,[0 0.01],'L17','g cm^{-3}','b)',4,nan)

print(gcf,"C3_SF6.png",'-dpng','-r300')


%%
load('C:\Users\22528618\Desktop\ST2_F\Result\result.mat')
load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\ST2_output.mat')

A=readtable('C:\Users\22528618\Desktop\ST2_F\Result\Initial_Seismic.csv');

Observe=table2array(A(:,8));
Uncertainty=table2array(A(:,6));



xx=table2array(A(:,1));
yy=table2array(A(:,2));


c_th = interp2(X,Y,-MeanMoho,xx,yy);



p1 = polyfit(Observe,c_th/-1000,2);
y1 = polyval(p1,Observe);



Rms1=sqrt(mean((Observe-c_th/1000).^2))


x=-3330000:20000:3330000;
y=-3330000:20000:3330000;

f=figure()
u = f.Units;
f.Units = 'centimeters';

% f.Position=[700 650 700 650];
% f.Position=[700/2 650/2 700/2 650/2];
f.Position=[0 0 16 7.5];

ax = subplot(1,2,1)
ax.Position = [0.05 0.075 0.45 0.920]
ant_plot_2ss(x,y,ax,(MeanSSB_th-MeanSSB_th)/1e3,[-10,10],'D01A','km','a)',1)
hold on
scatter(xx,yy,50,c_th/1000-Observe,'filled','MarkerEdgeColor', 'k')
caxis([-10 10])
draw_coastline



ax = subplot(1,2,2)
ax.Position = [0.53 0.075 0.45 0.920]

plot(Observe,c_th/1000,'.');
hold on
plot(Observe,y1);
hold on
plot([0 60],[0 60])
axis equal
xlim([0 62])
ylim([0 62])
xlabel('Observe(km)','Position',[30,5]);
ylabel('Model(km)','Position',[5,30]);

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07,0.07/2,0.07-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','b)','FitBoxToText','off');
print(gcf,"C3_SF7.png",'-dpng','-r300')

%%
load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\ST2_output.mat')

Sedi_ALL=load('C:\Users\22528618\Desktop\ST2_F\BuildModel\new_likelihood_th.txt');

Kmoho=loadAsciiM('C:\Users\22528618\Desktop\ST2_F\BuildModel\kri_s_i_h.txt');

f=figure()
u = f.Units;
f.Units = 'centimeters';

% f.Position=[700 650 700 650];
% f.Position=[700/2 650/2 700/2 650/2];
f.Position=[0 0 16 7.5];

ax = subplot(1,2,1)
ax.Position = [0.05 0.075 0.45 0.920]
ant_plot_2ss(x,y,ax,(MeanSSB_th-flipud(Sedi_ALL))/1e3,[-1.5,1.5],'D01A','km','a)',1)


ax = subplot(1,2,2)
ax.Position = [0.50 0.075 0.45 0.920]

ant_plot_2ss(x,y,ax,-MeanMoho/1e3-flipud(Kmoho),[-10,10],'D01A','km','b)',2)
print(gcf,"C3_SF8.png",'-dpng','-r300')



