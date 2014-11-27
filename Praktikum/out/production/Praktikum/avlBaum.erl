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
  getLeftChild/2, isAvailable/2, getRootNode/1, setLeftChildKey/3, setRightChildKey/3, getNode/2

]).

%% Erstellt einen AVL-Baum mit einen Wurzel Knoten
%% @param Integer Root - Die Wurzel des AVL Baumes
init(Key) ->
  %RootNode = [node, Key, ["nil_1", "nil_2"], 1, nil],
  RootNode = [node, Key, [nil, nil], 1, nil],
  %graphviz:graph("G"),
  %File = "/Users/foxhound/Desktop/avlBaum/Tree" ++ utility:toString(1) ++ ".png",
  %graphviz:add_node(utility:toString(Key)),
  %graphviz:to_file(File, "png"),

  Tree = incrementExecution( [ 0, [0, 0], RootNode ] ),
  makePicture(Tree, "/Users/foxhound/Desktop/avlBaum/"),
  Tree.


%% Funktion haengt genau ein Knoten an einen Baum an
%% @param avlBaum Tree - Die Datenstruktur des AVL Baumes
%% @param String Key - Das neu hinzugefuegte Element
einfuegen(Tree, Key) ->
% Pruefen ob dieser Knoten schon vorhanden ist!
  Boolean = isAvailable(Tree, Key),
  if (Boolean == true) ->
    keyIsRedundant;
  true ->
    ModifyTree = einfuegenHelper(Tree, getRootKey(Tree), Key),
    ResultTree = incrementExecution(ModifyTree),
    makePicture(ResultTree, nil),
    ResultTree
  end.

einfuegenHelper(Tree, CurrentCompareKey, Key) ->
  %% if(true) -> dann links einfuegen
  if (CurrentCompareKey > Key) ->
    LeftKeyChild = getLeftChild(Tree, CurrentCompareKey),

    % Wenn LeftKeyChild Nil ist, dann koennen wir dort links oder rechts anhaengen
    if (LeftKeyChild == nil) ->

      % Neuen Node erstellen
      NewNode = [node, Key, [nil, nil], getHeight(Tree, CurrentCompareKey) + 1, CurrentCompareKey],

      % Zeiger von Eltern Node auf den neuen Node setzen
      ModifyTree = setLeftChildKey(Tree, CurrentCompareKey, Key),

      %% Schluessel links anhaengen
      ModifyTree ++ [NewNode];

    % Tiefer in die Rekursion gehen!
    true ->
      ModifyTree2 = Tree,
      einfuegenHelper(ModifyTree2, LeftKeyChild, Key)
    end;

  %% Sonst Rechts einfuegen
  true ->
    RightKeyChild = getRightChild(Tree, CurrentCompareKey),

    % Wenn RightKeyChild Nil ist, dann koennen wir dort links oder rechts anhaengen
    if (RightKeyChild  == nil) ->

      % Neuen Node erstellen
      NewNode = [node, Key, [nil, nil], getHeight(Tree, CurrentCompareKey) + 1, CurrentCompareKey],

      % Zeiger von Eltern Node auf den neuen Node setzen
      ModifyTree = setRightChildKey(Tree, CurrentCompareKey, Key),

      %% Schluessel links anhaengen
      ModifyTree ++ [NewNode];

    % Tiefer in die Rekursion gehen!
      true ->
        ModifyTree2 = Tree,
        einfuegenHelper(ModifyTree2, RightKeyChild, Key)
    end
  end.



% 1 Füge neuen Knoten gemäß der Sortierung als Blatt in den AVL-Baum ein. HIER!!!

% 2 Überprüfe von diesem Blatt ausgehend bottom-up die AVL-Bedingung.

% 3 Führe ggf. an dem Knoten, an dem die Bedingung verletzt wurde, eine
%      Rebalancierung durch (durch entsprechende Rotation).

