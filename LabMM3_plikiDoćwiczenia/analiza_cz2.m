%% Analiza sygna³u mowy, cz2
% - utworzony: 18.10.2017, R2017b, J.Przyby³o, AGH
%
clear all;close all;clc

%% (1) Przetwarzanie wsadowe plików - obiekt datastore
% Zapoznaj siê z dokumentacj¹ obiektu "fileDatastore"
folderName = 'audioFiles';  % podkatalog z plikami audio

fds = fileDatastore(folderName,'ReadFcn',@load_audio,'FileExtensions','.wav');
N = 3; % liczba formantów brana pod uwagê
formants=zeros(length(fds.Files),N);
vowelClass=cell(length(fds.Files),1);
sampleName=cell(length(fds.Files),1);
i = 1;
while hasdata(fds)
    audioD = read(fds);
    tmp = estimate_formants(audioD.s, audioD.Fs);
    formants(i,:) = tmp(1:N);
    vowelClass{i}=audioD.vowelName;
    [~,sampleName{i},~]=fileparts(fds.Files{i});
    i = i + 1;
end
formantsTable = table(vowelClass, formants(:,1),formants(:,2),formants(:,3),...
            'VariableNames',{'Class','F1','F2','F3'},'RowNames',sampleName);
disp(formantsTable)     
    

%% (2) Wizualizacja danych
uWovels = unique(vowelClass);           % unikalne nazwy samog³osek
nrOfVowels = length(uWovels);           % liczba samog³osek
colors1='rgbcmky';
figure;
hold on
for i=1:nrOfVowels
    select1 = strcmp(vowelClass,uWovels(i));            % wybór elementów (okreœlona samog³oska), wektor logiczny
    % TODO wizualizacja elementów z danej grupy oraz œredniej (help plot3)


end
hold off
legend(uWovels)
grid on
view(45, 45);
xlabel('f1')
ylabel('f2')
zlabel('f3')




