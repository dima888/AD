%%%-------------------------------------------------------------------
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%

%%% AVL-Baum-Struktur: [ ExecuteCounter, [RotationLeftCounter, RotationRightCounter], [node, Key, [ChildLeftFromKey, ChildRightFromKey], Height, PredecessorKey] ] , ... ]


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
-export([init/0, einfuegen/3, loeschen/3, linksrotation/3, rechtsrotation/3, doppelLinksrotation/3, doppelRechtsrotation/3,

% Die unteren muessen raus, sind aus Testzwecken drinne
  getLeftChildKey/2, isAvailable/2, getRootNode/1, setLeftChildKey/3, setRightChildKey/3, getNode/2,
  getRightChildKey/2, makePicture/2, sort/1, getPredecessor/1, getPredecessor/2, setPredecessor/3, linksrotation/3

]).

%% Erstellt einen AVL-Baum mit einen Wurzel Knoten
init() ->
  [ 0, [0, 0] ].

%% Funktion haengt genau ein Knoten an einen Baum an
%% @param avlBaum Tree - Die Datenstruktur des AVL Baumes
%% @param String Key v List Liste von Keys - Das neu hinzugefuegte Element
%% Extra: File == nil -> "/Users/foxhound/Desktop/avlBaum/"
% TODO: Pruefung fuer die ausbalancierung einbauen
einfuegen(Tree, Key, File) when is_integer(Key) == true -> io:fwrite("Create Picture and add Node with Key: " ), io:write(Key), io:nl(), insertKey(Tree, Key, File);
einfuegen(Tree, Key, File) when is_list(Key) == true -> insertKeyFromList(Tree, Key, File);
einfuegen(_Tree, _Key, _File) -> schluesselIstKeinLegitimerWert.

%% Diese Funtion loescht einen Knoten aus einem Baum
%% @param avlBaum Tree - Der AVL-Baum auf dem ein Schluessel entfernt werden soll
%% @param Integer Key - Der zu entfernende Schluessel
%% @return avlBaum - Der modifizierte Baum
loeschen(Tree, Key, File) ->
  todo.

%% Implementation ohne Preconditions!!!
%% Diese Funktion implementiert die einfache Linksrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
linksrotation(Tree, Key, File) ->
  io:fwrite("Linksrotation um Key: " ), io:write(Key), io:nl(),
  BKey = getRightChildKey(Tree, Key),
  L2Key = getLeftChildKey(Tree, BKey),

  % Step 1: Set B Predecessor auf A's Predeceossor.
  ModifyTree = setPredecessor(Tree, BKey, getPredecessor(Tree, Key)),

  % Step 2 : Set A Predecessor auf Key von B und B's linkes Kind auf A.
  ModifyTree2 = setPredecessor(ModifyTree, Key, BKey),
  ModifyTree3 = setLeftChildKey(ModifyTree2, BKey, Key),

  % Step 3: Holle mir L2, wenn L2 == nil ist, dann setzte rechtes Kind von A auf nil, (sonst auf L2 && L2-Predecessor auf AKey)
  if (L2Key == nil) ->
    IfResult = setRightChildKey(ModifyTree3, Key, nil),
    IfResult;
  true ->
    ModifyTree4 = setRightChildKey(ModifyTree3, Key, L2Key),
    %IfResult = setPredecessor(ModifyTree4, L2Key, getPredecessor(ModifyTree4, Key))
    IfResult = setPredecessor(ModifyTree4, L2Key, Key)
  end,

  %% Probelem: Der Vorgaenger auf B Zeigt immer noch auf A, der Muss auf B umgebogen werden, sofern der nicht nil ist!
  PredecessorFromB = getPredecessor(Tree, Key),
  if (PredecessorFromB == nil) ->
    % TODO: Hier ist ein gespenst, der mein counter nicht erhoeht, muss zwei mal aufrufen den kack
    io:nl(), io:fwrite("ifResult: "), io:write(IfResult), io:nl(),
    ModifyTree6 = sort(IfResult),
    io:nl(), io:fwrite("Modify 6: "), io:write(ModifyTree6), io:nl(),
    Result = incrementExecution(ModifyTree6),
    io:nl(), io:fwrite("Result: "), io:write(Result), io:nl(),
    makePicture(Result, File),
    Result;
    %io:fwrite("fuck you bitch"),
    %X = incrementExecution(Result),
    %incrementExecution(X);
  true ->
    %% Pruefen ob wir das linke oder rechte Kind setzten muessen
    ModifyTree5 = checkLeftOrRightSetChildKey(Tree, Key, getPredecessor(Tree, Key), [IfResult, PredecessorFromB, BKey]),
    %ModifyTree5 = checkLeftOrRightSetChildKey(IfResult, Key, getPredecessor(Tree, Key), [IfResult, PredecessorFromB, BKey]),
    ModifyTree6 = sort(ModifyTree5),
    Result = incrementExecution(ModifyTree6),
    makePicture(Result, File),
    io:fwrite("fuck you"),
    incrementExecution(Result)
  end.

