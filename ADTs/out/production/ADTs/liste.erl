%% ======== ANFORDERUNGEN =========

%% Eine ADT Liste ist zu implementieren: als  einfach verkette Liste

%% Die Liste beginnt bei Position 1

%% Die Liste arbeitet nicht destruktiv, d.h. wird ein Element an einer vorhandenen Position eingefügt,
%% wird das dort stehende Element um eine Position verschoben

%% Fehlerbehandlung: sollten nicht vorhandene Elemente gelöscht werden, in der Liste an unmöglicher Stelle
%% eingefügt werden, von einem leeren Stack das oberste Element gelöscht werden etc. ist die Fehlerbehandlung
%% durch "Ignorieren" durchzuführen, d.h. es wird so gehandelt, als wäre die Operation in Ordnung gewesen und z.B.
%% eine nicht modifizierte Datenstruktur zurück gegeben

%=================================================================================================================================================
%                                                           STRUKTUR DER LISTE
% Unsere Struktur ist ganz simpel, sie besteht auf drei Elementiger Liste,
% An erster Position ist der Index des Elementes,
% an zweiter Position ist das Element selbst und
% an dritter Stelle steht das Index des nachfolgenden Elementes.
% Beispiel: [ [1, "hallo", 2 ], [2, "tschuess", ?], ... ]
%=================================================================================================================================================


-module(liste).

%% API
-export([create/0, isEmpty/1, laenge/1, insert/3, delete/2, find/2, retrieve/2, concat/2
                      ]).

%% ∅ → list
create() ->
  [].

%% list → bool
isEmpty([]) ->
  true;
isEmpty(List) ->
  false.

%% list → int
laenge(List) ->
  lengthHelper(List, 0).

%% list × pos × elem → list
insert(List, Pos, Elem) ->
  LastIndex = getLastIndex(List),

  % PRECONDITION, FALLS DIE LISTE NOCH LEER IST
  if ( (List == [] ) and (Pos == 1) ) ->
    [ [Pos, Elem, undefined] ];
    ( (List == [] ) and (Pos /= 1) ) ->
      [];
  % PRECONDITION, ELEMENT HINTEN ANHAENGEN
    (Pos == LastIndex + 1) ->
      modifyIndices(concat(List, [ [Pos, Elem, undefined] ] ));
  true ->

   % PRECONDION, FALLS DIE POSITION NICHT LEGETIM IST
    if ( (Pos > LastIndex) or (Pos < 1) ) ->
      List;
    true ->
      [Head | Tail] = List,

      % Alle Elemente vor der neuen Position ermitteln
      ListBeforeElem = insertHelperbefore(Head, Tail, Pos, [], 1),

      % Neues Element Reinhaengen
       HalfList = concat(ListBeforeElem, [ [Pos, Elem, undefined] ] ),

      % Alle Elemente Nach den neuen Element hollen
       ListAfterElem = insertHelperAfter(Head, Tail, Pos, [], 1),

      % Liste zusammen bauen und mit den modifizierten Indices zurueck geben
      modifyIndices(concat(HalfList, ListAfterElem ))
    end
  end.

%% list × pos → list
delete([], Pos) ->
  [];
delete(List, Pos) ->
  modifyIndices(deleteHelper(List, Pos)).

%% list × elem → pos
find(List, Elem) ->
  findHelper(List, Elem).

%% list × pos → elem
retrieve(List, Pos) ->
  retrieveHelper(List, Pos).

%% list × list → list
concat(List1, List2) ->
  % PRECONDITION, FALLS DIE LISTE NICHT GETEILT WERDEN KANN
  if (List1 == []) ->
    concatHelper([], List2);
  true ->
  [Head | Tail] = List1,
  % Listen konkateniert
  concatHelper([Head | Tail], List2)
  end.

%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================

%% Das ist eine Hilfsfunktion fuer die ermittlung einer laenge der Liste
lengthHelper([], Counter) ->
  Counter;
lengthHelper(List, Counter) ->
  [_ | Tail] = List,
  lengthHelper(Tail, Counter + 1).

%% Gibt Alle Elemente vor der Position eines Elements
insertHelperbefore(Head, Tail, Pos, Buffer, Counter) ->
  if (Tail == []) ->
    Buffer;
  true ->
  % Neue Teilung von unseren Tail
    [SecondElem | Rest] = Tail,

    % Abbruchbedingung
    % if (Index == Pos) ->
    if (Counter == Pos) ->
     Buffer;
    true ->
      insertHelperbefore(SecondElem, Rest, Pos, Buffer ++ [Head], Counter + 1)
    end
  end.

