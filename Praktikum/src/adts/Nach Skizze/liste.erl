%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

% Die Liste ist ein Tupel, welches aus einem Typidentifier und einer Subliste besteht. Eine Subliste ist
% wiederum ein Tupel, welches entweder leer ist, um das Ende der Liste zu symbolisieren, oder aus einem
% beliebigen Element und einer weiteren Subliste besteht. Die Subliste ist also immer wieder in sich
% geschachtelt, bis das Ende der Liste erreicht ist.

-module(liste).

%% API
-export([create/0, isEmpty/1, laenge/1, insert/3, delete/2, find/2, retrieve/2, concat/2]).

%% ∅ → list
% ***************************************** NACH SKIZZE *****************************************************
% Erstellt eine Instanz von dem Listentupel mit einer leeren Subliste.
% Struktur festgelegt durch Skizze: {TYP, {}}
% ***************************************** NACH SKIZZE *****************************************************
create() ->
  {liste, {}}.

%% list → bool
% ***************************************** NACH SKIZZE *****************************************************
% Es wird geprüft, ob die oberste, also erste, Subliste im Tupel die leere Subliste ist.
% ***************************************** NACH SKIZZE *****************************************************
isEmpty({liste, {}}) ->
  true;
isEmpty({liste, _Elems}) ->
  false.

%% list → int
% ***************************************** NACH SKIZZE *****************************************************
% Die Subliste wird durchiteriert, bis die leere Subliste erreicht ist. Die Länge der Liste der entspricht 
% der Anzahl von Iterationsschritten.
% ***************************************** NACH SKIZZE *****************************************************
laenge({liste, Elems}) ->
  calculateLength(Elems, 0).

%% list × pos × elem → list
% ***************************************** NACH SKIZZE *****************************************************
% Es wird über die Liste iteriert. Bei jedem Iterationsschritt wird das aktuelle Element 
% der Ausgangsliste der Ergebnisliste angefügt. Falls man sich an der gewünschten Position in der 
% Ausgangsliste befindet, werden zuerst das einzufügende Element und anschließend das aktuelle Element 
% der Ausgangsliste an die Ergebnisliste gehängt. Ab diesem Punkt werden nur noch die restlichen Elemente 
% der Aus- gangsliste angefügt. Falls sich der Index der Position, an dem das Element eingefügt werden 
% sollte, außerhalb der Länge der Liste befindet, wird das Element einfach an das Ende der Liste angefügt.
% ***************************************** NACH SKIZZE *****************************************************
insert({liste, Elems}, Pos, Elem) ->
  % Element hinzufügen
  {liste, insertElem(Elems, Elem, Pos, 1, false)}.

%% list × pos → list
% ***************************************** NACH SKIZZE *****************************************************
% Delete arbeitet ähnlich wie insert, der Unterschied liegt darin, dass anstatt des Einfügens eines neu- en 
% Elements, wird das Element am gewünschten Index ausgelassen und einfach übergangen. Danach läuft das 
% anfügen der Elemente normal weiter.
% ***************************************** NACH SKIZZE *****************************************************
delete({liste, Elems}, Pos) ->
  {liste, deleteElem(Elems, Pos, 1)}.

%% list × elem → pos
% ***************************************** NACH SKIZZE *****************************************************
% Es wird so lange über die Liste iteriert, bis das aktuelle Element der Liste dem gesuchten Element 
% entspricht. Zurückgegeben wird die Anzahl notwendiger Iterationsschritte, um das Element zu fin- den, 
% die der Position des Elements in der Liste entspricht.
% ***************************************** NACH SKIZZE *****************************************************
find({liste, Elems}, Elem) ->
  findPosition(Elems, Elem, 1).

%% list × pos → elem
% ***************************************** NACH SKIZZE *****************************************************
% Gibt das Element, das an der angegebenen Position in der Liste steht, zurück. Der Index pos ent- spricht 
% der Anzahl Iterationsschritten, die notwendig sind, um zur gewünschten Stelle in der Liste zu gelangen, 
% von der man das Element zurückgibt.
% ***************************************** NACH SKIZZE *****************************************************
retrieve({liste, Elems}, Pos) ->
  retrieveElement(Elems, Pos).

%% list × list → list
% ***************************************** NICHT NACH SKIZZE *****************************************************
% Es wird die erste Liste auf einen Iterator geschrieben. Danach wird die zweite Liste mit dem gleichen 
% Verfahren darüber gesetzt.
% *** Auf einen Iterator wurde verzichtet, es wurde nur Rekursion verwendet ***
% ***************************************** NICHT NACH SKIZZE *****************************************************
concat({liste, Elems1}, {liste, Elems2}) ->
  concatLists(Elems1, Elems2).

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

%% ***************************************** NACH SKIZZE *****************************************************
%% Durch Skizze festgelegt: Liste durchlaufen bis leere Subliste erreicht
%% ***************************************** NACH SKIZZE *****************************************************
%% Berechnet die Länge der übergebenen Liste
%% @param Liste - Die Liste dessen länge bestimmt werden soll
%% @param Counter - Zähler für die Listenelemente
calculateLength({}, Counter) ->
  Counter;
calculateLength({_First, Second}, Counter) ->
  calculateLength(Second, Counter + 1).

%% ***************************************** NACH SKIZZE *****************************************************
%% Abbruchbedingung laut Skizze: Subliste leer => {}
%% ***************************************** NACH SKIZZE *****************************************************
%% Zum einfügen eines Elementes in der Liste
%% @param Liste - Die Liste in welche eingefügt werden soll
%% @param Elem - Das Element, welches eingefügt werden soll
%% @param Pos - Die Position an welche das Element eingefügt werden soll
%% @param CurrentPos - Aktuelle Anzahl der Rekursionen
%% @param Result - Die Resultliste
%% @param Flag - Ein Flag zum symbolisieren ob das Element an Pos eingefügt wurde
insertElem({}, _Elem, _Pos, _CurrentPos, ElemAdded) when ElemAdded == true ->
  {};
