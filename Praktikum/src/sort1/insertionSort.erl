%%%-------------------------------------------------------------------
%%% @author Team: 4
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% Quelle: http://de.wikipedia.org/wiki/Insertionsort
%%%
%%% Psydocode:
%%% A = Unsortierte Liste
%%% INSERTIONSORT(A)
%%% 1. for i ← 2 to Länge(A) do
%%% 2.      einzusortierender_wert ← A[i]
%%% 3.      j ← i
%%% 4.      while j > 1 and A[j-1] > einzusortierender_wert do
%%% 5.           A[j] ← A[j - 1]
%%% 6.           j ← j − 1
%%% 7.      A[j] ← einzusortierender_wert
%%%
%%% @end
%%% Created : 28. Okt 2014 11:38
%%%-------------------------------------------------------------------

-module(insertionSort).

%% API
-export([insertionS/4]).


%% Diese Funtion sortiert ein ArrayS/ADT und speichert die sortierten Daten in Listenformat in eine Datei
%% @param Array Array - Der zur sortierende Array
%% @param Integer Von - Kleinster Index Wert vom Array
%% @param Integer Bis - Groesster Index Wert vom Array
%% @param String File - Pfad zur einer Datei, wo das sortierte Ergebnis gespeichert wird
%% @result [Sortierter Array/ArrayS, Vergleiche/Integer, Verschiebungen/Integer, LaufZeit in Millisekunden/Integer ]
insertionS(Array, Von, Bis, ResultFile) ->

  %% Sortieren und die Zeit messen
  StartTime = utility:getTimestampInMilliSeconds(),
  SortArray = sort(Array, Von, Bis),
  EndTime = utility:getTimestampInMilliSeconds(),
  RunTime = EndTime - StartTime,

  io:nl(), io:fwrite("Sortierdauer in ms: "), io:write(RunTime), io:nl(),

  %% Zugriffe zaehlen
  [CompareCounter, ShiftCounter] = sortAndCount(Array, Von, Bis),
  io:fwrite("Anzahl Vergleiche: "), io:write(CompareCounter), io:nl(),
  io:fwrite("Anzahl Verschiebungen: "), io:write(ShiftCounter), io:nl(),

  %% Sortierten Array in sortiert.dat abspeichern in Form einer Liste.
  List = utility:arrayStoList(SortArray),
  utility:writeInNewFile(ResultFile, List),

  [SortArray, CompareCounter, ShiftCounter, RunTime].


%=================================================================================================================================================
%                                                     Sortieralgorithmen: Sortieren & Zaehlen Einstiegspunkte
%=================================================================================================================================================
%% Das ist der SortierAlgorithmus laut Psydocode
sort(Array, Von, Bis) ->
  [NewVon, NewBis] = borderCheck(Array, Von, Bis),
  psydoCodeFor(Array, NewVon, NewBis).

%% Das ist der Sortieralgorithmus, der noch die verschiebungen mit zaehlt
sortAndCount(Array, Von, Bis) ->
  [NewVon, NewBis] = borderCheck(Array, Von, Bis),
  psydoCodeForWithCounter(Array, NewVon, NewBis).


%=================================================================================================================================================
%                                                 Sortieralogorithmus Komponenten ohne verlangsamung
%=================================================================================================================================================
% Aussere Schleife des Alogorithmus
%psydoCodeFor(Array, I, Bis) when I == Bis -> Array;
psydoCodeFor(Array, I, Bis) when I >= Bis -> Array;
psydoCodeFor(Array, I, Bis) ->
  Einzusortierender_wert = arrayS:getA(Array, I),
  J = I,

  [ModifyArray, ModifyJ] = psydoCodeWhile(Array, I, J, Einzusortierender_wert, arrayS:getA(Array, J - 1)),

  ModifyArray2 = arrayS:setA(ModifyArray, ModifyJ, Einzusortierender_wert),

  psydoCodeFor(ModifyArray2, I + 1, Bis).

% Innere Schleife des Algorithmus: Hier muss J > 1 auf J > 0 geaendert werden, da im Psydocode der Index bei 1 beginnt und bei uns bei 0
psydoCodeWhile(Array, _I, J, Einzusortierender_wert, JminusEins) when (not( (J > 0) and (JminusEins > Einzusortierender_wert) ) ) -> [Array, J];
psydoCodeWhile(Array, I, J, Einzusortierender_wert, JminusEins) ->
  ModifyArray = arrayS:setA(Array, J, JminusEins),
  ModifyJ = J - 1,
  psydoCodeWhile(ModifyArray, I, ModifyJ, Einzusortierender_wert, arrayS:getA(ModifyArray, ModifyJ - 1)).


%=================================================================================================================================================
%                                         Sortieralogorithmus Komponenten mit einem Zaehler fuer die Verschiebungen
%=================================================================================================================================================
% Aussere Schleife des Alogorithmus
psydoCodeForWithCounter(Array, I, Bis) ->
  psydoCodeForWithCounter(Array, I, Bis, 0, 0).
psydoCodeForWithCounter(_Array, I, Bis, CompareCounter, ShiftCounter) when I >= Bis -> [CompareCounter, ShiftCounter];
psydoCodeForWithCounter(Array, I, Bis, CompareCounter, ShiftCounter) ->
  Einzusortierender_wert = arrayS:getA(Array, I),
  J = I,

  % Zwei Vergleiche hoch Zaehlen
  [ModifyArray, ModifyJ, ModifyCompareCounter, ModifyShiftCounter] = psydoCodeWhileWithCounter(Array, I, J, Einzusortierender_wert, arrayS:getA(Array, J - 1), CompareCounter + 2, ShiftCounter),

  ModifyArray2 = arrayS:setA(ModifyArray, ModifyJ, Einzusortierender_wert),

  psydoCodeForWithCounter(ModifyArray2, I + 1, Bis, ModifyCompareCounter, ModifyShiftCounter).

% Innere Schleife des Algorithmus: Hier muss J > 1 auf J > 0 geaendert werden, da im Psydocode der Index bei 1 beginnt und bei uns bei 0
psydoCodeWhileWithCounter(Array, _I, J, Einzusortierender_wert, JminusEins, CompareCounter, ShiftCounter) when (not( (J > 0) and (JminusEins > Einzusortierender_wert) ) ) -> [Array, J, CompareCounter, ShiftCounter];
psydoCodeWhileWithCounter(Array, I, J, Einzusortierender_wert, JminusEins, CompareCounter, ShiftCounter) ->
  ModifyArray = arrayS:setA(Array, J, JminusEins),
  ModifyJ = J - 1,
  % Verschiebung sowie Vergleiche hochzaehlen
  psydoCodeWhileWithCounter(ModifyArray, I, ModifyJ, Einzusortierender_wert, arrayS:getA(ModifyArray, ModifyJ - 1), CompareCounter + 2, ShiftCounter + 1).


%=================================================================================================================================================
%                                                                    Hilfsfunktionen
%=================================================================================================================================================
borderCheck(Array, Von, Bis) ->
  AryLength = arrayS:lengthA(Array),

  if (Von < 0) ->
    ResultVon = 0,
    borderCheck(Array, ResultVon, Bis);
    true ->
      if (AryLength < Bis) ->
        [Von + 1, AryLength];
        true ->
          [Von + 1, Bis]
      end
  end.