%% Diese Funktion implementiert die einfache Rechtsrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
rechtsrotation(Tree, Key, File) ->
  io:fwrite("Rechtsrotation um Key: " ), io:write(Key), io:nl(),
  BKey = getLeftChildKey(Tree, Key),
  R2Key = getRightChildKey(Tree, BKey),

  % Step 1: Set B Predecessor auf A's Predeceossor.
  ModifyTree = setPredecessor(Tree, BKey, getPredecessor(Tree, Key)),

  % Step 2 : Set A Predecessor auf Key von B und B's linkes Kind auf A.
  ModifyTree2 = setPredecessor(ModifyTree, Key, BKey),
  ModifyTree3 = setRightChildKey(ModifyTree2, BKey, Key),

  % Step 3: Holle mir R2, wenn R2 == nil ist, dann setzte rechtes Kind von A auf nil, (sonst auf R2 && R2-Predecessor auf AKey)
  if (R2Key == nil) ->
    IfResult = setLeftChildKey(ModifyTree3, Key, nil),
    IfResult;
    true ->
      ModifyTree4 = setLeftChildKey(ModifyTree3, Key, R2Key),
      IfResult = setPredecessor(ModifyTree4, R2Key, Key)
  end,

  %% Probelem: Der Vorgaenger auf B Zeigt immer noch auf A, der Muss auf B umgebogen werden, sofern der nicht nil ist!
  PredecessorFromB = getPredecessor(Tree, Key),
  if (PredecessorFromB == nil) ->
    % TODO: Hier ist ein gespenst, der mein counter nicht erhoeht, muss zwei mal aufrufen den kack
    ModifyTree6 = sort(IfResult),
    Result = incrementExecution(ModifyTree6),
    makePicture(Result, File),
    incrementExecution(Result);
    true ->
      %% Pruefen ob wir das linke oder rechte Kind setzten muessen
      ModifyTree5 = checkLeftOrRightSetChildKey(Tree, Key, getPredecessor(Tree, Key), [IfResult, PredecessorFromB, BKey]),
      %ModifyTree5 = checkLeftOrRightSetChildKey(IfResult, Key, getPredecessor(Tree, Key), [IfResult, PredecessorFromB, BKey]),
      ModifyTree6 = sort(ModifyTree5),
      Result = incrementExecution(ModifyTree6),
      makePicture(Result, File),
      Result
  end.

%% Diese Funktion implementiert die doppelte Linksrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
doppelLinksrotation(Tree, Key, File) ->
  todo.

%% Diese Funktion implementiert die doppelte Rechtsrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
doppelRechtsrotation(Tree, Key, File) ->
  todo.


%=================================================================================================================================================
%                                                                    Hilfsfunktionen
%=================================================================================================================================================

%% Ganzer AVL Baum wird rekursiv durchlaufen und ein sortierter Baum zurueck gegeben
sort(Tree) ->
  [ExecutenCounter, [LeftRotationCounter, RightRotationCounter] | _Rest] = Tree,
  RootKey = getRootKey(Tree),
  [_, _ | NodeList] = Tree,
  SortedList = sortHelper(Tree, RootKey, [RootKey], RootKey, RootKey, length(NodeList)),
  einfuegenWithoutPicture(init(), SortedList),
  ModifyTree = einfuegenWithoutPicture(init(), SortedList),
  [_X, _Y | Nodes] = ModifyTree,
  Res = [ExecutenCounter, [LeftRotationCounter, RightRotationCounter] ] ,
  Res ++ Nodes.

%

%RootKey = getRootKey(Tree),
%[_, _ | NodeList] = Tree,
%SortedList = sortHelper(Tree, RootKey, [RootKey], RootKey, RootKey, length(NodeList)),


