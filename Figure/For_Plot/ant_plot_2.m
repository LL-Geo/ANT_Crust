function ant_plot_2(x,y,ax,A,ca,colorset,colabel,seri,axble)



la=-85:5:-50;
lon=0:1:360;
la2=-90:5:-50;
lon2=0:30:360;
[la,lon]=meshgrid(la,lon);
[lon2,la2]=meshgrid(lon2,la2);

[xt,yt]=ll2ps(la,lon);
[xt2,yt2]=ll2ps(la2,lon2);
grayColor = [.7 .7 .7];



h=imagesc(x,y,(A))
caxis([ca(1),ca(2)])

set(gca,'YDir','normal')
set(h, 'AlphaData', 1-isnan((A)))
hold on
plot(xt,yt,'Color',  grayColor);
hold on
plot(xt2,yt2,'Color', grayColor);

draw_coastline
axis equal

% 
xlim([-3330000 3330000]) 
ylim([-3330000 3330000]) 

if axble==1
    xticks([-2000000  0  2000000])
    xticklabels({'150^{\circ}W','180','150^{\circ}E'})
    yticks([-2000000  0  2000000])
    yticklabels({'120^{\circ}W','90^{\circ}W','60^{\circ}W'})
    ytickangle(90)
    ax.XRuler.TickLabelGapOffset = -2;  % default = +2
    set(gca,'TickLength',[0 0])
    
elseif axble==2
    
    xticks([-2000000  0  2000000])
    xticklabels({'150^{\circ}W','180','150^{\circ}E'})
    yticks([-2000000  0  2000000])
    yticklabels({'120^{\circ}E','90^{\circ}E','60^{\circ}E'})
    set(gca,'YAxisLocation','right')
    ytickangle(270)
    ax.XRuler.TickLabelGapOffset = -2;  % default = +2
    set(gca,'TickLength',[0 0])
    
end

ss=50000;
hold on
plot([2500000 3000000],[3000000.9-ss 3000000.9-ss],'k-','linewidth',1.8); 
hold on
plot([2000000 2500000],[2950000.9-ss 2950000.9-ss],'k-','linewidth',1.8); 
hold on
plot([2000000 3000000],[2920000.9-ss 2920000.9-ss],'k-','linewidth',0.2); 
hold on
plot([2000000 3000000],[3025000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 
hold on
plot([2000000 2000000],[2920000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 
hold on
plot([3000000 3000000],[2920000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 


text(2500000,3350000,'1000 km','horiz','center','vert','top'); 

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07,0.07/2,0.07-0.001];
a=colorbar('west','Position',...
    [pos2(1)+0.03 pos2(2)+0.02 0.01 0.383989501312336/1],...
    'AxisLocation','in');
if isnan(colorset)
else
    [map, descriptorname, description] = colorcet(colorset);
    colormap(ax,map);
end

a.Label.String = colabel;
a.Label.Position(1) = -3;
a.TickLength = .05;
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String',seri,'FitBoxToText','off');

