%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

-module(stack).

%% API
-export([createS/0, push/2, pop/1, top/1, isEmptyS/1]).

%% ∅ → stack
createS() ->
  liste:create().

%% stack × elem → stack
push(Stack, Elem) ->
  % Länge der Liste ermitteln und um 1 inkrementieren für nächstes Element
  Pos = liste:laenge(Stack) + 1,
  liste:insert(Stack, Pos, Elem).

%% stack → stack
pop(Stack) ->
  % Letztes Element aus der Liste, oberstes aus dem Stack entfernen
  Pos = liste:laenge(Stack),
  liste:delete(Stack, Pos).

%% stack → elem
top(Stack) ->
  Pos = liste:laenge(Stack),
  liste:retrieve(Stack, Pos).

%% stack → bool
isEmptyS(Stack) ->
  liste:isEmpty(Stack).