% 4 Im Unterschied zu gewöhnlichen binären Suchbäumen ist es bei AVL-Bäumen
%       wegen den Rotationen prinzipiell nicht möglich, gleiche Schlüssel immer im
%       rechten (linken) Teilbaum einzufügen (oder dort zu finden).


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
makePicture(Tree, File) when File == nil -> makePicture(Tree, "/Users/foxhound/Desktop/avlBaum/");
makePicture(Tree, File) ->
   graphviz:graph("G"),
  [_PicCounter, _RotationCounters | NodeList] = Tree,
  [Head | Tail] = NodeList,
  makePictureHelper(Tree, Head, Tail, File, 0),
  PicNumber = getExecuteNumber(Tree),
  graphviz:to_file(File ++ "Tree" ++ utility:toString(PicNumber) ++ ".png", "png"),
  graphviz:delete().

makePictureHelper(Tree, Head, [], File, Counter) ->

  CurrentKey = getKey(Head),

  ModifyLeftKey = checkOfNil(getLeftChild(Tree, CurrentKey), Counter),
  ModifyRightKey = checkOfNil(getRightChild(Tree, CurrentKey), Counter + 1),

  graphviz:add_edge(utility:toString(CurrentKey), utility:toString(ModifyLeftKey)),
  graphviz:add_edge(utility:toString(CurrentKey), utility:toString(ModifyRightKey));

makePictureHelper(Tree, Head, Tail, File, Counter) ->
  CurrentKey = getKey(Head),

  ModifyLeftKey = checkOfNil(getLeftChild(Tree, CurrentKey), Counter),
  ModifyRightKey = checkOfNil(getRightChild(Tree, CurrentKey), Counter + 1),

  graphviz:add_edge(utility:toString(CurrentKey), utility:toString(ModifyLeftKey)),
  graphviz:add_edge(utility:toString(CurrentKey), utility:toString(ModifyRightKey)),

  [NewHead | NewTail] = Tail,

  makePictureHelper(Tree, NewHead, NewTail, File, Counter + 2).

%% Funktion balanciert einen alvBaum aus
toBalanceOut(Tree) ->
  todo.


%% Funktion Prueft ob ein Schluessel im Baum enthalten ist!
%% Wenn ja dann true, sonst false
isAvailable(Tree, Key) ->
  [_PicCounter, _RotationCounters | NodeList] = Tree,
  Buffer = [X || X <- NodeList, lists:nth(2, X) == Key ],
  BufferLength = length(Buffer),
  if (BufferLength > 0 ) ->
    true;
  true ->
      false
  end.
%=================================================================================================================================================
%                                                                     SETTER
%=================================================================================================================================================

%% Funktion aendert das linke Kind
%% @return Tree
setLeftChildKey(Tree, Key, Value) ->
  Node = getNode(Tree, Key),
  [Prefix, NodeKey, [_LeftChildKey, RightChildKey], Height, PredecessorKey] = Node,
  ModifyNode = [Prefix, NodeKey, [Value, RightChildKey], Height, PredecessorKey],
  [Part1, Part2 | NodeList] = Tree,
  setChildHelper(NodeList, Key, ModifyNode, [], Part1, Part2).

%% Funktion aendert das rechte Kind
%% @return Tree
setRightChildKey(Tree, Key, Value) ->
  Node = getNode(Tree, Key),
  [Prefix, NodeKey, [LeftChildKey, _RightChildKey], Height, PredecessorKey] = Node,
  ModifyNode = [Prefix, NodeKey, [LeftChildKey, Value], Height, PredecessorKey],
  [Part1, Part2 | NodeList] = Tree,
  setChildHelper(NodeList, Key, ModifyNode, [], Part1, Part2).

%% ----------------------------- SetLeftChildKey && SetRightChildKey Unterfunktionen START----------------------------------------------
setChildHelper(NodeList, Key, ModifyNode, ModifyNodeList, Part1, Part2) ->
  [Head | Tail] = NodeList,
  setChildKeyHelperSplit(Head, Tail, Key, ModifyNode, ModifyNodeList, Part1, Part2).

