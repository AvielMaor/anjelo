close all; clear all ; clc
pause(2)
%%
device = serialport("COM1",115200);
%%
flush (device)
DGIMA       = read(device,11520,"string");
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
%clear C DGIMA n netDgima
%%
Ts=1/2000   % aduc or time/length(longDgima)
numofsamples=Ts*length(longDgima)
T=0:Ts :numofsamples

%clear sample_freq numofsamples
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
hold on

time_of_wave=T(1:length(UD));
max_locations=islocalmax(UD);
min_locations=islocalmin(UD);

sum_of_max=sum(max_locations);
Freq_of_singal=sum_of_max/time_of_wave(end)

plot(T(1:length(UD)),max_locations*mean(UD),"x");
ylim([min(UD) max(UD)]);
hold on
%%
max_values=UD(max_locations);
min_values=UD(min_locations);
maxim=mean(max_values);
minim=min(min_values);
amplitude_of_signal=max(UD)-min(UD)

%clear device
%%
Y=fft(UD);
Fs=2000;
f = (0:length(UD)-1)*Fs/length(UD)
figure 
plot(f,abs(Y))
