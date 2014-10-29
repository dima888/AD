%% ======== ANFORDERUNGEN =========

%% Soll mit einem in-Stack und out-Stack realisiert werden

%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

-module(schlangeOLD).

%% API
-export([createQ/0, front/1, enqueue/2, dequeue/1, isEmpty/1]).

%% ∅ → queue
createQ() ->
  InStack = listeOLD:create(),
  OutStack = listeOLD:create(),
  [InStack, OutStack].

%% queue -> elem
front([InStack, OutStack]) ->
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = listeOLD:isEmpty(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = listeOLD:isEmpty(InStack),

        if  % Prüfen ob Instack ebenfalls leer ist
            IsInStackEmpty == true ->
              % TODO: Zu klären was in diesem Fall zurück gegeben werden soll
              todo;

            % Der Instack ist nicht leer, also Element umverlagern in den Outstack
            true ->
              [NewInStack, NewOutStack] = shiftFromInStackToOutStack([InStack, OutStack]),
              stackOLD:top(NewOutStack)
        end;

      true -> % Der Outstack ist nicht leer also oberstes (älteste durch Umverlagerung) Element zurück geben
              stackOLD:top(OutStack)
  end.

%% queue x elem -> queue
enqueue([InStack, OutStack], Elem) ->
  [stackOLD:push(InStack, Elem), OutStack].

%% queue -> queue
dequeue([InStack, OutStack]) ->
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = stackOLD:isEmptyS(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = stackOLD:isEmptyS(InStack),

        if  % Prüfen ob der Instack ebenfalls leer ist
            IsInStackEmpty == true ->

              % Beide Stacks sind leer, nicht modifizierte (leere Queue) zurück geben
              [InStack, OutStack];

            % Falls der Instack nicht leer ist, muss umsortiert werden
            true ->
              [NewInStack, NewOutStack] = shiftFromInStackToOutStack([InStack, OutStack]),

              % Oberstes Element entfernen und Queue zurück geben
              [NewInStack, stackOLD:pop(NewOutStack)]
        end;

      % Falls der Outstack nicht leer ist, oberstes Element entfernen
      true ->
        [InStack, stackOLD:pop(OutStack)]
  end.

%% queue -> bool
isEmpty([InStack, OutStack]) ->
  % Falls Instack und Outstack leer sind ist die Queue leer
  listeOLD:isEmpty(InStack) and listeOLD:isEmpty(OutStack).

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
  IsInStackEmpty = stackOLD:isEmptyS(InStack),

  if  % Falls der Instack leer ist, wurden alle Elemente umverlagert und der Durchlauf soll beendet werden
      IsInStackEmpty == true ->
        % Rekursion abbrechen -> signalisiert durch das true
        shiftFromInStackToOutStackR(InStack, OutStack, true);

      % Der Stack ist nicht leer, also oberstes Element aus Instack umverlagern und rekursiv aufrufen
      true ->
        % Oberstes Element abspeichern
        TopElementOfInStack = stackOLD:top(InStack),

        % OutStack mit hinzugefügtem Element
        NewOutStack = stackOLD:push(OutStack, TopElementOfInStack),

        % Umverlagertes Element entfernen
        NewInStack = stackOLD:pop(InStack),

        %io:format("***Ende*** NewInStack: ~p~n", [NewInStack]),
        %io:format("***Ende*** NewOutStack: ~p~n", [NewOutStack]),

        % Das oberste Element vom Instack löschen und dem Outstack hinzufügen und weiter Umverlagern
        shiftFromInStackToOutStackR(NewInStack, NewOutStack, false)
  end.