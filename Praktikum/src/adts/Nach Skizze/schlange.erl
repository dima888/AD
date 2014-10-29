%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

% Eine Queue besteht aus zwei Stacks - einem In-Stack und einem Out-Stack. Beim Hinzufügen eines Elements
% wird dieses im In-Stack abgelegt. Durch die Realisierung über zwei Stacks wird gewährleis- tet, dass
% das zuerst hinzugefügte Element auch als erstes wieder aus der Queue entnommen wird (FIFO-Prinzip).
% Es wird solange auf den In-Stack geschrieben, bis eine Leseoperation auf den Out- Stack ausgeführt wird.
% Dann wird der Inhalt des In-Stacks auf den Out-Stack umgeschichtet, und das erste Element des Out-Stacks
% gelesen. Ist der Out-Stack nicht leer, wird nur das erste Element des Out-Stacks gelesen, ohne den Inhalt
% aus dem In-Stack umzuschichten.

-module(schlange).

%% API
-export([createQ/0, front/1, enqueue/2, dequeue/1, isEmpty/1]).

%% ∅ → queue
createQ() ->
  InStack = stack:createS(),
  OutStack = stack:createS(),
  [InStack, OutStack].

%% queue -> elem
front([InStack, OutStack]) ->
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = stack:isEmptyS(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = stack:isEmptyS(InStack),

        if  % Prüfen ob Instack ebenfalls leer ist
            IsInStackEmpty == true ->
              % TODO: Zu klären was in diesem Fall zurück gegeben werden soll
              todo;

            % Der Instack ist nicht leer, also Element umverlagern in den Outstack
            true ->
              [_NewInStack, NewOutStack] = shiftFromInStackToOutStack([InStack, OutStack]),
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
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = stack:isEmptyS(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = stack:isEmptyS(InStack),

        if  % Prüfen ob der Instack ebenfalls leer ist
            IsInStackEmpty == true ->

              % Beide Stacks sind leer, nicht modifizierte (leere Queue) zurück geben
              [InStack, OutStack];

            % Falls der Instack nicht leer ist, muss umsortiert werden
            true ->
              [NewInStack, NewOutStack] = shiftFromInStackToOutStack([InStack, OutStack]),

              % Oberstes Element entfernen und Queue zurück geben
              [NewInStack, stack:pop(NewOutStack)]
        end;

      % Falls der Outstack nicht leer ist, oberstes Element entfernen
      true ->
        [InStack, stack:pop(OutStack)]
  end.

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