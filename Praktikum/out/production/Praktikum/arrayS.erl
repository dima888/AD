%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

% Ein Array besteht aus einem Typ und einer Liste, die standardmäßig leer ist. Das Array hat keine fest-
% gelegte Länge und kann somit immer wachsen, wenn nötig. Das Array beginnt bei der Position 0.

-module(arrayS).

%% API
-export([initA/0, setA/3, getA/2, lengthA/1]).

%% ∅ → array
%% ***************************************** NACH SKIZZE *****************************************************
%% Erzeugt eine neue Instanz des Tupels mit einer leeren Liste.
%% ***************************************** NACH SKIZZE *****************************************************
initA() ->
  {array, liste:create()}.

%% array × pos × elem → array
%% ***************************************** NACH SKIZZE *****************************************************
%% Ersetzt das Element an angegebener Position mit dem einzufügenden Element. Wenn die angegebe- ne Position
%% über die Länge der aktuellen Liste hinaus geht, wird die Liste soweit wie nötig verlängert, so dass das
%% Element an der gewünschten Position eingefügt werden kann.
%% ***************************************** NACH SKIZZE *****************************************************
setA({array, Liste}, Pos, Elem) ->
  if  % Prüfen ob negative Pos übergeben wurde
      Pos < 0 ->
        % Falls true, nicht modifiziertes Array zurück geben
        {array, Liste};
      true ->
        % Position anpassen, da Liste an Pos 1 beginnt und Array an Pos 0
        AdjustedPos = Pos + 1,

        % Ergenis der Abfrage speichern, ob die übergebene Pos größer ist als die Länge des übergebenen Arrays
        IsPosGreaterThanArrayLength = AdjustedPos > lengthA({array, Liste}),

        if  % Prüfen ob Pos größer ist als Arraylänge
            IsPosGreaterThanArrayLength == true ->

              % Array mit Nullen befüllen bis Position - 1 erreicht ist um übergebenes Element einzufügen
              {array, NeueList} = fillUpArray({array, Liste}, AdjustedPos),
              {array, liste:insert(NeueList, AdjustedPos, Elem)};

            % Falls Arraylänge größer oder gleich Pos ist
            true ->
              % Bestehendes Element löschen
              NeueListe = liste:delete(Liste, AdjustedPos),

              % Neues Elementeinfügen
              {array, liste:insert(NeueListe, AdjustedPos, Elem)}
        end
  end.

%% array × pos → elem
%% ***************************************** NACH SKIZZE *****************************************************
%% Gibt das Element an der angegebenen Position zurück. Falls die angegebene Position über die aktuel- le
%% Länge hinaus geht, wird 0 zurückgegeben.
%% ***************************************** NACH SKIZZE *****************************************************
getA({array, Liste}, Pos) ->
  if  % Prüfen ob negative Pos übergeben wurde
      Pos < 0 ->
        leeresObjekt;

      % Falls Pos >= 0 ist
      true ->
        % Position anpassen, da Liste an Pos 1 beginnt und Array an Pos 0
        AdjustedPos = Pos + 1,

        % Ergebnis der Abfrage abspeichern
        ArrayLengthGreaterThanOrEqualPos = lengthA({array, Liste}) >= AdjustedPos,

        if  % Prüfen ob die Arraylänge größer oder gleich Pos ist
            ArrayLengthGreaterThanOrEqualPos == true ->

              % Element zurückgeben
              liste:retrieve(Liste, AdjustedPos);

            % Falls
            true ->
              % 0 für nicht beschriebene Position zurück geben, da Pos größer als Arraylength
              0
         end
  end.

%% array → pos
%% ***************************************** NACH SKIZZE *****************************************************
%% Gibt die Länge der internen Liste zurück.
%% ***************************************** NACH SKIZZE *****************************************************
lengthA({array, Liste}) ->
  liste:laenge(Liste).

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

%% Befüllt das übergebene Array mit Nullen bis zur übergebenen Position
%% @param Array - Das Array, welches befüllt werden soll
%% @param Pos -  Die Position bis zu welcher aufgefüllt werden soll
fillUpArray({array, Liste}, Pos) ->
  % Aktuelle Arraylänge ermitteln
  CurrentLength = liste:laenge(Liste),

  % Anzahl einzufügender Nullen berechnen
  FillUpCounter = (Pos - 1) - CurrentLength,

  % Nullen auffüllen
  fillUpArrayR(Liste, FillUpCounter).

% Rekursive Methode um dem übergebenen Array um die Anzahl FillUpCounter Nullen hinzuzufügen
<<<<<<< HEAD
fillUpArrayR({array, Liste}, 0) ->
  {array, Liste};
fillUpArrayR({array, Liste}, FillUpCounter) ->
  NewList = liste:create(),
  ListWithZero = liste:insert(NewList, 1, 0),
  fillUpArrayR(liste:concat({array, Liste}, ListWithZero), FillUpCounter - 1).
=======
fillUpArrayR(Liste, 0) ->
  {array, Liste};
fillUpArrayR(Liste, FillUpCounter) ->
  NewList = liste:create(),
  ListWithZero = liste:insert(NewList, 1, 0),
  fillUpArrayR(liste:concat(Liste, ListWithZero), FillUpCounter - 1).
>>>>>>> FETCH_HEAD
