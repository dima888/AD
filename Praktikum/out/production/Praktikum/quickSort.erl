%%%-------------------------------------------------------------------
%%% @author Flah
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Nov 2014 14:49
%%%
%%% --> EXAMPLE ARRAYS <--
%%% ArrayWithNumbers = arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(Array, 0, 44), 1, 55), 2, 12), 3, 42), 4, 94), 5, 6), 6, 18), 7, 67).
%%% ArrayWithNumbers = arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(Array, 0, 12), 1, 9), 2, 17), 3, 8), 4, 7), 5, 11), 6, 2), 7, 3), 8, 5), 9, 10), 10, 18), 11, 15).
%%% ArrayWithNumbers = arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(Array, 0, 3), 1, 1), 2, 4), 3, 2).
%%% ArrayWithNumbers = arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(arrayS:setA(Array, 0, 3), 1, 1), 2, 4), 3, 2), 4, 7), 5, 9).

%%% measurement:start(withFixedPivot, 1, "/Users/Flah/Desktop/messung.log", "/Users/Flah/Desktop/zahlen.dat", "/Users/Flah/Desktop/sortiert.dat", [10000, 0, 10000]).


%%%-------------------------------------------------------------------
-module(quickSort).
-author("Flah").

%% API
-export([withFixedPivot/5, withRandomPivot/5]).

%================================================================================================================================================
%                                                           FIXED PIVOT
%================================================================================================================================================

withFixedPivot(Links, Rechts, {array, Liste}, insertionSort, ResultPath) ->
  StartTime = utility:getTimestampInMilliSeconds(),
  SortedArray = sortWithFixedPivot(Links, Rechts - 1, {array, Liste}, insertionSort, ResultPath),
  EndTime = utility:getTimestampInMilliSeconds(),
  RunTime = EndTime - StartTime,
  [_SortedArray, CompareCounter, ShiftCounter] = sortWithFixedPivotWithCounters(Links, Rechts - 1, {array, Liste}, insertionSort, ResultPath, 0, 0),
  [SortedArray, CompareCounter, ShiftCounter, RunTime];
withFixedPivot(Links, Rechts, {array, Liste}, selectionSort, ResultPath) ->
  StartTime = utility:getTimestampInMilliSeconds(),
  SortedArray = sortWithFixedPivot(Links, Rechts - 1, {array, Liste}, selectionSort, ResultPath),
  EndTime = utility:getTimestampInMilliSeconds(),
  RunTime = EndTime - StartTime,
  [_SortedArray, CompareCounter, ShiftCounter] = sortWithFixedPivotWithCounters(Links, Rechts - 1, {array, Liste}, selectionSort, ResultPath, 0, 0),
  [SortedArray, CompareCounter, ShiftCounter, RunTime].

sortWithFixedPivot(Links, Rechts, {array, Liste}, AlternateAlgo, ResultPath) ->
  %io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  %io:nl(),
  if
    (Rechts - Links) < 12 -> if
                               AlternateAlgo == insertionSort -> lists:nth(1, insertionSort:insertionS({array, Liste}, Links, Rechts + 1, ResultPath));
                               true -> lists:nth(1, selectionSort:selectionS({array, Liste}, Links, Rechts + 1, ResultPath))
                             end;

    true -> if
              Links < Rechts ->
              [Teiler, NewArray] = divideForFixedPivot(Links, Rechts, {array, Liste}),
              %io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
              %io:nl(),

              NewArray2 = sortWithFixedPivot(Links, Teiler - 1, NewArray, AlternateAlgo, ResultPath),
              %io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
              %io:nl(),

              NewArray3 = sortWithFixedPivot(Teiler + 1, Rechts, NewArray2, AlternateAlgo, ResultPath),
              %io:format("Zweiter Quicksortaufruf Ergebnis: ~p~n", [NewArray3]),
              %io:nl(),

              NewArray3;
            true -> {array, Liste}

            end
  end.

