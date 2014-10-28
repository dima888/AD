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
-export([numberGenerator/4]).

%% Diese Funktion generiert Zufallszahlen
%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer From - Kleinste Zahl die vorkommen kann
%% @param Integer Till - groesste Zahl die vorkommen kann
%% @param String Path - Pfad der Datei, die befuellt werden soll mit generierten Zufallszahlen
numberGenerator(Number, From, Till, Path) ->

  if (Path == nil) ->
    NewPath = "logFiles/sort1/zahlen.dat";
  true ->
    NewPath = Path
  end,
  % Zwei mal, weil bei ersten mal sehr kommische ausgeben herauskommen
  myIO:writeInNewFile(NewPath, numberGeneratorHelper(Number, From, Till, 1, [])),
  myIO:writeInNewFile(NewPath, numberGeneratorHelper(Number, From, Till, 1, [])).


%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer From - Kleinste Zahl die vorkommen kann
%% @param Integer Till - groesste Zahl die vorkommen kann
worstCaseLR(Number, From, Till) ->
  todo.

%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer From - Kleinste Zahl die vorkommen kann
%% @param Integer Till - groesste Zahl die vorkommen kann
worstCaseRL(Number, From, Till) ->
  todo.

%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================
numberGeneratorHelper(Number, From, Till, Counter, Result) ->
  if (Number < Counter) ->
    Result;
  true ->
  numberGeneratorHelper(Number, From, Till, Counter + 1, Result ++ [random:uniform(Till) - (From - 1)])
  end.
