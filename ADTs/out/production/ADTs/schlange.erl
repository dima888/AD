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
                    [NewInStack, NewOutStack] = shiftFromInStackToOutStack([InStack, OutStack]),
                    stack:top(NewOutStack)
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

%% Verlagert die Elemente vom Instack um in den Outstack
shiftFromInStackToOutStack([InStack, OutStack]) ->
  % Rekursive Methode für das Umverlagern, der letzte Parameter ist die Abbruchbedingung
  shiftFromInStackToOutStackR(InStack, OutStack, false).

shiftFromInStackToOutStackR(InStack, OutStack, true) ->
  % Modifizierte Queue zurück geben
  [InStack, OutStack];
shiftFromInStackToOutStackR(InStack, OutStack, false) ->
  %io:format("***Anfang*** InStack: ~p~n", [InStack]),
  %io:format("***Anfang*** OutStack: ~p~n", [OutStack]),

  % Ergebnis der Abfrage abspeichern
  IsInStackEmpty = stack:isEmptyS(InStack),

  if  % Falls der Instack leer ist, wurden alle Elemente umverlagert und der Durchlauf soll beendet werden
      IsInStackEmpty == true ->
        % Rekursion abbrechen -> signalisiert durch das true
        shiftFromInStackToOutStackR(InStack, OutStack, true);

      % Der Stack ist nicht leer, also oberstes Element aus Instack umverlagern und rekursiv aufrufen
      true ->
        % Oberstes Element abspeichern
        TopElementOfInStack = stack:top(InStack),

        % OutStack mit hinzugefügtem Element
        NewOutStack = stack:push(OutStack, TopElementOfInStack),

        % Umverlagertes Element entfernen
        NewInStack = stack:pop(InStack),

        %io:format("***Ende*** NewInStack: ~p~n", [NewInStack]),
        %io:format("***Ende*** NewOutStack: ~p~n", [NewOutStack]),

        % Das oberste Element vom Instack löschen und dem Outstack hinzufügen und weiter Umverlagern
        shiftFromInStackToOutStackR(NewInStack, NewOutStack, false)
  end.