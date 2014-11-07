%%%-------------------------------------------------------------------
%%% @author Flah
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Nov 2014 14:49
%%%-------------------------------------------------------------------
-module(quickSort).
-author("Flah").

%% API
-export([quickSortRekursiv/1]).

quickSortRekursiv(Array) ->
  Links = 0,
  Rechts = arrayS:lengthA(Array) - 1,
  quickSort(Links, Rechts).

quickSort(Links, Rechts) ->
  notImplementedYet.