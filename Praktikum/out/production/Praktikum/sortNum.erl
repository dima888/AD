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
-export([generateRandomNumbers/4, generateSortNumbersLR/3, generateSortNumbersRL/3]).

%% Diese Funktion generiert Zufallszahlen
%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer From - Kleinste Zahl die vorkommen kann
%% @param Integer Till - groesste Zahl die vorkommen kann
%% @param String Path - Pfad der Datei, die befuellt werden soll mit generierten Zufallszahlen
%% @param Atom Modi - Modus anhand dessen werden die Zahlen generiert.
%% Beispiel: random, lr, rl.
generateRandomNumbers(Number, From, Till, Path) ->
    NewPath = giveDefaultPath(Path),

    % Zwei mal, weil bei ersten mal sehr kommische ausgeben herauskommen
    myIO:writeInNewFile(NewPath, generateRandomNumbersHelper(Number, From, Till, 1, [])),
    myIO:writeInNewFile(NewPath, generateRandomNumbersHelper(Number, From, Till, 1, [])).


%% Funktion generiert Zahlen aufsteigend sortiert
%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer MinNumber - Kleinste Zahl mit der Bekommen wird
%% @param String Path - Pfad der Datei, die befuellt werden soll mit generierten Zufallszahlen
generateSortNumbersLR(Number, MinNumber, Path) ->
  NewPath = giveDefaultPath(Path),
  myIO:writeInNewFile(NewPath, generateSortNumbersLRHelper(Number, MinNumber, Number + MinNumber, Path, [])).


%% Funktion generiert Zahlen absteigend sortiert
%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer MaxNumber - Groesste Zahl die generiert werden kann
%% @param String Path - Pfad der Datei, die befuellt werden soll mit generierten Zufallszahlen
generateSortNumbersRL(Number, MaxNumber, Path) ->
  NewPath = giveDefaultPath(Path),
  myIO:writeInNewFile(NewPath, generateSortNumbersRLHelper(Number, MaxNumber, MaxNumber - Number, Path, [])).


%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================
generateRandomNumbersHelper(Number, From, Till, Counter, Result) ->
  if (Number < Counter) ->
    Result;
  true ->
    generateRandomNumbersHelper(Number, From, Till, Counter + 1, Result ++ [random:uniform(Till) - (From - 1)])
  end.

generateSortNumbersLRHelper(Number, MinNumber, Limit, Path, Result) ->
  if (MinNumber < Limit) ->
    generateSortNumbersLRHelper(Number, MinNumber + 1, Limit, Path, Result ++ [MinNumber]);
  true ->
    Result
  end.

generateSortNumbersRLHelper(Number, 0, Limit, Path, Result) -> Result;
generateSortNumbersRLHelper(Number, MaxNumber, Limit, Path, Result) ->
  if (MaxNumber > Limit) ->
    generateSortNumbersRLHelper(Number, MaxNumber - 1, Limit, Path, Result ++ [MaxNumber]);
    true ->
      Result
  end.

%% Gibt ein default Pfad zurueck
giveDefaultPath(Path) ->
  if (Path == nil) ->
    NewPath = "logFiles/sort1/zahlen.dat";
    true ->
      NewPath = Path
  end.