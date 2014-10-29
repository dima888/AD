%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

-module(stackOLD).

%% API
-export([createS/0, push/2, pop/1, top/1, isEmptyS/1]).

%% ∅ → stack
createS() ->
  listeOLD:create().

%% stack × elem → stack
push(Stack, Elem) ->
  % Länge der Liste ermitteln und um 1 inkrementieren für nächstes Element
  Pos = listeOLD:laenge(Stack) + 1,
  listeOLD:insert(Stack, Pos, Elem).

%% stack → stack
pop(Stack) ->
  % Letztes Element aus der Liste, oberstes aus dem Stack entfernen
  Pos = listeOLD:laenge(Stack),
  listeOLD:delete(Stack, Pos).

%% stack → elem
top(Stack) ->
  Pos = listeOLD:laenge(Stack),
  listeOLD:retrieve(Stack, Pos).

%% stack → bool
isEmptyS(Stack) ->
  listeOLD:isEmpty(Stack).