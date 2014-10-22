%% ======== ANFORDERUNGEN =========

%% Soll mit einem in-Stack und out-Stack realisiert werden

%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

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

        if  % Prüfen ob Instack ebenfalls leer ist
            IsInStackEmpty == true ->
              % TODO: Zu klären was in diesem Fall zurück gegeben werden soll
              todo;

            true -> % Der Instack ist nicht leer, also Element umverlagern in den Outstack
                    todo
        end;

      true -> % Der Outstack ist nicht leer also oberstes (älteste durch Umverlagerung) Element zurück geben
              stack:top(OutStack)
  end.

%% queue x elem -> queue
enqueue([InStack, OutStack], Elem) ->
  [stack:push(InStack, Elem), OutStack].

%% queue -> queue
dequeue([InStack, OutStack]) ->
  notImplementedYet.

%% queue -> bool
isEmpty([InStack, OutStack]) ->
  % Falls Instack und Outstack leer sind ist die Queue leer
  liste:isEmpty(InStack) and liste:isEmpty(OutStack).

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

shiftFromInStackToOutStack(InStack, OutStack) ->
  notImplementedYet.