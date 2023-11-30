
FF(:,8:8:end)=nan;

f=figure()
u = f.Units;
f.Units = 'centimeters';

% f.Position=[700 650 700 650];
% f.Position=[700/2 650/2 700/2 650/2];
f.Position=[0 0 12 12];
plot((0:12)'*ones(1,40),FF,'--','Color', [13 13 13]/255,'DisplayName','FF')
hold on
plot((0:12)'*ones(1,40),FF.*(ones(13,1)*index2),'k','LineWidth',0.5)
xlabel('Interation')
ylabel('Misfit (mGal)')
xlim([0 12]);
dx=0.12
dy=-0.03
xstart=.70-dx
xend=1.00-dx
ystart=.55-dy
yend=.85-dy
axes('position',[xstart ystart (xend-xstart) yend-ystart ])
% plot(abs(den_all),(abs(geometry_all)+abs(SSB_all)),'.');
% hold on
plot(abs(den_all).*index2,(abs(geometry_all)+abs(SSB_all)).*index2,'*');
hold on
plot([0,30],[0,30])
% hold on
% plot([0,30*0.75],[0,30])
% hold on
% plot([0,30],[0,30*0.75])
xlim([0 30]);
ylim([0 30]);
axis equal

xlabel({'density change'; 'mGal'})
ylabel({'geometry change'; 'mGal'})

print(gcf,"C3_SP5.png",'-dpng','-r300')