divideForFixedPivot(Links, Rechts, Array) ->
  %io:format("Eingabeparameter Teilefunktion:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  %io:nl(),

  % Laufvariablen festlegen
  I = Links,
  J = Rechts,

  % starten mit linkestem Element als Pivot
  Pivot = arrayS:getA(Array, Links),

  %io:format("Vor Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [I, J, Pivot, Array]),
  %io:nl(),

  % Solange i nicht an j vorbeigelaufen ist in die Schleife gehen
  [NewI, NewJ, NewArray] = doWhileILesserThanJ(I, J, Pivot, Links, Rechts, Array),

  %io:format("Nach Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [NewI, NewJ, Pivot, NewArray]),
  %io:nl(),

  % Tausche Pivotelement (daten[links]) mit neuer endgültiger Position (daten[i])
  IsElemAtPosILesserThenPivot = arrayS:getA(NewArray, NewJ) <  Pivot,

  %io:format("Prüfe NewJ(~p) < Pivot(~p): ~p~n", [arrayS:getA(NewArray, NewJ), Pivot, IsElemAtPosILesserThenPivot]),
  %io:nl(),

  if
    IsElemAtPosILesserThenPivot ->
      % Element zwischenspeichern
      OldJ = arrayS:getA(NewArray, NewJ),

      % Pivot Element (daten[links] auf neue Position setzten
      ArrayWithNewPivotPos = arrayS:setA(NewArray, NewJ, arrayS:getA(NewArray, Links)),

      % Altes Element von stelle J auf daten[links] Position setzten
      ArrayWithSwappedData = arrayS:setA(ArrayWithNewPivotPos, Links, OldJ),

      %io:format("Pivot getauscht mit OldI: ~p~n", [IsElemAtPosILesserThenPivot]),
      %io:nl(),

      [NewJ, ArrayWithSwappedData];

    true -> [NewJ, NewArray]
  end.

%================================================================================================================================================
%                                                   FIXED PIVOT COMPARE AND SHIFT COUNTER
%================================================================================================================================================

sortWithFixedPivotWithCounters(Links, Rechts, {array, Liste}, AlternateAlgo, ResultPath, CompareCounter, ShiftCounter) ->
  %io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  %io:nl(),
  if
    (Rechts - Links) < 12 -> if
                               AlternateAlgo == insertionSort ->
                                 Result = insertionSort:insertionS({array, Liste}, Links, Rechts + 1, ResultPath),
                                 [lists:nth(1, Result), lists:nth(2, Result) + CompareCounter, lists:nth(3, Result) + ShiftCounter];

                               true ->
                                 Result = selectionSort:selectionS({array, Liste}, Links, Rechts + 1, ResultPath),
                                 [lists:nth(1, Result), lists:nth(2, Result) + CompareCounter, lists:nth(3, Result) + ShiftCounter]
                             end;

    true -> if
              Links < Rechts ->
                [Teiler, NewArray, CompareCounter1, ShiftCounter1] = divideForFixedPivotWithCounters(Links, Rechts, {array, Liste}, CompareCounter + 1, ShiftCounter),
                %io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
                %io:nl(),

                [NewArray2, CompareCounter2, ShiftCounter2] = sortWithFixedPivotWithCounters(Links, Teiler - 1, NewArray, AlternateAlgo, ResultPath, CompareCounter1 + 1, ShiftCounter1),
                %io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
                %io:nl(),

                [_NewArray3, _CompareCounter3, _ShiftCounter3] = sortWithFixedPivotWithCounters(Teiler + 1, Rechts, NewArray2, AlternateAlgo, ResultPath, CompareCounter2 + 1, ShiftCounter2);
                %io:format("Zweiter Quicksortaufruf Ergebnis: ~p~n", [NewArray3]),
                %io:nl(),
              true -> [{array, Liste}, CompareCounter, ShiftCounter]

            end
  end.

divideForFixedPivotWithCounters(Links, Rechts, Array, CompareCounter, ShiftCounter) ->
  %io:format("Eingabeparameter Teilefunktion:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  %io:nl(),

  % Laufvariablen festlegen
  I = Links,
  J = Rechts,

  % starten mit linkestem Element als Pivot
  Pivot = arrayS:getA(Array, Links),

  %io:format("Vor Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [I, J, Pivot, Array]),
  %io:nl(),

  % Solange i nicht an j vorbeigelaufen ist in die Schleife gehen
  [NewI, NewJ, NewArray, CompareCounter1, ShiftCounter1] = doWhileILesserThanJWithCounters(I, J, Pivot, Links, Rechts, Array, CompareCounter, ShiftCounter),

  %io:format("Nach Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [NewI, NewJ, Pivot, NewArray]),
  %io:nl(),

  % Tausche Pivotelement (daten[links]) mit neuer endgültiger Position (daten[i])
  IsElemAtPosILesserThenPivot = arrayS:getA(NewArray, NewJ) <  Pivot,

  %io:format("Prüfe NewJ(~p) < Pivot(~p): ~p~n", [arrayS:getA(NewArray, NewJ), Pivot, IsElemAtPosILesserThenPivot]),
  %io:nl(),

  if
    IsElemAtPosILesserThenPivot ->
      % Element zwischenspeichern
      OldJ = arrayS:getA(NewArray, NewJ),

      % Pivot Element (daten[links] auf neue Position setzten
      ArrayWithNewPivotPos = arrayS:setA(NewArray, NewJ, arrayS:getA(NewArray, Links)),

      % Altes Element von stelle J auf daten[links] Position setzten
      ArrayWithSwappedData = arrayS:setA(ArrayWithNewPivotPos, Links, OldJ),

      %io:format("Pivot getauscht mit OldI: ~p~n", [IsElemAtPosILesserThenPivot]),
      %io:nl(),

      [NewJ, ArrayWithSwappedData, CompareCounter1 + 1, ShiftCounter1 + 1];

    true -> [NewJ, NewArray, CompareCounter1 + 1, ShiftCounter1]
  end.

%================================================================================================================================================
%                                                           RANDOM PIVOT
%================================================================================================================================================

withRandomPivot(Links, Rechts, {array, Liste}, insertionSort, ResultPath) ->
  StartTime = utility:getTimestampInMilliSeconds(),
  SortedArray = sortWithRandomPivot(Links, Rechts - 1, {array, Liste}, insertionSort, ResultPath),
  EndTime = utility:getTimestampInMilliSeconds(),
  RunTime = EndTime - StartTime,
  [_SortedArray, CompareCounter, ShiftCounter] = sortWithRandomPivotWithCounters(Links, Rechts - 1, {array, Liste}, insertionSort, ResultPath, 0, 0),
  [SortedArray, CompareCounter, ShiftCounter, RunTime];
withRandomPivot(Links, Rechts, {array, Liste}, selectionSort, ResultPath) ->
  StartTime = utility:getTimestampInMilliSeconds(),
  SortedArray = sortWithRandomPivot(Links, Rechts - 1, {array, Liste}, selectionSort, ResultPath),
  EndTime = utility:getTimestampInMilliSeconds(),
  RunTime = EndTime - StartTime,
  [_SortedArray, CompareCounter, ShiftCounter] = sortWithRandomPivotWithCounters(Links, Rechts - 1, {array, Liste}, selectionSort, ResultPath, 0, 0),
  [SortedArray, CompareCounter, ShiftCounter, RunTime].

sortWithRandomPivot(Links, Rechts, {array, Liste}, AlternateAlgo, ResultPath) ->
  %io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  %io:nl(),
  if
    (Rechts - Links) < 12 -> if
                               AlternateAlgo == insertionSort -> lists:nth(1, insertionSort:insertionS({array, Liste}, Links, Rechts + 1, ResultPath));
                               true -> lists:nth(1, selectionSort:selectionS({array, Liste}, Links, Rechts + 1, ResultPath))
                             end;

    true -> if
              Links < Rechts ->
                [Teiler, NewArray] = divideForRandomPivot(Links, Rechts, {array, Liste}),
                %io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
                %io:nl(),

                NewArray2 = sortWithRandomPivot(Links, Teiler - 1, NewArray, AlternateAlgo, ResultPath),
                %io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
                %io:nl(),

                NewArray3 = sortWithRandomPivot(Teiler + 1, Rechts, NewArray2, AlternateAlgo, ResultPath),
                %io:format("Zweiter Quicksortaufruf Ergebnis: ~p~n", [NewArray3]),
                %io:nl(),

                NewArray3;
              true -> {array, Liste}

            end
  end.

divideForRandomPivot(Links, Rechts, Array) ->
  %io:format("Eingabeparameter Teilefunktion:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  %io:nl(),

  % Laufvariablen festlegen
  I = Links,
  J = Rechts,

  % starten mit linkestem Element als Pivot
  Pivot = arrayS:getA(Array, generateRandomNumber(Links, Rechts)),

  %io:format("Vor Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [I, J, Pivot, Array]),
  %io:nl(),

  % Solange i nicht an j vorbeigelaufen ist in die Schleife gehen
  [NewI, NewJ, NewArray] = doWhileILesserThanJ(I, J, Pivot, Links, Rechts, Array),

  %io:format("Nach Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [NewI, NewJ, Pivot, NewArray]),
  %io:nl(),

  % Tausche Pivotelement (daten[links]) mit neuer endgültiger Position (daten[i])
  IsElemAtPosILesserThenPivot = arrayS:getA(NewArray, NewJ) <  Pivot,

  %io:format("Prüfe NewJ(~p) < Pivot(~p): ~p~n", [arrayS:getA(NewArray, NewJ), Pivot, IsElemAtPosILesserThenPivot]),
  %io:nl(),

  if
    IsElemAtPosILesserThenPivot ->
      % Element zwischenspeichern
      OldJ = arrayS:getA(NewArray, NewJ),

      % Pivot Element (daten[links] auf neue Position setzten
      ArrayWithNewPivotPos = arrayS:setA(NewArray, NewJ, arrayS:getA(NewArray, Links)),

      % Altes Element von stelle J auf daten[links] Position setzten
      ArrayWithSwappedData = arrayS:setA(ArrayWithNewPivotPos, Links, OldJ),

      %io:format("Pivot getauscht mit OldI: ~p~n", [IsElemAtPosILesserThenPivot]),
      %io:nl(),

      [NewJ, ArrayWithSwappedData];

    true -> [NewJ, NewArray]
  end.

%================================================================================================================================================
%                                                RANDOM PIVOT COMPARE AND SHIFT COUNTER
%================================================================================================================================================

sortWithRandomPivotWithCounters(Links, Rechts, {array, Liste}, AlternateAlgo, ResultPath, CompareCounter, ShiftCounter) ->
  %io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  %io:nl(),
  if
    (Rechts - Links) < 12 -> if
                               AlternateAlgo == insertionSort ->
                                 Result = insertionSort:insertionS({array, Liste}, Links, Rechts + 1, ResultPath),
                                 [lists:nth(1, Result), lists:nth(2, Result) + CompareCounter, lists:nth(3, Result) + ShiftCounter];

                               true ->
                                 Result = selectionSort:selectionS({array, Liste}, Links, Rechts + 1, ResultPath),
                                 [lists:nth(1, Result), lists:nth(2, Result) + CompareCounter, lists:nth(3, Result) + ShiftCounter]
                             end;

    true -> if
              Links < Rechts ->
                [Teiler, NewArray, CompareCounter1, ShiftCounter1] = divideForRandomPivotWithCounters(Links, Rechts, {array, Liste}, CompareCounter + 1, ShiftCounter),
                %io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
                %io:nl(),

                [NewArray2, CompareCounter2, ShiftCounter2] = sortWithRandomPivotWithCounters(Links, Teiler - 1, NewArray, AlternateAlgo, ResultPath, CompareCounter1 + 1, ShiftCounter1),
                %io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
                %io:nl(),

                [_NewArray3, _CompareCounter3, _ShiftCounter3] = sortWithRandomPivotWithCounters(Teiler + 1, Rechts, NewArray2, AlternateAlgo, ResultPath, CompareCounter2 + 1, ShiftCounter2);
    %io:format("Zweiter Quicksortaufruf Ergebnis: ~p~n", [NewArray3]),
    %io:nl(),
              true -> [{array, Liste}, CompareCounter, ShiftCounter]

            end
  end.

divideForRandomPivotWithCounters(Links, Rechts, Array, CompareCounter, ShiftCounter) ->
  %io:format("Eingabeparameter Teilefunktion:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  %io:nl(),

  % Laufvariablen festlegen
  I = Links,
  J = Rechts,

  % starten mit linkestem Element als Pivot
  Pivot = arrayS:getA(Array, generateRandomNumber(Links, Rechts)),

  %io:format("Vor Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [I, J, Pivot, Array]),
  %io:nl(),

  % Solange i nicht an j vorbeigelaufen ist in die Schleife gehen
  [NewI, NewJ, NewArray, CompareCounter1, ShiftCounter1] = doWhileILesserThanJWithCounters(I, J, Pivot, Links, Rechts, Array, CompareCounter, ShiftCounter),

  %io:format("Nach Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [NewI, NewJ, Pivot, NewArray]),
  %io:nl(),

  % Tausche Pivotelement (daten[links]) mit neuer endgültiger Position (daten[i])
  IsElemAtPosILesserThenPivot = arrayS:getA(NewArray, NewJ) <  Pivot,

  %io:format("Prüfe NewJ(~p) < Pivot(~p): ~p~n", [arrayS:getA(NewArray, NewJ), Pivot, IsElemAtPosILesserThenPivot]),
  %io:nl(),

  if
    IsElemAtPosILesserThenPivot ->
      % Element zwischenspeichern
      OldJ = arrayS:getA(NewArray, NewJ),

      % Pivot Element (daten[links] auf neue Position setzten
      ArrayWithNewPivotPos = arrayS:setA(NewArray, NewJ, arrayS:getA(NewArray, Links)),

      % Altes Element von stelle J auf daten[links] Position setzten
      ArrayWithSwappedData = arrayS:setA(ArrayWithNewPivotPos, Links, OldJ),

      %io:format("Pivot getauscht mit OldI: ~p~n", [IsElemAtPosILesserThenPivot]),
      %io:nl(),

      [NewJ, ArrayWithSwappedData, CompareCounter1 + 1, ShiftCounter1 + 1];

    true -> [NewJ, NewArray, CompareCounter1 + 1, ShiftCounter1]
  end.

%================================================================================================================================================
%                                                           SHARED FUNCTIONS
%================================================================================================================================================

doWhileILesserThanJ(I, J, Pivot, Links, Rechts, Array) ->
  %io:format("Eingabeparameter DoWhileILesserThan:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  %io:nl(),

  % Suche von links ein Element, welches größer als das Pivotelement ist
  NewI = whileDataAtILesserOrEqualPivotAndILesserRigth(I, Pivot, Rechts, Array),

  %io:format("NewI: ~p~n", [NewI]),
  %io:nl(),

  % Suche von rechts ein Element, welches kleiner als das Pivotelement ist
  NewJ = whileDataAtJGreaterOrEqualPivotAndJGreaterLeft(J, Pivot, Links, Array),

  %io:format("NewJ: ~p~n", [NewJ]),
  %io:nl(),

  % Solange i an j nicht vorbeigelaufen ist
  if
    NewI < NewJ ->
      % Tausche daten[i] mit daten[j]
      % Altes Elem an daten[j] zwischenspeichern
      ElemAtJ = arrayS:getA(Array, NewJ),

      % daten[i] auf daten[j] setzten
      IChangedToNewPositionArray = arrayS:setA(Array, NewJ, arrayS:getA(Array, NewI)),

      % vorherig abgespeichertes Element auf daten[i] setzten
      IAndJSwappedArray = arrayS:setA(IChangedToNewPositionArray, NewI, ElemAtJ),

      %io:format("Pos I getauscht mit Pos J: ~p~n", [IAndJSwappedArray]),
      %io:nl(),

      % In der Schleife bleiben
      doWhileILesserThanJ(NewI, NewJ, Pivot, Links, Rechts, IAndJSwappedArray);
    true ->
      [NewI, NewJ, Array]
  end.

% wiederhole solange daten[i] ≤ pivot und i < rechts
whileDataAtILesserOrEqualPivotAndILesserRigth(I, Pivot, Rechts, Array) ->
  % Abfrage Ergebnis abspeichern
  IsDataAtILesserOrEqualPivotAndILesserRigth = (arrayS:getA(Array, I) =< Pivot) and (I < Rechts),

  if
    IsDataAtILesserOrEqualPivotAndILesserRigth -> whileDataAtILesserOrEqualPivotAndILesserRigth(I + 1, Pivot, Rechts, Array);
    true -> I
  end.

% wiederhole solange daten[j] ≥ pivot und j > links
whileDataAtJGreaterOrEqualPivotAndJGreaterLeft(J, Pivot, Links, Array) ->
  % Abfrage Ergebnis abspeichern
  IsDataAtJGreaterOrEqualPivotAndJGreaterLeft = (arrayS:getA(Array, J) >= Pivot) and (J > Links),

  if
    IsDataAtJGreaterOrEqualPivotAndJGreaterLeft -> whileDataAtJGreaterOrEqualPivotAndJGreaterLeft(J - 1, Pivot, Links, Array);
    true -> J
  end.

doWhileILesserThanJWithCounters(I, J, Pivot, Links, Rechts, Array, CompareCounter, ShiftCounter) ->
  %io:format("Eingabeparameter DoWhileILesserThan:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  %io:nl(),

  % Suche von links ein Element, welches größer als das Pivotelement ist
  [NewI, CompareCounter1, ShiftCounter1] = whileDataAtILesserOrEqualPivotAndILesserRigthWithCounters(I, Pivot, Rechts, Array, CompareCounter, ShiftCounter),

  %io:format("NewI: ~p~n", [NewI]),
  %io:nl(),

  % Suche von rechts ein Element, welches kleiner als das Pivotelement ist
  [NewJ, CompareCounter2, ShiftCounter2] = whileDataAtJGreaterOrEqualPivotAndJGreaterLefWithCounters(J, Pivot, Links, Array, CompareCounter1, ShiftCounter1),

  %io:format("NewJ: ~p~n", [NewJ]),
  %io:nl(),

  % Solange i an j nicht vorbeigelaufen ist
  if
    NewI < NewJ ->
      % Tausche daten[i] mit daten[j]
      % Altes Elem an daten[j] zwischenspeichern
      ElemAtJ = arrayS:getA(Array, NewJ),

      % daten[i] auf daten[j] setzten
      IChangedToNewPositionArray = arrayS:setA(Array, NewJ, arrayS:getA(Array, NewI)),

      % vorherig abgespeichertes Element auf daten[i] setzten
      IAndJSwappedArray = arrayS:setA(IChangedToNewPositionArray, NewI, ElemAtJ),

      %io:format("Pos I getauscht mit Pos J: ~p~n", [IAndJSwappedArray]),
      %io:nl(),

      % In der Schleife bleiben
      doWhileILesserThanJWithCounters(NewI, NewJ, Pivot, Links, Rechts, IAndJSwappedArray, CompareCounter2 + 1, ShiftCounter2 + 1);
    true ->
      [NewI, NewJ, Array, CompareCounter, ShiftCounter]
  end.

% wiederhole solange daten[i] ≤ pivot und i < rechts
whileDataAtILesserOrEqualPivotAndILesserRigthWithCounters(I, Pivot, Rechts, Array, CompareCounter, ShiftCounter) ->
  % Abfrage Ergebnis abspeichern
  IsDataAtILesserOrEqualPivotAndILesserRigth = (arrayS:getA(Array, I) =< Pivot) and (I < Rechts),

  if
    IsDataAtILesserOrEqualPivotAndILesserRigth -> whileDataAtILesserOrEqualPivotAndILesserRigthWithCounters(I + 1, Pivot, Rechts, Array, CompareCounter + 2, ShiftCounter);
    true -> [I, CompareCounter, ShiftCounter]
  end.

% wiederhole solange daten[j] ≥ pivot und j > links
whileDataAtJGreaterOrEqualPivotAndJGreaterLefWithCounters(J, Pivot, Links, Array, CompareCounter, ShiftCounter) ->
  % Abfrage Ergebnis abspeichern
  IsDataAtJGreaterOrEqualPivotAndJGreaterLeft = (arrayS:getA(Array, J) >= Pivot) and (J > Links),

  if
    IsDataAtJGreaterOrEqualPivotAndJGreaterLeft -> whileDataAtJGreaterOrEqualPivotAndJGreaterLefWithCounters(J - 1, Pivot, Links, Array, CompareCounter + 2, ShiftCounter);
    true -> [J, CompareCounter, ShiftCounter]
  end.

generateRandomNumber(Min, Max) ->
  generateRandomNumber(Min, Max, random:uniform(Min) + Min).

generateRandomNumber(Min, Max, Number) when (Number > Max) or (Number < Min) ->
  generateRandomNumber(Min, Max);
generateRandomNumber(_Min, _Max, Number) ->
  Number.