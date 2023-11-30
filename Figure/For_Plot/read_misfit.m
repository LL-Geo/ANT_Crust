
% function [X,Y,L1,L2,L3,L4,L5,L6,L7,L8,misfit]=readmodel(filename)
% function [X,Y,Bbase,Bh,BSSB,BMoho,F_den_SSB,F_den_crust,x,y,misfit]=readmodel(filename)

function misfit=read_misfit(filename)



fid = fopen(filename,'rt');
file = textscan(fid,'%s','Delimiter','\n\');
file = file{1};
fclose(fid);

%Find Hete layer
%Number of Hete Layer
Hline=file(5,1);
Hline=str2num(char(Hline));

if length(Hline)>2
NH=Hline(2); %Total number of Hete layers
HLayer=Hline(3:2:end-1);  %Hete layers
else
    NH=0;
end

HIdex=4;


% find Data Range
Index = find(contains(file,'Beneath'));
As=max(Index)+2;
Al=length(Index)*2+1;
Index = find(contains(file,'Base'));
Ae=Index-2;
Ra=[As 0 Ae Al];
Cs=Ae+2;
Index = find(contains(file,'Heterogn'));
Ce=Index-2;
Ds=Index;
Index = find(contains(file,'EAST'));
De=Index-2;
if isempty(Ce)
    Cend=De;
else
    Cend=min(min(Ce),De);
end
Rc=[Cs 0 Cend 3];

Rd=[max(Ds) 0 De 8];
Bs=De+2;

if isempty(Bs)
    Dsnew=[Ds;length(file)+1];
else
    Dsnew=[Ds;Bs];
end

Index = find(contains(file,'DC_SHIFT'));
Be=Index-2;
Rb=[Bs 0 Be 5];

clear file;

% if length(Ra)==4
%     Alayer=dlmread(filename,'',[As 3 Ae 3]);
%     LayerMax=max(Alayer);
%     LayerMin=min(Alayer);
% 
%     Ra=[As 0 Ae LayerMax*2+1];
%     A=dlmread(filename,'',Ra);
%     m=sqrt(length(A));
%     n=m;
%     X=reshape(A(:,1),m,n);
%     Y=reshape(A(:,2),m,n);
%     if LayerMax>LayerMin
%     %Combine henter
%     Hindex=find(Alayer==LayerMax);
%     Out=A;
%     Out(Hindex,:)=[A(Hindex,1:HIdex*2+2),A(Hindex,HIdex*2+5:end),A(Hindex,1),A(Hindex,1)];
%     Out=Out(:,1:end-2);
%     else 
%     Out=A;
%     end
% % Surface
% % L1=reshape(A(:,3),m,n); %Ice
% % L2=reshape(A(:,5),m,n); %Water
% % L3=reshape(A(:,7),m,n); %Sea
% L4=reshape(Out(:,9),m,n); %Offshore_sedi
% L5=reshape(Out(:,11),m,n); %Onshore_sedi
% L6=reshape(Out(:,13),m,n); %Upper_crust
% L7=reshape(A(:,15),m,n); %Lower_crust
% L8=reshape(A(:,17),m,n); %Lower_crust
% L9=reshape(A(:,19),m,n); %Lower_crust
% 
% % BSSB=L5-L6;
% BSSB=L4-L9;
% 
% BMoho=reshape(Out(:,end-1),m,n); %Moho
% % L9=reshape(A(:,19),m,n); %Moho
% else
%     BMoho=nan;
%     BSSB=nan;
% end


if length(Rb)==4
%data 
B=dlmread(filename,'',Rb);
x=B(:,1);
y=B(:,2);
misfit=B(:,4)-B(:,5);
else
    x=nan;
    y=nan;
    misfit=nan;
end


end


