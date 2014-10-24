%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

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
isEmpty({liste, Elems}) ->
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
insert({liste, {}}, Pos, Elem) ->
  % Liste ist leer, unmodifiziert zurückgeben
  {liste, {}};
insert({liste, Elems}, Pos, Elem) ->
  % Element hinzufügen
  {liste, insertElem(Elems, Elem, Pos, CurrentPos, {})}.

%% list × pos → list
% ***************************************** NACH SKIZZE *****************************************************
% Delete arbeitet ähnlich wie insert, der Unterschied liegt darin, dass anstatt des Einfügens eines neu- en 
% Elements, wird das Element am gewünschten Index ausgelassen und einfach übergangen. Danach läuft das 
% anfügen der Elemente normal weiter.
% ***************************************** NACH SKIZZE *****************************************************
delete(List, Pos) ->
  notImplementedYet.

%% list × elem → pos
% ***************************************** NACH SKIZZE *****************************************************
% Es wird so lange über die Liste iteriert, bis das aktuelle Element der Liste dem gesuchten Element 
% entspricht. Zurückgegeben wird die Anzahl notwendiger Iterationsschritte, um das Element zu fin- den, 
% die der Position des Elements in der Liste entspricht.
% ***************************************** NACH SKIZZE *****************************************************
find(List, Elem) ->
  notImplementedYet.

%% list × pos → elem
% ***************************************** NACH SKIZZE *****************************************************
% Gibt das Element, das an der angegebenen Position in der Liste steht, zurück. Der Index pos ent- spricht 
% der Anzahl Iterationsschritten, die notwendig sind, um zur gewünschten Stelle in der Liste zu gelangen, 
% von der man das Element zurückgibt.
% ***************************************** NACH SKIZZE *****************************************************
retrieve(List, Pos) ->
  notImplementedYet.

%% list × list → list
% ***************************************** NACH SKIZZE *****************************************************
% Es wird die erste Liste auf einen Iterator geschrieben. Danach wird die zweite Liste mit dem gleichen 
% Verfahren darüber gesetzt.
% ***************************************** NACH SKIZZE *****************************************************
concat(List1, List2) ->
  notImplementedYet.

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

%% Ermittelt Rekursiv die Länge der übergebenen Liste
% ************ Durch Skizze festgelegt: Liste durchlaufen bis leere Subliste erreicht *************
calculateLength({}, Counter) ->
  Counter;
calculateLength({First, Second}, Counter) ->
  calculateLength(Second, Counter + 1).

%% Fügt der übergebenen Liste das übergebene Element an der übergebenen Pos zu
% ************ Abbruchbedingung laut Skizze: Subliste leer => {} *************
insertElem({}, Elem, Pos, CurrentPos, Result) ->
  Result;
insertElem({First, Second}, Elem, Pos, CurrentPos, Result) when Pos == CurrentPos ->
  % TODO: Irgendwie Elemente hinzufügen
  ElemAdded = append_element(Result, Elem),
  insertElem(Second, Elem, Pos, CurrentPos, append_element(ElemAdded, {}));  
insertElem({First, Second}, Elem, Pos, CurrentPos, Result) ->
  insertElem(Second, Elem, Pos, CurrentPos + 1, append_element(Result, {First, {}})).  
  