%% RekursionsEnde
sortHelper(_Tree, _CurrentKey, ResultKeyList, _PredecessorKeyFromCurrentKey, _RootKey, NodeListLength) when length(ResultKeyList) == NodeListLength ->
  ResultKeyList;
%% Element abspeichern und weiter in die rekursion gehen
sortHelper(Tree, CurrentKey, ResultKeyList, PredecessorKeyFromCurrentKey, RootKey, NodeListLength) ->
  LeftKey = getLeftChildKey(Tree, CurrentKey),
  RightKey = getRightChildKey(Tree, CurrentKey),
  BooleanLeft = lists:member(LeftKey, ResultKeyList),
  BooleanRight = lists:member(RightKey, ResultKeyList),

  if (BooleanLeft or (LeftKey == nil) ) ->
    if (BooleanRight or (RightKey == nil) ) ->
      sortHelper(Tree, PredecessorKeyFromCurrentKey, ResultKeyList, getPredecessor(Tree, PredecessorKeyFromCurrentKey), RootKey, NodeListLength);
    true ->
      sortHelper(Tree, RightKey, ResultKeyList ++ [RightKey], CurrentKey, RootKey, NodeListLength)
    end;
  true ->
    sortHelper(Tree, LeftKey, ResultKeyList ++ [LeftKey], CurrentKey, RootKey, NodeListLength)
  end.

%% Diese Funktion ermittelt ob linkes Kind oder Rechtes Kind gesetzt werden muss
%% @return Die richtige Funktion! setLeftChildKey oder setRightChildKey kommen nur in Frage.
checkLeftOrRightSetChildKey(Tree, AKey, PredecessorFromA, [Param1, Param2, Param3]) ->
  LeftChildKeyFromPredecessorFromA = getLeftChildKey(Tree, PredecessorFromA),
  if (LeftChildKeyFromPredecessorFromA == AKey) ->
    setLeftChildKey(Param1, Param2, Param3);
    true ->
      setRightChildKey(Param1, Param2, Param3)
  end.

checkOfNil(Elem, _Number) when Elem /= nil -> Elem;
checkOfNil(Elem, Number) ->
  utility:toString(Elem) ++ "_" ++ utility:toString(Number).

%% Key einfuegen ohne Bilder zu machen
einfuegenWithoutPicture(Tree, Key) when is_integer(Key) == true -> insertKeyWithoutPicture(Tree, Key);
einfuegenWithoutPicture(Tree, Key) when is_list(Key) == true -> insertKeyFromListWithoutPicture(Tree, Key);
einfuegenWithoutPicture(_Tree, _Key) -> schluesselIstKeinLegitimerWert.

%% Diese Funktion ist fuer das hinzufuegen von Schluesseln in die ADT verantwortlich
insertKey(Tree, Key, File) ->

  %% Pruefung, falls der Baum noch leer ist
  if (Tree == [ 0, [0, 0] ]) ->
    RootNode = [node, Key, [nil, nil], 1, nil],
    ResultTree = incrementExecution( Tree ++ [RootNode] ),
    makePicture(ResultTree, File),
    ResultTree;
    true ->
      % Pruefen ob dieser Knoten schon vorhanden ist!
      Boolean = isAvailable(Tree, Key),
      if (Boolean == true) ->
        io:fwrite("Key ist redundant"),
        Tree;
        true ->
          ModifyTree = insertHelper(Tree, getRootKey(Tree), Key),
          ResultTree = incrementExecution(ModifyTree),
          makePicture(ResultTree, nil),

          %% TODO: Pruefen ob der AVL baum ausbalanciert werden muss,
          %% TODO: Wenn ja, dann noch ein Picture machen

          ResultTree
      end
  end.

%% Diese Funktion ist fuer das hinzufuegen von Schluesseln in die ADT verantwortlich
insertKeyWithoutPicture(Tree, Key) ->

  %% Pruefung, falls der Baum noch leer ist
  if (Tree == [ 0, [0, 0] ]) ->
    RootNode = [node, Key, [nil, nil], 1, nil],
    incrementExecution( Tree ++ [RootNode] );
    true ->
      % Pruefen ob dieser Knoten schon vorhanden ist!
      Boolean = isAvailable(Tree, Key),
      if (Boolean == true) ->
        io:fwrite("Key ist redundant"),
        Tree;
        true ->
          ModifyTree = insertHelper(Tree, getRootKey(Tree), Key),
          ResultTree = incrementExecution(ModifyTree),

          %% TODO: Pruefen ob der AVL baum ausbalanciert werden muss,
          %% TODO: Wenn ja, dann noch ein Picture machen

          ResultTree
      end
  end.

