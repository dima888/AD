%%%-------------------------------------------------------------------
%%% @author foxhound
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% Zahlengenerator: Dieser Algorithmus erzeugt eine vorgegebene Anzahl an positiven ganzen Zufallszahlen
%%% oder eine "worst case" Situation: von links nach rechts und rechts nach links sortiert,
%%% und speichert sie in der Datei zahlen.dat.
%%%
%%% @end
%%% Created : 28. Okt 2014 11:34
%%%-------------------------------------------------------------------
-module(sortNum).
-author("foxhound").

%% API
-export([start/0]).

start() ->

  util:randomliste(10, 5, 10).