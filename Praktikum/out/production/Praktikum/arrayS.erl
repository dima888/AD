%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

% Ein Array besteht aus einem Typ und einer Liste, die standardmäßig leer ist. Das Array hat keine fest-
% gelegte Länge und kann somit immer wachsen, wenn nötig. Das Array beginnt bei der Position 0.

-module(arrayS).

%% API
-export([initA/0, setA/3, getA/2, lengthA/1]).

%% ∅ → array
initA() ->
  {array, liste:create()}.

%% array × pos × elem → array
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
lengthA({array, Liste}) ->
  liste:laenge(Liste).

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

%% Befüllt das übergebene Array mit Nullen bis zur übergebenen Position
fillUpArray({array, Liste}, Pos) ->
  % Aktuelle Arraylänge ermitteln
  CurrentLength = liste:laenge(Liste),

  % Anzahl einzufügender Nullen berechnen
  FillUpCounter = (Pos - 1) - CurrentLength,

  % Nullen auffüllen
  fillUpArrayR({array, Liste}, FillUpCounter).

% Rekursive Methode um dem übergebenen Array um die Anzahl FillUpCounter Nullen hinzuzufügen
fillUpArrayR({array, Liste}, 0) ->
  {array, Liste};
fillUpArrayR({array, Liste}, FillUpCounter) ->
  NewList = liste:create(),
  ListWithZero = liste:insert(NewList, 1, 0),
  fillUpArrayR(liste:concat({array, Liste}, ListWithZero), FillUpCounter - 1).