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
%% ***************************************** NACH SKIZZE *****************************************************
%% Erzeugt eine neue Instanz des Tupels mit zwei leeren Stacks (IN & OUT).
%% ***************************************** NACH SKIZZE *****************************************************
createQ() ->
  InStack = stack:createS(),
  OutStack = stack:createS(),
  {queue, {InStack, OutStack}}.

%% queue -> elem
%% ***************************************** NACH SKIZZE *****************************************************
%% Gibt das erste Element der Queue (--> oberstes Element des Out-Stacks) zurück, ohne es zu entfer- nen.
%% ***************************************** NACH SKIZZE *****************************************************
front({queue, {InStack, OutStack}}) ->
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = stack:isEmptyS(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = stack:isEmptyS(InStack),

        if  % Prüfen ob Instack ebenfalls leer ist
            IsInStackEmpty == true ->
              leeresObjekt;

            % Der Instack ist nicht leer, also Element umverlagern in den Outstack
            true ->
              {_NewInStack, NewOutStack} = shiftFromInStackToOutStack({InStack, OutStack}),
              stack:top(NewOutStack)
        end;

      true -> % Der Outstack ist nicht leer also oberstes (älteste durch Umverlagerung) Element zurück geben
              stack:top(OutStack)
  end.

%% queue x elem -> queue
%% ***************************************** NACH SKIZZE *****************************************************
%% Reiht das Element am Ende der Queue ein. D.h., es wird auf dem In-Stack abgelegt.
%% ***************************************** NACH SKIZZE *****************************************************
enqueue({queue, {InStack, OutStack}}, Elem) ->
  {queue, {stack:push(InStack, Elem), OutStack}}.

%% queue -> queue
%% ***************************************** NACH SKIZZE *****************************************************
%% Entfernt das erste Element der Queue, also das oberste Element des Out-Stacks und gibt sie zurück.
%% ***************************************** NACH SKIZZE *****************************************************
dequeue({queue, {InStack, OutStack}}) ->
  % Ergebnis der Abfrage speichern
  IsOutStackEmpty = stack:isEmptyS(OutStack),

  if  % Prüfen ob der Outstack leer ist
      IsOutStackEmpty == true ->

        % Ergebnis der Abfrage speichern
        IsInStackEmpty = stack:isEmptyS(InStack),

        if  % Prüfen ob der Instack ebenfalls leer ist
            IsInStackEmpty == true ->

              % Beide Stacks sind leer, nicht modifizierte (leere Queue) zurück geben
              {queue, {InStack, OutStack}};

            % Falls der Instack nicht leer ist, muss umsortiert werden
            true ->
              {NewInStack, NewOutStack} = shiftFromInStackToOutStack({InStack, OutStack}),

              % Oberstes Element entfernen und Queue zurück geben
              {queue, {NewInStack, stack:pop(NewOutStack)}}
        end;

      % Falls der Outstack nicht leer ist, oberstes Element entfernen
      true ->
        {queue, {InStack, stack:pop(OutStack)}}
  end.

%% queue -> bool
%% ***************************************** NACH SKIZZE *****************************************************
%% Prüft, ob sowohl In- und Out-Stack leer sind.
%% ***************************************** NACH SKIZZE *****************************************************
isEmpty({queue, {InStack, OutStack}}) ->
  % Falls Instack und Outstack leer sind ist die Queue leer
  stack:isEmptyS(InStack) and stack:isEmptyS(OutStack).

%=================================================================================================================================================
%                                                       HILFS FUNKTIONEN
%=================================================================================================================================================

%% Verlagert die Elemente vom Instack um in den Outstack
shiftFromInStackToOutStack({InStack, OutStack}) ->
  % Rekursive Methode für das Umverlagern, der letzte Parameter ist die Abbruchbedingung
  shiftFromInStackToOutStackR(InStack, OutStack, false).

shiftFromInStackToOutStackR(InStack, OutStack, true) ->
  % Modifizierte Queue zurück geben
  {InStack, OutStack};
shiftFromInStackToOutStackR(InStack, OutStack, false) ->
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

        % Das oberste Element vom Instack löschen und dem Outstack hinzufügen und weiter Umverlagern
        shiftFromInStackToOutStackR(NewInStack, NewOutStack, false)
  end.