setChildKeyHelperSplit(Head, [], Key, ModifyNode, ModifyNodeList, Part1, Part2) ->
  CurrentKey = getKey(Head),
  if (Key == CurrentKey) ->
    [Part1] ++ [Part2] ++ ModifyNodeList ++ [ModifyNode] ;
  true ->
    [Part1] ++ [Part2] ++ ModifyNodeList ++ [Head]
  end;
setChildKeyHelperSplit(Head, Tail, Key, ModifyNode, ModifyNodeList, Part1, Part2) ->
  CurrentKey = getKey(Head),
  [NewHead | RestTail] = Tail,

  if (CurrentKey == Key) ->
    setChildKeyHelperSplit(NewHead, RestTail, Key, ModifyNode, ModifyNodeList ++ [ModifyNode], Part1, Part2);
    true ->
      setChildKeyHelperSplit(NewHead, RestTail, Key, ModifyNode, ModifyNodeList ++ [Head], Part1, Part2)
  end.
%% ----------------------------- SetLeftChildKey && SetRightChildKey Unterfunktionen ENDE----------------------------------------------


%=================================================================================================================================================
%                                                                     GETTER
%=================================================================================================================================================

%% Gibt den linken Knoten von einem Schluessel
%% @return Key
%% ---------------------------------------------------------------------------
getLeftChild(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getLeftChildHelper(Tree, Key, Boolean).

getLeftChildHelper(Tree, Key, Bool) when Bool == false -> keyNotFound;
getLeftChildHelper(Tree, Key, Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [LeftKey, _RightKey], _Height, _KeyTyp] = Node,
  LeftKey.
%% ---------------------------------------------------------------------------

%% Gibt den rechten Knoten von einem Schluessel
%% @return Key
%% ---------------------------------------------------------------------------
getRightChild(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getRightChildHelper(Tree, Key, Boolean).

getRightChildHelper(Tree, Key, Bool) when Bool == false -> keyNotFound;
getRightChildHelper(Tree, Key, Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [_LeftKey, RightKey], _Height, _KeyTyp] = Node,
  RightKey.
%% ---------------------------------------------------------------------------

%% TODO: Preconditon, falls der Schuessel nicht vorhanden ist
%% Gibt einen gesamten Knoten zu einen Schluessel
%% @return Node
getNode(Tree, Key) ->
  [_, _ | NodeList] = Tree,
  %%% Pos 2: Der Schluessel/Key
  Buffer = [ X || X <- NodeList, lists:nth(2, X) == Key ],
  lists:nth(1, Buffer).

%% Erhoeht den Zaehler um 1
incrementExecution(Tree) ->
  [_Head | Tail] = Tree,
  [lists:nth(1, Tree) + 1] ++ Tail.


%% Funktion gibt die Wurzel des Bauemes zurueck
%% @retrun Node
getRootNode(Tree) ->
  [_, _ | NodeList] = Tree,
  %%% Pos 5: Vorgaenger Schluessel/Key; if predecessor == nil -> this.Node = RootNode
  Buffer = [ X || X <- NodeList, lists:nth(5, X) == nil],
  Length = length(Buffer),
  if ( Length /= 1 ) ->
    schwerwiegenderFehlerInDerBaumstrukturBeiFunktionGetRoot;
    true ->
      lists:nth(1, Buffer)
  end.

getHeight(Tree, Key) ->
  getHeight(getNode(Tree, Key)).

%% Funktion gibt den Wurzel Schluessel in einem Baum zurueck
getRootKey(Tree) ->
  getKey(getRootNode(Tree)).
%% Funktion gibt den Schluessel zu einem Node
getKey(Node) ->
  lists:nth(2, Node).

%% Funktion gib Schluessel seines vorgaengers/ElterSchluessel
%% @return Key
getPredecessor(Node) ->
  lists:nth(5, Node).

getHeight(Node) ->
  lists:nth(4, Node).

getExecuteNumber(Tree) ->
  lists:nth(1, Tree).

checkOfNil(Elem, _Number) when Elem /= nil -> Elem;
checkOfNil(Elem, Number) ->
  utility:toString(Elem) ++ "_" ++ utility:toString(Number).