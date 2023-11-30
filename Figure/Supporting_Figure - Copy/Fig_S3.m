Misfit=read_misfit('../../Initial_model/Initial_model.FW');
Misfit=reshape(Misfit,315,315);
f=figure()
u = f.Units;
f.Units = 'centimeters';
f.Position=[0 0 8 7];
edgx=0.03;
edgy=0.03;
ax=subplot(1,1,1)
ax.Position = [edgx edgy 1-2*edgx 1-2*edgy]
ant_plotss_Single(ax,(Misfit'),[-250,250],'D01A','mGal','')

print(gcf,"Fig_S3.png",'-dpng','-r300')
