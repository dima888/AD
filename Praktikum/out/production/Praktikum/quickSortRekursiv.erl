%%%-------------------------------------------------------------------
%%% @author Flah
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Nov 2014 14:49
%%%
%%% TODO: Bei I und J wurde die Logik vertauscht !!!
%%% TODO: Siehe hierfür die Logs nach der Ausführung.
%%%-------------------------------------------------------------------
-module(quickSortRekursiv).
-author("Flah").

%% API
-export([quickSortRekursiv/3]).

quickSortRekursiv(Links, Rechts, {array, Liste}) ->
  io:format("Eingabeparameter Quicksort:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, {array, Liste}]),
  io:nl(),

  if
    Links < Rechts ->
      [Teiler, NewArray] = teileRekursiv(Links, Rechts, {array, Liste}),
      io:format("Rückgabe von teileRekursiv:~nTeiler: ~p~nArray: ~p~n", [Teiler, NewArray]),
      io:nl(),

      NewArray2 = quickSortRekursiv(Links, Teiler - 1, NewArray),
      io:format("Erster Quicksortaufruf Ergebnis: ~p~n", [NewArray2]),
      io:nl(),

      NewArray3 = quickSortRekursiv(Teiler + 1, Rechts, NewArray2),
      io:format("Zweiter Quicksortaufruf Ergebnis: ~p~n", [NewArray3]),
      io:nl(),
      NewArray3;
  true -> {array, Liste}
  end.

teileRekursiv(Links, Rechts, Array) ->
  io:format("Eingabeparameter Teilefunktion:~nLinks: ~p~nRechts: ~p~nArray: ~p~n", [Links, Rechts, Array]),
  io:nl(),

  % Laufvariablen festlegen
  I = Links,
  J = Rechts - 1, % -1 da ein Array bei Index 0 beginnt

  % starten mit linkestem Element als Pivot
  Pivot = arrayS:getA(Array, Links),

  io:format("Vor Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [I, J, Pivot, Array]),
  io:nl(),

  % Solange i nicht an j vorbeigelaufen ist in die Schleife gehen
  [NewI, NewJ, NewArray] = doWhileILesserThanJ(I, J, Pivot, Links, Rechts, Array),

  io:format("Nach Der Schleife:~nI: ~p~nJ: ~p~nPivot: ~p~nArray: ~p~n", [NewI, NewJ, Pivot, Array]),
  io:nl(),

  %TODO PRÜFEN WAS HIER ABGEHT
  % Tausche Pivotelement (daten[links]) mit neuer endgültiger Position (daten[i])
  IsElemAtPosILesserThenPivot = arrayS:getA(NewArray, NewI) <  Pivot,

  if
    IsElemAtPosILesserThenPivot ->
      % Element zwischenspeichern
      OldI = arrayS:getA(NewArray, NewI),

      % Pivot Element (daten[links] auf neue Position setzten
      ArrayWithNewPivotPos = arrayS:setA(NewArray, NewI, arrayS:getA(NewArray, Links)),

      % Altes Element von stelle I auf daten[links] Position setzten
      ArrayWithSwappedData = arrayS:setA(ArrayWithNewPivotPos, Links, OldI),

      [NewI, ArrayWithSwappedData];

    true -> [NewI, NewArray]
  end.


doWhileILesserThanJ(I, J, Pivot, Links, Rechts, Array) ->
  % Suche von links ein Element, welches größer als das Pivotelement ist
  NewI = whileDataAtILesserOrEqualPivotAndILesserRigth(I, Pivot, Rechts, Array),

  % Suche von rechts ein Element, welches kleiner als das Pivotelement ist
  NewJ = whileDataAtJGreaterOrEqualPivotAndJGreaterLeft(J, Pivot, Links, Array),

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

      % In der Schleife bleiben
      doWhileILesserThanJ(NewI, NewJ, Pivot, Links, Rechts, IAndJSwappedArray);
    true ->
      [NewI, NewJ, Array]
  end.

% Suche von links ein Element, welches größer als das Pivotelement ist
whileDataAtILesserOrEqualPivotAndILesserRigth(I, Pivot, Rechts, Array) ->
  % Abfrage Ergebnis abspeichern
  IsDataAtILesserOrEqualPivotAndILesserRigth = (arrayS:getA(Array, I) =< Pivot) and (I < Rechts),

  if
    IsDataAtILesserOrEqualPivotAndILesserRigth -> whileDataAtILesserOrEqualPivotAndILesserRigth(I + 1, Pivot, Rechts, Array);
    true -> I
  end.

whileDataAtJGreaterOrEqualPivotAndJGreaterLeft(J, Pivot, Links, Array) ->
  % Abfrage Ergebnis abspeichern
  IsDataAtJGreaterOrEqualPivotAndJGreaterLeft = (arrayS:getA(Array, J) >= Pivot) and (J > Links),

  if
    IsDataAtJGreaterOrEqualPivotAndJGreaterLeft -> whileDataAtJGreaterOrEqualPivotAndJGreaterLeft(J - 1, Pivot, Links, Array);
    true -> J
  end.