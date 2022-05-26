close all;clear all ; clc
device = serialport("COM1",115200);
%%
flush (device)
DGIMA       = read(device,1000,"string");
%%
C           = strsplit(DGIMA);
netDgima    = regexprep(C,'[^0-9,A-G]','');
netDgima = netDgima(~cellfun(@isempty, netDgima));

%%
longDgima = netDgima;
longDgima = longDgima(~cellfun(@isempty, longDgima));
n=1;
while n < length(longDgima);
    if strlength(longDgima(n))~=3 && longDgima(n)~="G" ;
       longDgima(n)="";
    end
    n=n+1;
end
longDgima = longDgima(~cellfun(@isempty, longDgima));
G_location = find(longDgima == 'G');
G_location = G_location(1:2:end)
G_location = G_location(1:2:end)
clear C DGIMA n netDgima
%%
Ts=1/2000   % aduc or time/length(longDgima)
numofsamples=Ts*length(longDgima)
T=0:Ts :numofsamples

clear sample_freq numofsamples
%%
longDgima_withoutG    = regexprep(longDgima,'[^0-9,A-F]','');
D=hex2dec(longDgima_withoutG);
D=(D./4096);
D=D.*360;
R=deg2rad(D);
UR = unwrap(R);
UD=rad2deg(UR)
D=rad2deg(R)
plot(T(1:length(UD)),UD)

%%
time_of_wave=T(1:length(UD));
TF=islocalmax(UD);
sum_of_max=sum(TF);
Freq_of_singal=TF/time_of_wave
%%
maxim=max(UD);
minim=min(UD);
power_of_signal=maxim/minim

clear device