insertHelper(Tree, CurrentCompareKey, Key) ->
  %% if(true) -> dann links einfuegen
  if (CurrentCompareKey > Key) ->
    LeftKeyChild = getLeftChildKey(Tree, CurrentCompareKey),

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
        insertHelper(ModifyTree2, LeftKeyChild, Key)
    end;

  %% Sonst Rechts einfuegen
    true ->
      RightKeyChild = getRightChildKey(Tree, CurrentCompareKey),

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
          insertHelper(ModifyTree2, RightKeyChild, Key)
      end
  end.



% 1 Füge neuen Knoten gemäß der Sortierung als Blatt in den AVL-Baum ein. HIER!!!

% 2 Überprüfe von diesem Blatt ausgehend bottom-up die AVL-Bedingung.

% 3 Führe ggf. an dem Knoten, an dem die Bedingung verletzt wurde, eine
%      Rebalancierung durch (durch entsprechende Rotation).

% 4 Im Unterschied zu gewöhnlichen binären Suchbäumen ist es bei AVL-Bäumen
%       wegen den Rotationen prinzipiell nicht möglich, gleiche Schlüssel immer im
%       rechten (linken) Teilbaum einzufügen (oder dort zu finden).


%% Diese funktion fuegt Elemente aus ganzer liste nacheinander in eine ADT ein
insertKeyFromList(Tree, KeyList, File) ->
  [ Head | Tail ]  = KeyList,
  listEinfuegenHelper(Tree, Head, Tail, File).
listEinfuegenHelper(Tree, Head, [], File) -> einfuegen(Tree, Head, File);
listEinfuegenHelper(Tree, Head, Tail, File) ->
  ModifyTree = einfuegen(Tree, Head, File),
  % Muss ihn bisschen warten lassen, sonst gibt es Probleme mit graphviz.erl!!!
  timer:sleep(500),
  [ NewHead | NewTail ] = Tail,
  listEinfuegenHelper(ModifyTree, NewHead, NewTail, File).

%% Diese funktion fuegt Elemente aus ganzer liste nacheinander in eine ADT ein
insertKeyFromListWithoutPicture(Tree, KeyList) ->
  [ Head | Tail ] = KeyList,
  listEinfuegenHelperWithoutPicture(Tree, Head, Tail).
listEinfuegenHelperWithoutPicture(Tree, Head, []) -> einfuegenWithoutPicture(Tree, Head);
listEinfuegenHelperWithoutPicture(Tree, Head, Tail) ->
  ModifyTree = einfuegenWithoutPicture(Tree, Head),
  % Muss ihn bisschen warten lassen, sonst gibt es Probleme mit graphviz.erl!!!
  timer:sleep(500),
  [ NewHead | NewTail ] = Tail,
  listEinfuegenHelperWithoutPicture(ModifyTree, NewHead, NewTail).

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

makePictureHelper(Tree, Head, [], _File, Counter) ->
  CurrentKey = getKey(Head),

  ModifyLeftKey = checkOfNil(getLeftChildKey(Tree, CurrentKey), Counter),
  ModifyRightKey = checkOfNil(getRightChildKey(Tree, CurrentKey), Counter + 1),

  graphviz:add_edge(utility:toString(CurrentKey), utility:toString(ModifyLeftKey)),
  graphviz:add_edge(utility:toString(CurrentKey), utility:toString(ModifyRightKey));

makePictureHelper(Tree, Head, Tail, File, Counter) ->
  CurrentKey = getKey(Head),

  ModifyLeftKey = checkOfNil(getLeftChildKey(Tree, CurrentKey), Counter),
  ModifyRightKey = checkOfNil(getRightChildKey(Tree, CurrentKey), Counter + 1),

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

%% Erhoeht den Zaehler um 1
incrementExecution(Tree) ->
  [_Head | Tail] = Tree,
  [lists:nth(1, Tree) + 1] ++ Tail.


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
  nodeInserter(NodeList, Key, ModifyNode, [], Part1, Part2).

