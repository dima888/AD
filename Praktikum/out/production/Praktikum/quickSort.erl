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
-export([withFixedPivot/5, withRandomPivot/4]).

%================================================================================================================================================
%                                                           FIXED PIVOT
%================================================================================================================================================

withFixedPivot(Links, Rechts, {array, Liste}, insertionSort, ResultPath) ->
  sortWithFixedPivot(Links, Rechts - 1, {array, Liste}, insertionSort, ResultPath);
withFixedPivot(Links, Rechts, {array, Liste}, selectionSort, ResultPath) ->
  sortWithFixedPivot(Links, Rechts - 1, {array, Liste}, selectionSort, ResultPath).

sortWithFixedPivot(Links, Rechts, {array, Liste}, AlternateAlgo, ResultPath) ->
  %io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  %io:nl(),
  if
    (Rechts - Links) < 12 -> if %% TODO MUSS ANGEPASST WERDEN
                               AlternateAlgo == insertionSort -> insertionSort:insertionS(1, {array, Liste}, Links, Rechts + 1, ResultPath);
                               true -> selectionSort:selectionS({array, Liste}, Links, Rechts + 1, ResultPath)
                             end;

    true -> if
              Links < Rechts ->
              [Teiler, NewArray] = divideForFixedPivot(Links, Rechts, {array, Liste}),
              %io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
              %io:nl(),

              NewArray2 = sortWithFixedPivot(Links, Teiler - 1, NewArray, AlternateAlgo, ResultPath),
              %io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
              %io:nl(),

              NewArray3 = sortWithFixedPivot(Teiler + 1, Rechts, lists:nth(1, NewArray2), AlternateAlgo, ResultPath),
              %io:format("Zweiter Quicksortaufruf Ergebnis: ~p~n", [NewArray3]),
              %io:nl(),

              NewArray3;
            true -> [{array, Liste}, 5, 5, 5]

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
%                                                           RANDOM PIVOT
%================================================================================================================================================

withRandomPivot(Links, Rechts, {array, Liste}, insertionSort) ->
  sortWithRandomPivot(Links, Rechts - 1, {array, Liste}, insertionSort);
withRandomPivot(Links, Rechts, {array, Liste}, selectionSort) ->
  sortWithRandomPivot(Links, Rechts - 1, {array, Liste}, selectionSort).

sortWithRandomPivot(Links, Rechts, {array, Liste}, AlternateAlgo) ->
  %io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  %io:nl(),
  if
    (Rechts - Links) < 12 -> if %% TODO MUSS ANGEPASST WERDEN
                               AlternateAlgo == insertionSort -> insertionSort:insertionS({array, Liste}, Links, Rechts + 1, "PFAD ANGEBEN!");
                               true -> selectionSort:selectionS({array, Liste}, Links, Rechts + 1, "PFAD ANGEBEN!")
                             end;

    true -> if
              Links < Rechts ->
                [Teiler, NewArray] = divideForRandomPivot(Links, Rechts, {array, Liste}),
                %io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
                %io:nl(),

                NewArray2 = sortWithRandomPivot(Links, Teiler - 1, NewArray, AlternateAlgo),
                %io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
                %io:nl(),

                NewArray3 = sortWithRandomPivot(Teiler + 1, Rechts, NewArray2, AlternateAlgo),
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

  % Zufälliges Pivot Element auswählen
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

generateRandomNumber(Min, Max) ->
  generateRandomNumber(Min, Max, random:uniform(Min) + Min).

generateRandomNumber(Min, Max, Number) when (Number > Max) or (Number < Min) ->
  generateRandomNumber(Min, Max);
generateRandomNumber(_Min, _Max, Number) ->
  Number.

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