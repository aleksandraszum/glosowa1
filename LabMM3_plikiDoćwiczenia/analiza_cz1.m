%% Analiza sygna³u mowy, cz1
% - utworzony: 18.10.2017, R2017b, J.Przyby³o, AGH
%
clear all;close all;clc


%% (1) Wczytanie pliku audio
% - plik audio w formacie WAV nale¿y przygotowaæ wczeœniej wycinaj¹c
%   z nagrania fragment odpowiadaj¹cy okreœlonej samog³osce
%   Powinien on mieæ d³ugoœæ oko³o 1sec
filename = 'audioFiles\a_1_jp.wav';                % nazwa pliku audio

[S0,Fs]=audioread(filename);
if size(S0,2)>1
    S1=S0(1:min([Fs size(S0,1)]),1); % wybierz max. 1 sec audio (mono)
else
    S1=S0(1:min([Fs size(S0,1)]));   % wybierz max. 1 sec audio 
end
if length(S1)<Fs
    warning(['Sygna³ audio poni¿ej 1 sec (' num2str(1000*(length(S1)/Fs)) ' [ms])'])
end

%% (2) Wizualizacja wczytanego sygna³u
% plot waveform
t1=(0:length(S1)-1)/Fs;        % times of sampling instants
%subplot(3,1,1)
plot(t1,S1);
title(filename,'Interpreter','none');
xlabel('Czas (s)');
ylabel('Amplituda');

%% (3) Preprocessing sygna³u
% - okno czasowe Hamminga
% - filtr preemfazy
S2 = S1.*hamming(length(S1));
preemph = [1 0.63];
S3 = filter(1,preemph,S2);

%% (4) Wizualizacja kolejnych etapów preprocessingu
hold on
plot(t1,S2);
plot(t1,S3);
hold off
legend('Sygna³','Po oknie Hamminga','Po preemfazie');

%% (5) Wizualizacja sygna³u po preprocessingu (bez osi czasu)
% Korzystaj¹c z narzêdzia powiêkszenia (po wczeœniejszym zaznaczeniu opcji 
% Tools > Options > Horizontal Zoom) oraz Data Cursor, okreœl najbardziej 
% widoczn¹ powtarzaj¹c¹ siê sekwencjê sygna³u i wyznacz jej okres T.  
figure;
plot(S3);
xlabel('Próbki');
ylabel('Amplituda');
%{
t1 = ;
t2 = ;
T =  Fs/(t2-t1)   % [Hz]
%}

%% (6) Obliczenie i wizualizacja widma sygna³u
% Zapoznaj siê z funkcj¹ FFT (doc fft)
Y3 = fft(S3);
P3a = abs(Y3/length(S3));
P3 = P3a(1:length(S3)/2+1);
P3(2:end-1) = 2*P3(2:end-1);

f = Fs*(0:(length(S1)/2))/length(S1);
figure;
plot(f,P3) 
title('Widmo sygna³u')
xlabel('f (Hz)')
ylabel('|P3(f)|')

%% (7) Estymacja formantów LPC
% Zapoznaj siê z funkcj¹ w pliku "estimate_formants.m"
formants = estimate_formants(S3, Fs); % 23.11.2018 poprawka b³êdu (P3 na S3)
% wybór 3 pierwszych formantów
sprintf('%5.2fHz, %5.2fHz,  %5.2fHz', formants(1:3))






