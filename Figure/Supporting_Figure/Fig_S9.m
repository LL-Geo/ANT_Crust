clear
load('../../Crust_Model/Ant_Crust.mat')


edgx=0.05;
edgy=0.05;
f=figure()
u = f.Units;
f.Units = 'centimeters';

f.Position=[0 0 12 8];
subplot(1,2,1)
ax.Position = [edgx edgy+0.5 0.5-edgx 0.5-edgx]
plot(MeanCrust_den*1e3,MeanCrust_th/1e3,'k.')
xlabel('density(kg m^{-3})')
ylabel('crust thickness(km)')

subplot(1,2,2)
ax.Position = [0.5 edgy+0.5 0.5-edgx 0.5-edgx]
binscatter(reshape(MeanCrust_den*1e3,334*334,1),reshape(MeanCrust_th/1e3,334*334,1))
caxis([0,1000])
xlabel('density(kg m^{-3})')
ylabel('crust thickness(km)')
print(gcf,"Fig_S9.png",'-dpng','-r300')
