%%%-------------------------------------------------------------------
%%% @author Team: 4
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

%% API
-export([generateRandomNumbers/5]).

%% Diese Funktion generiert Zufallszahlen
%% @param Integer Number - Anzahl wie viele Zahlen generiert werden soll
%% @param Integer From - Kleinste Zahl die vorkommen kann
%% @param Integer Till - groesste Zahl die vorkommen kann
%% @param String Path - Pfad der Datei, die befuellt werden soll mit generierten Zufallszahlen
%% @param Atom Modus - Modus anhand dessen werden die Zahlen generiert.
%% Beispiel: random, lr, rl.
generateRandomNumbers(Number, From, Till, Path, Modus)  when Modus == random -> random(Number, From, Till, Path);
generateRandomNumbers(Number, From, Till, Path, Modus)  when Modus == bestCase -> bestCase(Number, From, Till, Path);
generateRandomNumbers(Number, From, Till, Path, Modus)  when Modus == worstCase -> worstCase(Number, From, Till, Path);
generateRandomNumbers(_Number, _From, _Till, _Path, _Modus)  -> modusNichtVorhanden.

%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================
random(Number, From, Till, File) ->
  NewPath = utility:giveDefaultFile(File),
  utility:writeInNewFile(NewPath, generateRandomNumbersHelper(Number, From, Till, 1, [])).

worstCase(Number, From, Till, File) ->
  NewPath = utility:giveDefaultFile(File),
  utility:writeInNewFile(NewPath, lists:reverse(lists:sort(generateRandomNumbersHelper(Number, From, Till, 1, [])))).

bestCase(Number, From, Till, File) ->
  NewPath = utility:giveDefaultFile(File),
  utility:writeInNewFile(NewPath, lists:sort(generateRandomNumbersHelper(Number, From, Till, 1, []))).

generateRandomNumbersHelper(Number, From, Till, Counter, Result) ->
  if (Number < Counter) ->
    % Warum machen wir das? Damit er es nicht als ascii konvertiert!
    Result ++ [0];
    %Result;
  true ->
    %generateRandomNumbersHelper(Number, From, Till, Counter + 1, Result ++ [random:uniform(Till) - (From - 1)])
    generateRandomNumbersHelper(Number, From, Till, Counter + 1, Result ++ [(random:uniform(Till - From + 1) + From - 1)  ])
  end.



