%% ======== ANFORDERUNGEN =========

%% Das Array begintt bei Position 0

%% Das Array arbeitet destruktiv, d.h. wird ein Element an einer vorhandenen Position eingefügt,
%% wird das dort stehende Element überschrieben

%% Die Länge des Arrays wird bestimmt durch die bis zur aktuellen Abfrage größten vorhandenen und
%% explizit beschriebenen Position im array

%% Das Array ist mit 0 initialisiert, d.h. greift man auf eine bisher noch nicht beschriebene Position
%% im Array zu erhält man 0 als Wert

%% Das Array hat keine Größenbeschränkung, d.h. bei der Initialisierung wird keine Größe vorgegeben
-module(arrayS).

%% API
-export([initA/0, setA/3, getA/2, lengthA/1]).

%% ∅ → array
initA() ->
  liste:create().

%% array × pos × elem → array
setA(Array, Pos, Elem) ->
  % TODO: 
  % Prüfen ob an dieser Stelle bereits ein Element existiert
  Obj = getA(Array, Pos),

  if
    % Falls kein Element an dieser Stelle besteht erhalten wir eine 0 zurück
    Obj == 0 ->
      % Element einfügen
      liste:insert(Array, Pos + 1, Elem);
    true ->
      % Bestehendes Element löschen
      liste:delete(Array, Pos + 1),

      % Neues Elementeinfügen
      liste:insert(Array, Pos + 1, Elem)
  end.

%% array × pos → elem
getA(Array, Pos) ->
  % Prüfen ob die länge des Arrays überschritten wird

  Bool = lengthA(Array),

  if
    (Pos < Bool) ->
      % Element zurückgeben
      liste:retrieve(Array, Pos);
    true ->
      % 0 für nicht beschriebene Position zurück geben
      0
  end,
  liste:retrieve(Array, Pos + 1).

%% array → pos
lengthA(Array) ->
  liste:laenge(Array).