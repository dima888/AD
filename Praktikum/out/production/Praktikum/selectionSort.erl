%%%-------------------------------------------------------------------
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% Pseudocode:
%%% prozedur SelectionSort( A : Liste sortierbarer Elemente )
%%%   n = Länge( A )
%%%   links = 0
%%%   wiederhole
%%%     min = links
%%%     für jedes i von links + 1 bis n wiederhole
%%%       falls A[ i ] < A[ min ] dann
%%%         min = i
%%%       ende falls
%%%     ende für
%%%     Vertausche A[ min ] und A[ links ]
%%%     links = links + 1
%%%   solange links < n
%%% prozedur ende

%%%
%%% @end
%%% Created : 28. Okt 2014 11:40
%%%-------------------------------------------------------------------
-module(selectionSort).

%% API
-export([selectionS/4]).

%% Diese Funtion sortiert ein ArrayS/ADT und speichert die sortierten Daten in Listenformat in eine Datei
%% @param Array Array - Der zur sortierende Array
%% @param Integer Von - Kleinster Index Wert vom Array
%% @param Integer Bis - Groesster Index Wert vom Array
%% @param String File - Pfad zur einer Datei, wo das sortierte Ergebnis gespeichert wird
%% @result [Sortierter Array/ArrayS, Vergleiche/Integer, Verschiebungen/Integer, LaufZeit in Millisekunden/Integer ]
selectionS(Array, Von, Bis, File) ->

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
  utility:writeInNewFile(File, List),

  [SortArray, CompareCounter, ShiftCounter, RunTime].

%=================================================================================================================================================
%                                                     Sortieralgorithmen: Sortieren & Zaehlen Einstiegspunkte
%=================================================================================================================================================

sort(Array, Von, Bis) ->
  I = Von,
  N = Bis,
  Links = Von,
  psydoCodeWiederholle(Array, I, N, Links).

sortAndCount(Array, Von, Bis) ->
  I = Von,
  N = Bis,
  Links = Von,
  psydoCodeWiederholleWithCounter(Array, I, N, Links, 0, 0).

%=================================================================================================================================================
%                                                 Sortieralogorithmus Komponenten ohne verlangsamung
%=================================================================================================================================================
%%%   wiederhole
%%%     min = links
%%        InnereSchleife
%%%     Vertausche A[ min ] und A[ links ]
%%%     links = links + 1
%%%   solange links < n
psydoCodeWiederholle(Array, _I, N, Links) when not(Links < N) -> Array;
psydoCodeWiederholle(Array, I, N, Links) ->
  Min = Links,

  ModifyMin = psydoCodeFuerJedesIvonLinks(Array, I, N, Links, Min),

  % Elemente zum vertauschen beschaffen
  ArrayMin = arrayS:getA(Array, ModifyMin),
  ArrayLinks = arrayS:getA(Array, Links),

  % Vertausche Array[ min ] und Array[ links ]
  ModifyArray = arrayS:setA(Array, Links, ArrayMin),
  ModifyArray2 = arrayS:setA(ModifyArray, ModifyMin, ArrayLinks),

  psydoCodeWiederholle(ModifyArray2, I + 1, N, Links + 1).


%%%     für jedes i von links + 1 bis n wiederhole
%%%       falls A[ i ] < A[ min ] dann
%%%         min = i
%%%       ende falls
%%%     ende für
psydoCodeFuerJedesIvonLinks(_Array, I, N, _Links, Min) when (I >= N) -> Min;
psydoCodeFuerJedesIvonLinks(Array, I, N, Links, Min) ->
  AvonI = arrayS:getA(Array, I),
  AvonMin = arrayS:getA(Array, Min),

  %io:fwrite("( A[i] < A[min] )  => "), io:write(AvonI), io:fwrite(" - "), io:write(AvonMin), io:nl(),

  if ( AvonI < AvonMin ) ->
        psydoCodeFuerJedesIvonLinks(Array, I + 1, N, Links, I);
    true ->
      psydoCodeFuerJedesIvonLinks(Array, I + 1, N, Links, Min)
  end.


%=================================================================================================================================================
%                                         Sortieralogorithmus Komponenten mit einem Zaehler fuer die Verschiebungen
%=================================================================================================================================================
psydoCodeWiederholleWithCounter(_Array, _I, N, Links, CompareCounter, ShiftCounter) when not(Links < N) -> [CompareCounter, ShiftCounter];
psydoCodeWiederholleWithCounter(Array, I, N, Links, CompareCounter, ShiftCounter) ->
  Min = Links,

  [ModifyMin, ModifyCompareCounter, ModifyShiftCounter] = psydoCodeFuerJedesIvonLinksWithCounter(Array, I, N, Links, Min, CompareCounter, ShiftCounter),

  % Elemente zum vertauschen beschaffen
  ArrayMin = arrayS:getA(Array, ModifyMin),
  ArrayLinks = arrayS:getA(Array, Links),

  % Vertausche Array[ min ] und Array[ links ]
  ModifyArray = arrayS:setA(Array, Links, ArrayMin),
  ModifyArray2 = arrayS:setA(ModifyArray, ModifyMin, ArrayLinks),

  psydoCodeWiederholleWithCounter(ModifyArray2, I + 1, N, Links + 1, ModifyCompareCounter, ModifyShiftCounter + 2).


%%%     für jedes i von links + 1 bis n wiederhole
%%%       falls A[ i ] < A[ min ] dann
%%%         min = i
%%%       ende falls
%%%     ende für
psydoCodeFuerJedesIvonLinksWithCounter(_Array, I, N, _Links, Min, CompareCounter, ShiftCounter) when (I >= N) -> [Min, CompareCounter, ShiftCounter];
psydoCodeFuerJedesIvonLinksWithCounter(Array, I, N, Links, Min, CompareCounter, ShiftCounter) ->
  AvonI = arrayS:getA(Array, I),
  AvonMin = arrayS:getA(Array, Min),

  %io:fwrite("( A[i] < A[min] )  => "), io:write(AvonI), io:fwrite(" - "), io:write(AvonMin), io:nl(),

  if ( AvonI < AvonMin ) ->
    psydoCodeFuerJedesIvonLinksWithCounter(Array, I + 1, N, Links, I, CompareCounter + 1, ShiftCounter);
    true ->
      psydoCodeFuerJedesIvonLinksWithCounter(Array, I + 1, N, Links, Min, CompareCounter + 1, ShiftCounter)
  end.




















