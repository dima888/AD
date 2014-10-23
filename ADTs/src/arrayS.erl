%% ======== ANFORDERUNGEN =========

%% Das Array beginnt bei Position 0

%% Das Array arbeitet destruktiv, d.h. wird ein Element an einer vorhandenen Position eingefügt,
%% wird das dort stehende Element überschrieben

%% Die Länge des Arrays wird bestimmt durch die bis zur aktuellen Abfrage größten vorhandenen und
%% explizit beschriebenen Position im array

%% Das Array ist mit 0 initialisiert, d.h. greift man auf eine bisher noch nicht beschriebene Position
%% im Array zu erhält man 0 als Wert

%% Das Array hat keine Größenbeschränkung, d.h. bei der Initialisierung wird keine Größe vorgegeben

%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

-module(arrayS).

%% API
-export([initA/0, setA/3, getA/2, lengthA/1]).

%% ∅ → array
initA() ->
  liste:create().

%% array × pos × elem → array
setA(Array, Pos, Elem) ->
  if  % Prüfen ob negative Pos übergeben wurde
      Pos < 0 ->
        % Falls true, nicht modifiziertes Array zurück geben
        Array;
      true ->
        % Position anpassen, da Liste an Pos 1 beginnt und Array an Pos 0
        AdjustedPos = Pos + 1,

        % Ergenis der Abfrage speichern, ob die übergebene Pos größer ist als die Länge des übergebenen Arrays
        IsPosGreaterThanArrayLength = AdjustedPos > lengthA(Array),

        if  % Prüfen ob Pos größer ist als Arraylänge
            IsPosGreaterThanArrayLength == true ->

              % Array mit Nullen befüllen bis Position - 1 erreicht ist um übergebenes Element einzufügen
              FilledArray = fillUpArray(Array, AdjustedPos),
              liste:insert(FilledArray, AdjustedPos, Elem);

            % Falls Arraylänge größer oder gleich Pos ist
            true ->
              % Bestehendes Element löschen
              ModifiedArray = liste:delete(Array, AdjustedPos),

              % Neues Elementeinfügen
              liste:insert(ModifiedArray, AdjustedPos, Elem)
        end
  end.

%% array × pos → elem
getA(Array, Pos) ->
  if  % Prüfen ob negative Pos übergeben wurde
      Pos < 0 ->
        % TODO: Zu klären was in diesem Fall zurück gegeben werden muss (SKIZZE)
        todo;

      % Falls Pos >= 0 ist
      true ->
        % Position anpassen, da Liste an Pos 1 beginnt und Array an Pos 0
        AdjustedPos = Pos + 1,

        % Ergebnis der Abfrage abspeichern
        ArrayLengthGreaterThanOrEqualPos = lengthA(Array) >= AdjustedPos,

        if  % Prüfen ob die Arraylänge größer oder gleich Pos ist
            ArrayLengthGreaterThanOrEqualPos == true ->

              % Element zurückgeben
              liste:retrieve(Array, AdjustedPos);

            % Falls
            true ->
              % 0 für nicht beschriebene Position zurück geben, da Pos größer als Arraylength
              0
         end
  end.

%% array → pos
lengthA(Array) ->
  % Position anpassen, da Liste an Pos 1 beginnt und Array an Pos 0
  liste:laenge(Array) - 1.

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

%% Befüllt das übergebene Array mit Nullen bis zur übergebenen Position
fillUpArray(Array, Pos) ->
  io:format("Arrayinhalt: ~p~n", [Array]),
  io:format("Position an der eingefügt werden soll: ~p~n", [Pos]),

  % Aktuelle Arraylänge ermitteln
  CurrentLength = liste:laenge(Array),
  io:format("Arraylänge: ~p~n", [liste:laenge(Array)]),

  % Anzahl einzufügender Nullen berechnen
  FillUpCounter = (Pos - 1) - CurrentLength,
  io:format("FillUpCounter: ~p~n", [FillUpCounter]),

  % Nullen auffüllen
  fillUpArrayR(Array, FillUpCounter).

% Rekursive Methode um dem übergebenen Array um die Anzahl FillUpCounter Nullen hinzuzufügen
fillUpArrayR(Array, 0) ->
  Array;
fillUpArrayR(Array, FillUpCounter) ->
  NewList = liste:create(),
  ListWithZero = liste:insert(NewList, 1, 0),
  fillUpArrayR(liste:concat(Array, ListWithZero), FillUpCounter - 1).