insertElem({}, Elem, _Pos, _CurrentPos, ElemAdded) when ElemAdded == false ->
  {Elem, {}};
insertElem({CurrentElem, NextElem}, Elem, Pos, CurrentPos, _ElemAdded) when Pos == CurrentPos ->
  {Elem, {CurrentElem, insertElem(NextElem, Elem, Pos, CurrentPos + 1, true)}};
insertElem({CurrentElem, NextElem}, Elem, Pos, CurrentPos, ElemAdded) ->
  {CurrentElem, insertElem(NextElem, Elem, Pos, CurrentPos + 1, ElemAdded)}.

%% ***************************************** NACH SKIZZE *****************************************************
%% Abbruchbedingung laut Skizze: Subliste leer => {}
%% ***************************************** NACH SKIZZE *****************************************************
%% Zum einfügen eines Elementes in der Liste
%% @param Liste - Die Liste in welche eingefügt werden soll
%% @param Pos - Die Position an welcher das Element entfernt werden soll
%% @param CurrentPos - Aktuelle Anzahl der Rekursionen
deleteElem({}, _Pos, _CurrentPos) ->
  {};
deleteElem({_CurrentElem, {}}, Pos, CurrentPos) when Pos == CurrentPos ->
  {};
deleteElem({_CurrentElem, {NextElem, NextNextElem}}, Pos, CurrentPos) when Pos == CurrentPos ->
  {NextElem, deleteElem(NextNextElem, Pos, CurrentPos + 1)};
deleteElem({CurrentElem, NextElem}, Pos, CurrentPos) ->
  {CurrentElem, deleteElem(NextElem, Pos, CurrentPos + 1)}.

%% Sucht die Position des übergebenen Elements in Elems
%% @param Elems - Die Liste ohne Typ in der gesucht werden soll
%% @param Elem - Das Element, nach dem gesucht werden soll
%% @param Counter - Zähler der die Iterationsschritte zählt
findPosition({}, _Elem, _Counter) ->
%% ***************************************** NACH SKIZZE *****************************************************
%% Bei find wird eine unmögliche Position zurückgeben, da die Liste aus Indexen größer also 0 theoretisch
%% bestehen kann, wäre es eine Zahl die kleiner/gleich 0 ist
%% ***************************************** NACH SKIZZE *****************************************************
  -1;
findPosition({CurrentElem, _NextElem}, Elem, Counter) when CurrentElem == Elem ->
  Counter;
findPosition({_CurrentElem, NextElem}, Elem, Counter) ->
  findPosition(NextElem, Elem, Counter + 1).

%% ***************************************** NACH SKIZZE *****************************************************
%% Der Index pos ent- spricht der Anzahl Iterationsschritten, die notwendig sind, um zur gewünschten Stelle
%% in der Liste zu gelangen
%% ***************************************** NACH SKIZZE *****************************************************
%% Sucht nach dem Element an der übergebenen Position
%% @param Liste - Die Liste in der gesucht werden soll
%% @param Pos - Die Position an welcher sich das Element befinden soll
%% @param Counter - Zähler für die Rekursionsschritte
retrieveElement(Elems, Pos) ->
  % Abfrage Ergebnis abspeichern
  IsPosGreaterThanListLengthOrLessThenZero = (Pos > liste:laenge({liste, Elems})) or (Pos < 1),

  if
  % Pos > als Listenlänge oder < 1
    IsPosGreaterThanListLengthOrLessThenZero == true ->
      %% ***************************************** NACH SKIZZE *****************************************************
      %% wir haben bei allen aufgeführten Funktionen (bis auf find) dann an eine leeres Objekt gedacht, weil wir da
      %% der Meinung waren, dass das noch ziemlich oberflächlich ist und nicht zu nah an einer Implementation steht,
      %% trotzdem jedoch eine eindeutige Angabe ist. Wobei dann die Frage wäre, ob das spezifisch genug ist, oder
      %% man noch weiter in das Detail gehen soll
      %% ***************************************** NACH SKIZZE *****************************************************
      leeresObjekt;

  % Pos <= Listenlänge
    true ->
      retrieveElementR(Elems, Pos, 1)
  end.
retrieveElementR({CurrentElem, _NextElem}, Pos, Counter) when Pos == Counter ->
  CurrentElem;
retrieveElementR({_CurrentElem, NextElem}, Pos, Counter) ->
  retrieveElementR(NextElem, Pos, Counter + 1).

%% ***************************************** NICHT NACH SKIZZE *****************************************************
%% Es wird die erste Liste auf einen Iterator geschrieben. Danach wird die zweite Liste mit dem gleichen
%% Verfahren darüber gesetzt.
%% **** Es wurde auf einen Iterator (Zwischenspeicher) verzichtet und rekursiv gelöst ****
%% ***************************************** NICHT NACH SKIZZE *****************************************************
%% Konkatiniert 2 Listen
%% @param Liste1 - Die erste Liste die Konkatiniert werden soll
%% @param Liste2 - Die zweite Liste, die mit der ersten konkatiniert werden soll
concatLists({}, {}) ->
  {};
concatLists({CurrentElem, NextElem}, List2) ->
  {CurrentElem, concatLists(NextElem, List2)};
concatLists({}, {CurrentElem, NextElem}) ->
  {CurrentElem, concatLists({}, NextElem)}.