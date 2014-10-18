%% ======== ANFORDERUNGEN =========

%% Soll mit einem in-Stack und out-Stack realisiert werden

-module(schlange).

%% API
-export([createQ/0, front/1, enqueue/2, dequeue/1, isEmpty/1]).

%% ∅ → queue
createQ() ->
  InStack = liste:create(),
  OutStack = liste:create(),
  [InStack, OutStack].

%% queue -> elem
front(Queue) ->
  notImplementedYet.

%% queue x elem -> queue
enqueue(Queue, Elem) ->
  notImplementedYet.

%% queue -> queue
dequeue(Queue) ->
  notImplementedYet.

%% queue -> bool
isEmpty(Queue) ->
  notImplementedYet.
