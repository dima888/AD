%%%-------------------------------------------------------------------
%%% @author foxhound
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
-author("foxhound").

%% API
-export([insertionS/3]).


%% Einzige Schnittstelle nach aussen
%% @param Array Array - Der zur sortierende Array
%% @param Integer Von - Kleinster Index Wert vom Array
%% @param Integer Bis - Groesster Index Wert vom Array
insertionS(Array, Von, Bis) ->

  psydoCodeFor(Array, Von, Bis).


%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================
psydoCodeFor(Array, I, Bis) when I == Bis -> Array;
psydoCodeFor(Array, I, Bis) ->
  Einzusortierender_wert = arrayS:getA(Array, I),
  J = I,

  [ModifyArray, ModifyJ] = psydoCodeWhile(Array, I, J, Einzusortierender_wert, arrayS:getA(Array, J - 1)),

  ModifyArray2 = arrayS:setA(ModifyArray, ModifyJ, Einzusortierender_wert),

  psydoCodeFor(ModifyArray2, I + 1, Bis).

psydoCodeWhile(Array, I, J, Einzusortierender_wert, JminusEins) when (not( (J > 1) and (JminusEins> Einzusortierender_wert) ) ) -> [Array, J];
psydoCodeWhile(Array, I, J, Einzusortierender_wert, JminusEins) ->
  ModifyArray = arrayS:setA(Array, J, JminusEins),
  ModifyJ = J - 1,
  psydoCodeWhile(ModifyArray, I, ModifyJ, Einzusortierender_wert, arrayS:getA(ModifyArray, J - 1)).