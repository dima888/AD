%%%-------------------------------------------------------------------
%%% @author foxhound
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
-author("foxhound").

%% API
-export([selectionS/3]).

%% Einzige Schnittstelle nach aussen
selectionS(Array, Von, Bis) ->

  todo.