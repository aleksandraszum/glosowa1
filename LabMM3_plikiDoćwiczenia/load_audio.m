function data = load_audio(filename)
    % Funkcja wczytuj¹ca i wstêpnie przetwarzaj¹ca dane dla obiektu
    % datastore
    % Uwagi: identyfikator zbioru danych zak³ada nastêpuj¹c¹ strukturê
    % nazwy plików: <nazwasamog³oski>_<nr>_<kodOsoby>.wav np. 'o_1_mjk.wav'
    % 
    % Utworzenie: 18.10.2017, R2017b, J.Przyby³o, AGH
    
    % Wczytanie pliku
    [S0,Fs]=audioread(filename);
    if size(S0,2)>1
        S1=S0(1:min([Fs size(S0,1)]),1); % wybierz max. 1 sec audio (mono)
    else
        S1=S0(1:min([Fs size(S0,1)]));   % wybierz max. 1 sec audio 
    end
    if length(S1)<Fs
        warning([filename ' : sygna³ audio poni¿ej 1 sec (' num2str(1000*(length(S1)/Fs)) ' [ms])'])
    end
    
    % Preprocessing sygna³u
	% - okno czasowe Hamminga
    % - filtr preemfazy
    S2 = S1.*hamming(length(S1));
    preemph = [1 0.63];
    S3 = filter(1,preemph,S2);
    
    % Nazwa zbioru danych
    [~,fname1,~]=fileparts(filename);
    vowelName = fname1(1);
    personId = fname1(5:end);
    
    % Dane wyjœciowe (struktura)
    data.s = S3;
    data.Fs = Fs;
    data.vowelName = vowelName;
    data.personId = personId;
end