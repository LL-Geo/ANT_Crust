clc
clear
A=importdata('global_heat_production.txt');
% A=importdata('g_hp_d_inv.txt');

Density=log10(A.data(:,3)/1000);
Heat_Production=log10(A.data(:,4));

thers=10;

Density(Heat_Production>thers)=nan;
Heat_Production(Heat_Production>thers)=nan;
Density(isnan(Density))=[];
Heat_Production(isnan(Heat_Production))=[];

f=figure()
u = f.Units;
f.Units = 'centimeters';


f.Position=[0 0 16 22];


h=histogram2(Density,Heat_Production,[50,100],'FaceColor','flat','DisplayStyle','tile');
S=h.Values;





Scont=zeros(50,100);



for i=1:100
Scont(:,i)=sum(S(:,1:i),2);
end

SS=sum(S,2);
SS=repmat(SS,1,100);

Q_25=SS*0.25;
Q_75=SS*0.75;
Q_50=SS*0.50;

[Q_25a,Q_25b]=min(abs(Scont-Q_25),[],2);
[Q_75a,Q_75b]=min(abs(Scont-Q_75),[],2);
[Q_50a,Q_50b]=min(abs(Scont-Q_50),[],2);

HPD25=(h.YBinEdges(Q_25b)+h.YBinEdges(Q_25b+1))/2;
HPD75=(h.YBinEdges(Q_75b)+h.YBinEdges(Q_75b+1))/2;
HPD50=(h.YBinEdges(Q_50b)+h.YBinEdges(Q_50b+1))/2;

[maxcount, whichbin]=max(S,[],2);
HPD=(h.YBinEdges(whichbin)+h.YBinEdges(whichbin+1))/2;
Den=h.XBinEdges(1:end-1);
Den=Den+(Den(2)-Den(1))/2;



hold on
hLine=plot(Den,HPD25,'kv','LineWidth',0.1,'MarkerSize',3,'DisplayName','25^{th}')
hold on
hLine2=plot(Den,HPD75,'k^','LineWidth',0.1,'MarkerSize',3,'DisplayName','75^{th}')
hold on
hLine3=plot(Den,HPD50,'kx','LineWidth',0.1,'MarkerSize',3,'DisplayName','Median')
hold on
hLine4=plot(Den,HPD,'ko','LineWidth',0.1,'MarkerSize',3,'DisplayName','Popular')



% Den(Den<0.978)=nan;
Den(Den<0.4232)=nan;

Den(Den>0.4698)=nan;

Den_check=exp(Den);
Den_fit=Den;
Den_fit(isnan(Den))=[];

HPD_fit=HPD;
HPD_fit(isnan(Den))=[];
HPD_25_fit=HPD25;
HPD_25_fit(isnan(Den))=[];
HPD_50_fit=HPD50;
HPD_50_fit(isnan(Den))=[];
HPD_75_fit=HPD75;
HPD_75_fit(isnan(Den))=[];

c = fit(Den_fit',HPD_fit','poly1');
c_25 = fit(Den_fit',HPD_25_fit','poly1');
c_50 = fit(Den_fit',HPD_50_fit','poly1');
c_75 = fit(Den_fit',HPD_75_fit','poly1');



% load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\OutPut_ST2_MeanSTD.mat')
load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\ST2_output.mat')

Den_INV1=log10(reshape(Mean_Hete_den(:,:,6),334*334,1));

HPD_INV1c = c(Den_INV1);
HPD_INV1c=reshape(HPD_INV1c,334,334);




A=importdata('C:\Users\22528618\Desktop\ST2_F\heat_production\PetroChron_Antarctica_rock_prop_0_1.csv');
HP_petro=(A.data(:,3));
HP_petro_cor=(A.data(:,1:2));

[x,y]=ll2ps(HP_petro_cor(:,1),HP_petro_cor(:,2));

XX=-3330000:20000:3330000;
YY=-3330000:20000:3330000;
[XX,YY]=meshgrid(XX,YY);
hp_inv_interp=interp2(XX,YY,10.^(HPD_INV1c),x,y);

mis_hp=hp_inv_interp-HP_petro;
mean(mis_hp,'omitnan')
std(mis_hp,'omitnan')



HP_petrom=HP_petro-HP_petro+1;
HP_petrom(HP_petro>3)=nan;
% HP_petrom(HP_petro<1)=nan;

mis_hp_m=hp_inv_interp-HP_petrom.*HP_petro;



f=figure()
u = f.Units;
f.Units = 'centimeters';

% f.Position=[700 650 700 650];
% f.Position=[700/2 650/2 700/2 650/2];
f.Position=[0 0 17 7.5];

ax = subplot(1,2,1)
ax.Position = [0.05 0.08 0.45 0.915]
nhist(mis_hp)
ax.XLabel.String = {'misfit';'µW m^{-3}'};
ax.XLabel.Position(1) = -5;
ax.XLabel.Position(2) = 200;
ax.YLabel.Position(1) = -10;
 
pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07,0.07/2,0.07-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','a)','FitBoxToText','off');

ax = subplot(1,2,2)
ax.Position = [0.55 0.08 0.45 0.915]

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07,0.07/2,0.07-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','b)','FitBoxToText','off');
nhist(mis_hp_m)

ax.YLabel.Position(1) = -1.8;
print(gcf,"C3_SF9.png",'-dpng','-r300')
