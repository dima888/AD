%%%-------------------------------------------------------------------
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%

%%% AVL-Baum-Struktur: [ ExecuteCounter, [RotationLeftCounter, RotationRightCounter], [Key, [ChildLeftFromKey, ChildRightFromKey], Height, PredecessorKey] ] , ... ]


%%% So ist der AVL-Baum aufgebaut
%%% -------------------------------------------------------------------------------------------
%%% Pos 1: Counter wie oft die Funktion aufgerufen wurden sind, die nach aussen sichtbar sind
%%% Pos 2: Counter fuer die Rotationen links und rechts Example: [2, 1]
%%% Pos 3..n: Node


%%% So ist ein Node aufgebaut
%%% -------------------------------------------------------------------------------------------
%%% Pos 1: Prefix - node
%%% Pos 2: Der Schluessel/Key
%%% Pos 3: [Linkes Kind, Rechtes Kind]
%%% Pos 4: Hoehe des Baumes
%%% Pos 5: Vorgaenger Schluessel/Key; if predecessor == nil -> this.Node = RootNode



%%% @end
%%% Created : 15. Nov 2014 18:09
%%%-------------------------------------------------------------------
-module(avlBaum).

%% API
-export([init/1, einfuegen/2, loeschen/2, linksrotation/2, rechtsrotation/2, doppelLinksrotation/2, doppelRechtsrotation/2,

% Die unteren muessen raus, sind aus Testzwecken drinne
  getLeftChild/2, isAvailable/2

]).

%% Erstellt einen AVL-Baum mit einen Wurzel Knoten
%% @param Integer Root - Die Wurzel des AVL Baumes
init(Key) ->
  RootNode = [node, Key, [nil, nil], 1, nil],
  graphviz:graph("G"),
  File = "/Users/foxhound/Desktop/avlBaum/Tree" ++ utility:toString(1) ++ ".png",
  graphviz:add_node(utility:toString(Key)),
  graphviz:to_file(File, "png"),
  incrementExecution( [ 1, [0, 0], RootNode ] ).


%% Funktion haengt genau ein Knoten an einen Baum an
%% @param avlBaum Tree - Die Datenstruktur des AVL Baumes
%% @param String Key - Das neu hinzugefuegte Element
einfuegen(Tree, Key) ->
% 1 Füge neuen Knoten gemäß der Sortierung als Blatt in den AVL-Baum ein. HIER!!!

% 2 Überprüfe von diesem Blatt ausgehend bottom-up die AVL-Bedingung.

% 3 Führe ggf. an dem Knoten, an dem die Bedingung verletzt wurde, eine
%      Rebalancierung durch (durch entsprechende Rotation).

% 4 Im Unterschied zu gewöhnlichen binären Suchbäumen ist es bei AVL-Bäumen
%       wegen den Rotationen prinzipiell nicht möglich, gleiche Schlüssel immer im
%       rechten (linken) Teilbaum einzufügen (oder dort zu finden).
  todo.

%% Diese Funtion loescht einen Knoten aus einem Baum
%% @param avlBaum Tree - Der AVL-Baum auf dem ein Schluessel entfernt werden soll
%% @param Integer Key - Der zu entfernende Schluessel
%% @return avlBaum - Der modifizierte Baum
loeschen(Tree, Key) ->
  todo.

%% Diese Funktion implementiert die einfache Linksrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
linksrotation(Tree, Key) ->
  todo.

%% Diese Funktion implementiert die einfache Rechtsrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
rechtsrotation(Tree, Key) ->
  todo.

%% Diese Funktion implementiert die doppelte Linksrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
doppelLinksrotation(Tree, Key) ->
  todo.

%% Diese Funktion implementiert die doppelte Rechtsrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
doppelRechtsrotation(Tree, Key) ->
  todo.


%=================================================================================================================================================
%                                                                    Hilfsfunktionen
%=================================================================================================================================================

%% Gib das Element zurueck, wohin der Parameter Elem rangehaengt werden soll!
getParentNode(Tree, Key) ->
  todo.

%% Funktion generiert ein png Bild von diesen ueber Parameter uebergebenen Baum
makePicture(Tree, Path) ->
  % graphviz:graph("G")
  % ........
  % graphviz:delete().
  todo.

%% Funktion balanciert einen alvBaum aus
toBalanceOut(Tree) ->
  todo.


%% Funktion Prueft ob ein Schluessel im Baum enthalten ist!
%% Wenn ja dann true, sonst false
isAvailable(Tree, Key) ->
  [_, _ | NodeList] = Tree,
  Buffer = [X || X <- NodeList, lists:nth(2, X) == Key ],
  BufferLength = length(Buffer),
  if (BufferLength > 0 ) ->
    true;
  true ->
      false
  end.


%% Gibt den linken Knoten von einem Schluessel
%% @return Node
%% ---------------------------------------------------------------------------
getLeftChild(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getLeftChildHelper(Tree, Key, Boolean).

getLeftChildHelper(Tree, Key, Bool) when Bool == false -> keyNotFound;
getLeftChildHelper(Tree, Key, Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [LeftKey, _RightKey], _Height, _KeyTyp] = Node,
  if (LeftKey == nil) ->
    nil;
  true ->
    getNode(Tree, LeftKey)
  end.
%% ---------------------------------------------------------------------------

%% Gibt den rechten Knoten von einem Schluessel
getRightChild(Tree, Key) ->
  todo.

%% Gibt einen gesamten Knoten zu einen Schluessel
getNode(Tree, Key) ->
    [_, _ | NodeList] = Tree,
    Buffer = [ X || X <- NodeList, lists:nth(2, X) == Key ],
    lists:nth(1, Buffer).

%% Erhoeht den Zaehler um 1
incrementExecution(Tree) ->
  [_Head | Tail] = Tree,
  [lists:nth(1, Tree) + 1] ++ Tail.


%% TODO: Funktion gibt den Key zu einem Node

%% TODO: Funktion aendert das linke Kind

%% TODO: Funktion aendert das rechte Kind
