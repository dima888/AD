%%%-------------------------------------------------------------------
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%%

%%% Ausführung
%%% Die Algorithmen sind 100-mal auszuführen, wenn möglich mit jeweils unterschiedlichen Zahlen:
%%% - 80-mal Zufallszahlen
%%% - 10-mal "best case"
%%% - 10-mal "worst case"
%%% Aus den Zeitmessungen sind anzugeben:

%%% 1.	Anzahl eingelesener Elemente
%%% 2.	Name des Algorithmus
%%% 3.	Benötigte Zeit(Mittelwert), sowie maximal und minimal benötigteZeit.
%%% 4.	Anzahl Vergleiche(Mittelwert), sowie maximale Anzahl und minimale Anzahl an Vergleichen.
%%% 5.	Anzahl Verschiebungen(Mittelwert), sowie maximale Anzahl und minimale Anzahl an Verschiebungen.

%%% ---------------------------------------------------------------------------------------------------------

%%% Was ich benoetige um diese Funktion zu implementieren
%%% Primaer:
%%% 1. Benoetige eine Liste mit allen Lauf-Zeiten!
%%% 2. Benoetige eine Liste mit allen Vergleichen!
%%% 3. Benoetige eine Liste mit allen Verschiebungen!

%%% Sekundaer:
%%% 4. Genau Eine Variable mit der Anzahl der eingelesener Werte!
%%% 5. Genau Variable mit dem Namen des auszufuehrenden Algorithmus
%%% 6. Genau zwei Variablen, einmal fuer Maximale und Minimale Vergleiche
%%% 7. Genau zwei Variablen, einmal fuer Maximale und Minimale Verschiebungen


%%% @end
%%% Created : 06. Nov 2014 15:12
%%%-------------------------------------------------------------------
-module(measurement).

%% API
-export([start/6]).

%% @param Atom Algorithmus - insertionSort oder selectionSort sind die moeglichen Eingaben
%% @param Integer RunNumber - Wie oft der Algorithmus ausgefuehrt werden soll
%% @param String FileMessung - Pfad zur Datei, wo die Messungen gespeichert werden sollen
%% @param String FileZahlen - Dateifpad zur Zahlen die man einlesen moechte um die zu verarbeiten
%% @param String FileSortiert - Dateifpad wohin die sortierten Zahlen abgespeichert werden sollen
%% @param List [Number, From, Till] - Number -> Wie viele Zufallszahlen generiert werden sollen
%%                                  - From -> Kleinste Zahl die generiert werden darf
%%                                  - Till -> Groesste Zahl die generiert werden darf
start(Algorithmus, RunNumber, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]) when Algorithmus == insertionSort ->
  Funktion = fun(Param1, Param2, Param3, Param4) -> insertionSort:insertionS(Param1, Param2, Param3, Param4) end,
  analysis(Algorithmus, RunNumber, FileMessung, length(utility:readFromFile(FileZahlen)), measurement(Funktion, RunNumber, [], [], [], 0, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]));

start(Algorithmus, RunNumber, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]) when Algorithmus == selectionSort ->
  Funktion = fun(Param1, Param2, Param3, Param4) -> selectionSort:selectionS(Param1, Param2, Param3, Param4) end,
  analysis(Algorithmus, RunNumber, FileMessung, length(utility:readFromFile(FileZahlen)), measurement(Funktion, RunNumber, [], [], [], 0, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]));

start(_Algorithmus, _RunNumber, _FileMessung, _FileZahlen, _FileSortiert, [_Number, _From, _Till]) ->
  algorithmusIstNichtImplementiert.



%=================================================================================================================================================
%                                                                  Hilfsfunktionen
%=================================================================================================================================================
measurement(_Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, _FileMessung, _FileZahlen, _FileSortiert, [_Number, _From, _Till]) when Counter >= RunNumber -> [RunTimeList, CompareList, ShiftList];
measurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]) when (Counter > 80) and (Counter < 90) ->
  io:nl(), io:fwrite("------- bestCase --------"), io:nl(),
  initialAndExecuteMeasurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till, bestCase]);

measurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]) when (Counter > 90) and (Counter < 100) ->
  io:nl(), io:fwrite("------- worstCase --------"), io:nl(),
  initialAndExecuteMeasurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till, worstCase]);

measurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]) ->
  io:nl(), io:fwrite("------- random --------"), io:nl(),
  initialAndExecuteMeasurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till, random]).

