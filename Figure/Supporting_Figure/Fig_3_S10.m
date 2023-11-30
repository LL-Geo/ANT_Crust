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

hold on
plot(c,'k-.')
hold on
plot(c_25,'k-.')
hold on
plot(c_50,'k-.')
hold on
plot(c_75,'k-.')



% load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\OutPut_ST2_MeanSTD.mat')
load('C:\Users\22528618\Desktop\ST2_F\BuildModel\Foeward\read\ST2_output_F.mat')

Den_INV1=log10(reshape(Mean_Hete_den(:,:,6),334*334,1));
Den_INV2=log10(reshape(Mean_Hete_den(:,:,6)+STD_Hete_den(:,:,6),334*334,1));
Den_INV3=log10(reshape(Mean_Hete_den(:,:,6)-STD_Hete_den(:,:,6),334*334,1));

HPD_INV1c = c(Den_INV1);
HPD_INV1c=reshape(HPD_INV1c,334,334);
HPD_INV1c_U = c_75(Den_INV1);
HPD_INV1c_U=reshape(HPD_INV1c_U,334,334);
HPD_INV1c_D = c_25(Den_INV1);
HPD_INV1c_D=reshape(HPD_INV1c_D,334,334);


HPD_INV2c = c(Den_INV2);
HPD_INV2c=reshape(HPD_INV2c,334,334);
HPD_INV2c_U = c_75(Den_INV2);
HPD_INV2c_U=reshape(HPD_INV2c_U,334,334);
HPD_INV2c_D = c_25(Den_INV2);
HPD_INV2c_D=reshape(HPD_INV2c_D,334,334);


HPD_INV3c = c(Den_INV3);
HPD_INV3c=reshape(HPD_INV3c,334,334);
HPD_INV3c_U = c_75(Den_INV3);
HPD_INV3c_U=reshape(HPD_INV3c_U,334,334);
HPD_INV3c_D = c_25(Den_INV3);
HPD_INV3c_D=reshape(HPD_INV3c_D,334,334);

[mean(mean(10.^HPD_INV3c)),mean(mean(10.^HPD_INV2c)),mean(mean(10.^HPD_INV1c))]

[map2, descriptorname, description] = colorcet('L16');


la=-85:5:-50;
lon=0:1:360;
la2=-90:5:-50;
lon2=0:30:360;
[la,lon]=meshgrid(la,lon);
[lon2,la2]=meshgrid(lon2,la2);

[xt,yt]=ll2ps(la,lon);
[xt2,yt2]=ll2ps(la2,lon2);
grayColor = [.7 .7 .7];


f=figure()
u = f.Units;
f.Units = 'centimeters';


f.Position=[0 0 16 21];

edgx=0.03;
edgy=0.03;
n=3;
m=2;

% mask_A=A-A+1;

ax = subplot(3,2,1)
ax.Position = [edgx edgy+2/n 1/m-2*edgx 1/n-edgy]
A=(10.^(HPD_INV2c_U)-1).*MeanCrust_th/2000;
A(A==A(1,1))=nan;
mask_A=A-A+1;

ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','a)')


ax = subplot(3,2,2)
ax.Position = [1/m+edgx edgy+2/n 1/m-2*edgx 1/n-edgy]
A=(10.^(HPD_INV3c_U)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','b)')

ax = subplot(3,2,3)
ax.Position = [edgx edgy+1/n 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV2c)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','c)')

ax = subplot(3,2,4)
ax.Position = [1/m+edgx edgy+1/n 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV3c)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','d)')

ax = subplot(3,2,5)
ax.Position = [edgx edgy 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV2c_D)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','e)')

ax = subplot(3,2,6)
ax.Position = [1/m+edgx edgy 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV3c_D)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','f)')

print(gcf,"C3_SF10.png",'-dpng','-r300')



