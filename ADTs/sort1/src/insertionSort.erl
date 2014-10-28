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
insertionS(Array, Von, Bis) ->

  todo.