
function [A]=loadAsciiM(filename)
fid=fopen(filename,'r');
col=fscanf(fid,'%c ',5); cols=fscanf(fid,'%i ',1); % read column
row=fscanf(fid,'%c ',5); rows=fscanf(fid,'%i ',1); % read column,row
xcorner=fscanf(fid,'%c ',9); xmin=fscanf(fid,'%i ',1); % read column
ycorner=fscanf(fid,'%c ',9); ymin=fscanf(fid,'%i ',1); % read column,row
cellsize=fscanf(fid,'%c ',8); d=fscanf(fid,'%i ',1); % read cell size
nodata=fscanf(fid,'%c ',13); nodata=fscanf(fid,'%f ',1); %nodata
fclose(fid);

A=dlmread(filename,'',6,0);
