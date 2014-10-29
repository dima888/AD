%=================================================================================================================================================
%                                              Vorgegebene Schnittstellen der ADT
%=================================================================================================================================================

% Der Stack besteht aus einem Typ und unserer Liste. Dabei repräsentiert das zuletzt eingefügte Ele- ment
% das oberste Element des Stacks.

-module(stack).

%% API
-export([createS/0, push/2, pop/1, top/1, isEmptyS/1]).

%% ∅ → stack
% ***************************************** NACH SKIZZE *****************************************************
% Erzeugt eine neue Instanz des Tupels mit einer leeren Liste
% ***************************************** NACH SKIZZE *****************************************************
createS() ->
  {stack, liste:create()}.

%% stack × elem → stack
% ***************************************** NACH SKIZZE *****************************************************
% Fügt ein Element am Ende der Liste ein
% ***************************************** NACH SKIZZE *****************************************************
push({stack, Liste}, Elem) ->
  % Länge der Liste ermitteln und um 1 inkrementieren für nächstes Element
  Pos = liste:laenge(Liste) + 1,
  {stack, liste:insert(Liste, Pos, Elem)}.

%% stack → stack
% ***************************************** NACH SKIZZE *****************************************************
% Entfernt das zuletzt hinzugefügte Element vom Stack und gibt diesen zurück. Beim leeren Stack pas- siert nichts.
% ***************************************** NACH SKIZZE *****************************************************
pop({stack, Liste}) ->
  % Letztes Element aus der Liste, oberstes aus dem Stack entfernen
  Pos = liste:laenge(Liste),
  {stack, liste:delete(Liste, Pos)}.

%% stack → elem
% ***************************************** NACH SKIZZE *****************************************************
% Gibt das zuletzt hinzugefügte Element des Stacks zurück (ohne den Stack zu verändern).
% Ist der Stack leer, passiert nichts.
% ***************************************** NACH SKIZZE *****************************************************
top({stack, Liste}) ->
  Pos = liste:laenge(Liste),
  liste:retrieve(Liste, Pos).

%% stack → bool
% ***************************************** NACH SKIZZE *****************************************************
% Der Stack ist leer, wenn die interne Liste leer ist.
% ***************************************** NACH SKIZZE *****************************************************
isEmptyS({stack, Liste}) ->
  liste:isEmpty(Liste).