insertHelperAfter(Head, Tail, Pos, Buffer, Counter) ->
  if (Tail == []) ->
    concat(Buffer, [Head]);
  true ->
    % Neue Teilung von unseren Tail
    [SecondElem | Rest] = Tail,

    % Abbruchbedingung
    %if (Index >= Pos) ->
    if (Counter >= Pos) ->
      insertHelperAfter(SecondElem, Rest, Pos, concat(Buffer, [Head]), Counter + 1);
    true ->
      insertHelperAfter(SecondElem, Rest, Pos, Buffer, Counter + 1)
    end
  end.

%% Diese Funktion gibt den groessten Index in einer Liste
getLastIndex(List) ->
  % PRECONDITION FALLS DIE LISTE LEER IST
  if (List == []) ->
    0;
  true ->
  [Head | Tail] = List,
  getLastIndex(Head, Tail, 1)
  end.
getLastIndex(_, [], Counter) -> Counter;
getLastIndex(_, Tail, Counter) ->
  [SecondElem | Rest] = Tail,
  getLastIndex(SecondElem, Rest, Counter + 1).

% Diese Funktion fuegt zwei Liste zusammen
concatHelper([], List2) ->
  List2;
concatHelper([H | T], List2) ->
  [ H | concatHelper(T, List2) ].

%Lieft den Index zur einem Element zurueck
findHelper(List, Elem) ->
  [Head | Tail] = List,
  findHelper(Head, Tail, Elem).
findHelper(Head, [], Elem) ->
  [Index, Element, _] = Head,
  if (Element == Elem) ->
    Index;
    true ->
      elementExestiertNicht
  end;
findHelper(Head, Tail, Elem) ->
  % Abbruchbedingung definieren
  [Index, Element, _] = Head,
  if (Element == Elem) ->
    Index;
  true ->
    [SecondElem | Rest] = Tail,
    findHelper(SecondElem, Rest, Elem)
  end.

%% Diese Funktion errechnet die Indeces neu
modifyIndices([]) -> [];
modifyIndices(List) ->
  [Head | Tail] = List,
  mofifyIndices(Head, Tail, 1, []).
mofifyIndices(Head, [], Counter, Result) ->
  [_, Element, _] = Head,

  %Das ist die Stelle, wohin das letzte Element zeigt, naemlich auf undefinded
  concat(Result, [ [Counter, Element, undefined] ]);
mofifyIndices(Head, Tail, Counter, Result) ->
  [_, Element, _] = Head,
  [SecondHead | Rest] = Tail,
  mofifyIndices(SecondHead, Rest, Counter + 1, concat(Result, [ [Counter, Element, Counter + 1] ])).

% Entfernt ein Element von einer bestimmten Position in einer Liste
deleteHelper(List, Pos) ->
  [Head | Tail] = List,
  deleteHelper(Head, Tail, Pos, []).
deleteHelper(Head, [], Pos, Result) ->
  [Index, Element, SuccessorIndex] = Head,
  if (Pos /= Index) ->
    concat(Result, [ [Index, Element, SuccessorIndex] ]);
    true ->
      Result
  end;
deleteHelper(Head, Tail, Pos, Result) ->
  [SecondHead | Rest] = Tail,
  [Index, Element, SuccessorIndex] = Head,
  if (Pos /= Index) ->
    deleteHelper(SecondHead, Rest, Pos, concat(Result, [ [Index, Element, SuccessorIndex] ] ));
  true ->
    deleteHelper(SecondHead, Rest, Pos, Result)
  end.

%% Diese Funktion findet ein Element zur einer Position
retrieveHelper(List, Pos) ->
  [Head | Tail] = List,
  retrieveHelper(Head, Tail, Pos).
retrieveHelper(Head, [], Pos) ->
  [Index, Element, _] = Head,
  if (Index == Pos) ->
    Element;
    true ->
      positionExestiertNicht
  end;
retrieveHelper(Head, Tail, Pos) ->
  % Abbruchbedingung definieren
  [Index, Element, _] = Head,
  if (Index == Pos) ->
    Element;
    true ->
      [SecondElem | Rest] = Tail,
      retrieveHelper(SecondElem, Rest, Pos)
  end.