%% Funktion aendert das rechte Kind
%% @return Tree
setRightChildKey(Tree, Key, Value) ->
  Node = getNode(Tree, Key),
  [Prefix, NodeKey, [LeftChildKey, _RightChildKey], Height, PredecessorKey] = Node,
  ModifyNode = [Prefix, NodeKey, [LeftChildKey, Value], Height, PredecessorKey],
  [Part1, Part2 | NodeList] = Tree,
  nodeInserter(NodeList, Key, ModifyNode, [], Part1, Part2).

%% Funktion aendert den Vorgaenger eines Nodes
setPredecessor(Tree, Key, Value) ->
  Node = getNode(Tree, Key),
  [Prefix, NodeKey, [LeftChildKey, RightChildKey], Height, _PredecessorKey] = Node,
  ModifyNode = [Prefix, NodeKey, [LeftChildKey, RightChildKey], Height, Value],
  [Part1, Part2 | NodeList] = Tree,
  nodeInserter(NodeList, Key, ModifyNode, [], Part1, Part2).

%% ----------------------------- Funktion tauscht einen Node aus START ----------------------------------------------
nodeInserter(NodeList, Key, ModifyNode, ModifyNodeList, Part1, Part2) ->
  [Head | Tail] = NodeList,
  nodeInserterHelper(Head, Tail, Key, ModifyNode, ModifyNodeList, Part1, Part2).

nodeInserterHelper(Head, [], Key, ModifyNode, ModifyNodeList, Part1, Part2) ->
  CurrentKey = getKey(Head),
  if (Key == CurrentKey) ->
    [Part1] ++ [Part2] ++ ModifyNodeList ++ [ModifyNode] ;
    true ->
      [Part1] ++ [Part2] ++ ModifyNodeList ++ [Head]
  end;
nodeInserterHelper(Head, Tail, Key, ModifyNode, ModifyNodeList, Part1, Part2) ->
  CurrentKey = getKey(Head),
  [NewHead | RestTail] = Tail,

  if (CurrentKey == Key) ->
    nodeInserterHelper(NewHead, RestTail, Key, ModifyNode, ModifyNodeList ++ [ModifyNode], Part1, Part2);
    true ->
      nodeInserterHelper(NewHead, RestTail, Key, ModifyNode, ModifyNodeList ++ [Head], Part1, Part2)
  end.
%% ----------------------------- Funktion tauscht einen Node aus ENDE ----------------------------------------------


%=================================================================================================================================================
%                                                                     GETTER
%=================================================================================================================================================

%% Gibt den linken Knoten von einem Schluessel
%% @return Key
%% ---------------------------------------------------------------------------
getLeftChildKey(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getLeftChildHelper(Tree, Key, Boolean).

getLeftChildHelper(Tree, Key, Bool) when Bool == false -> io:fwrite("key is not integer"), nil;
getLeftChildHelper(Tree, Key, Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [LeftKey, _RightKey], _Height, _KeyTyp] = Node,
  LeftKey.
%% ---------------------------------------------------------------------------

%% Gibt den rechten Knoten von einem Schluessel
%% @return Key
%% ---------------------------------------------------------------------------
getRightChildKey(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getRightChildHelper(Tree, Key, Boolean).

getRightChildHelper(Tree, Key, Bool) when Bool == false -> io:fwirte("key not found"), nil;
getRightChildHelper(Tree, Key, Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [_LeftKey, RightKey], _Height, _KeyTyp] = Node,
  RightKey.
%% ---------------------------------------------------------------------------

%% TODO: Preconditon, falls der Schuessel nicht vorhanden ist
%% Gibt einen gesamten Knoten zu einen Schluessel
%% @return Node

getNode(Tree, Key) when is_integer(Key) == false -> nil;
getNode(Tree, Key) ->
  [_, _ | NodeList] = Tree,
  %%% Pos 2: Der Schluessel/Key
  Buffer = [ X || X <- NodeList, lists:nth(2, X) == Key ],
  lists:nth(1, Buffer).


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

%% Gibt den Vorgaenger Schluessel zu einem Schuessel
getPredecessor(Tree, Key) ->
  getPredecessor(getNode(Tree, Key)).

%% Funktion gib Schluessel seines vorgaengers/ElterSchluessel
%% @return Key
getPredecessor(Node) ->
  lists:nth(5, Node).

getHeight(Node) ->
  lists:nth(4, Node).

getExecuteNumber(Tree) ->
  lists:nth(1, Tree).

