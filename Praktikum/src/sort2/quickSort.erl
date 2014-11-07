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
-export([quickSortRekursiv/3, quickSortRandom/3]).

quickSortRekursiv(Links, Rechts, Array) ->
  if
    Links < Rechts ->
      Teiler = teileRekursiv(Links, Rechts, Array);
      quickSortRekursiv(Links, Teiler - 1, Array),
      quickSortRekursiv(Teiler + 1, Rechts, Array),
    true -> notImplementedYet
  end.

teileRekursiv(Links, Rechts, Array) ->
  notImplementedYet.

quickSortRandom(Links, Rechts, Array) ->
  if
    Links < Rechts ->
      Teiler = teileRandomisiert(Links, Rechts, Array);
    quickSortRekursiv(Links, Teiler - 1, Array),
    quickSortRekursiv(Teiler + 1, Rechts, Array),
    true -> notImplementedYet
  end.

teileRandomisiert(Links, Rechts, Array) ->
  notImplementedYet.