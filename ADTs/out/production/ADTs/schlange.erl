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
front([InStack, OutStack]) ->
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = liste:isEmpty(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = liste:isEmpty(InStack),

        if  % Falls der Outstack leer ist, prüfen ob Instack ebenfalls leer ist
            IsInStackEmpty == true ->
              todo;

            true -> % Der Instack ist nicht leer, also Element umverlagern in den Outstack
                    todo
        end;

      true -> % Der Outstack ist nicht leer also vorderstes (ältestes) Element zurück geben
              todo

  end.

%% queue x elem -> queue
enqueue(Queue, Elem) ->
  notImplementedYet.

%% queue -> queue
dequeue(Queue) ->
  notImplementedYet.

%% queue -> bool
isEmpty([InStack, OutStack]) ->
  % Falls Instack und Outstack leer sind ist die Queue leer
  liste:isEmpty(InStack) and liste:isEmpty(OutStack).