%% Initialisiert ein arrayS, generiert zufallszahlen,
%% befuhlt den array, sortiert den array und speichert das
%% sortierte array in eine datei FileSort.
initialAndExecuteMeasurement(Algorithmus, RunNumber, RunTimeList, CompareList, ShiftList, Counter, FileMessung, FileZahlen, FileSortiert, [Number, From, Till, Modus]) ->
  InitialArray = arrayS:initA(),
  sortNum:generateRandomNumbers(Number, From, Till, FileZahlen, Modus),
  List = utility:readFromFile(FileZahlen),
  ArrayS = utility:addListInArrayS(InitialArray, List, 0),
  [_SortArray, CompareCounter, ShiftCounter, RunTime] = Algorithmus(ArrayS, 0, arrayS:lengthA(ArrayS), FileSortiert),
  measurement(Algorithmus, RunNumber, RunTimeList ++ [RunTime], CompareList ++ [CompareCounter], ShiftList ++ [ShiftCounter], Counter + 1, FileMessung, FileZahlen, FileSortiert, [Number, From, Till]).


%% Diese Funktion ist fuer das auswerten der gesamten Daten zustaendig
analysis(Algorithmus, RunNumber, File, ElemsSize, [RunTimeList, CompareList, ShiftList]) ->
  [RunTimeList, CompareList, ShiftList],

  MinRunTime = lists:min(RunTimeList),
  MaxRunTime = lists:max(RunTimeList),

  MinCompare = lists:min(CompareList),
  MaxCompare = lists:max(CompareList),

  MinShift = lists:min(ShiftList),
  MaxShift = lists:max(ShiftList),

  showConsoleLog(RunTimeList, CompareList, ShiftList, MinRunTime, MaxRunTime, MinCompare, MaxCompare, MinShift, MaxShift),
  analysisHelper(Algorithmus, File, RunNumber, ElemsSize, RunTimeList, CompareList, ShiftList, MinRunTime, MaxRunTime, MinCompare, MaxCompare, MinShift, MaxShift).

%% Speichert die Ausgewerteten Werte in eine log Datei ab
analysisHelper(Algorithmus, File, RunNumber, ElemsSize, RunTimeList, CompareList, ShiftList, MinRunTime, MaxRunTime, MinCompare, MaxCompare, MinShift, MaxShift) ->
  utility:writeInNewFile(File, Algorithmus),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Ausfuehrungen: "),
  utility:writeInNewFileWithoutDelete(File, RunNumber),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Eingelesene Elemente: "),
  utility:writeInNewFileWithoutDelete(File, ElemsSize),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Mittelwert Rechenzeit in ms: "),
  utility:writeInNewFileWithoutDelete(File, utility:averageValue(RunTimeList)),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Mittelwert Vergleiche : "),
  utility:writeInNewFileWithoutDelete(File, utility:averageValue(CompareList)),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Mittelwert Verschiebungen : "),
  utility:writeInNewFileWithoutDelete(File, utility:averageValue(ShiftList)),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Minimale Laufzeit: "),
  utility:writeInNewFileWithoutDelete(File, MinRunTime),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Maximale Laufzeit: "),
  utility:writeInNewFileWithoutDelete(File, MaxRunTime),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Minimaler Vergleich: "),
  utility:writeInNewFileWithoutDelete(File, MinCompare),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Maximaler Vergleich: "),
  utility:writeInNewFileWithoutDelete(File, MaxCompare),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Minimale Verschiebung: "),
  utility:writeInNewFileWithoutDelete(File, MinShift),

  utility:writeInNewFileWithoutDeleteWithoutNL(File, "Maximale Verschiebung: "),
  utility:writeInNewFileWithoutDelete(File, MaxShift).

%% Zeigt die Analysierten Werte auf der Console mit an
showConsoleLog(RunTimeList, CompareList, ShiftList, MinRunTime, MaxRunTime, MinCompare, MaxCompare, MinShift, MaxShift) ->
  io:fwrite("--------------- RESULTAT DER ANALYSE ---------------"),
  io:nl(),
  io:fwrite("Mittelwert Rechenzeit => "), io:write(utility:averageValue(RunTimeList)), io:nl(),
  io:fwrite("Mittelwert Vergleiche => "), io:write(utility:averageValue(CompareList)), io:nl(),
  io:fwrite("Mittelwert Verschiebung => "), io:write(utility:averageValue(ShiftList)), io:nl(),
  io:nl(),
  io:fwrite("Minimale Laufzeit => "), io:write(MinRunTime), io:nl(),
  io:fwrite("Maximale Laufzeit=> "), io:write(MaxRunTime), io:nl(),
  io:nl(),
  io:fwrite("Minimaler Vergleich  => "), io:write(MinCompare), io:nl(),
  io:fwrite("Maximaler Vergleich => "), io:write(MaxCompare), io:nl(),
  io:nl(),
  io:fwrite("Minimale Verschiebung  => "), io:write(MinShift), io:nl(),
  io:fwrite("Maximale Verschiebung  => "), io:write(MaxShift), io:nl(),
  io:fwrite("--------------- RESULTAT DER ANALYSE ---------------").














