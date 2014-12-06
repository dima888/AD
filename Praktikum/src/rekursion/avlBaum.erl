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
-export([init/0, einfuegen/3, loeschen/3, linksrotation/3, rechtsrotation/3, doppelLinksrotation/3, doppelRechtsrotation/3

% Die unteren muessen raus, sind aus Testzwecken drinne
  %,getLeftChildKey/2, isAvailable/2, getRootNode/1, setLeftChildKey/3, setRightChildKey/3, getNode/2,
  %getRightChildKey/2, makePicture/2, sort/1, getPredecessor/1, getPredecessor/2, setPredecessor/3, linksrotation/3,
  %getMaxDeep/2, toBalanceOut/3

]).

%% Erstellt einen AVL-Baum mit einen Wurzel Knoten
init() ->
  [ 0, [0, 0] ].

%% Funktion haengt genau ein Knoten an einen Baum an
%% @param avlBaum Tree - Die Datenstruktur des AVL Baumes
%% @param String Key v List Liste von Keys - Das neu hinzugefuegte Element
%% Extra: File == nil -> "/Users/foxhound/Desktop/avlBaum/"
einfuegen(Tree, Key, File) when is_integer(Key) == true -> io:fwrite("Create Picture and add Node with Key: " ), io:write(Key), io:nl(), insertKey(Tree, Key, File);
einfuegen(Tree, Key, File) when is_list(Key) == true -> insertKeyFromList(Tree, Key, File);
einfuegen(_Tree, _Key, _File) -> schluesselIstKeinLegitimerWert.

%% Diese Funtion loescht einen Knoten aus einem Baum
%% @param avlBaum Tree - Der AVL-Baum auf dem ein Schluessel entfernt werden soll
%% @param Integer Key - Der zu entfernende Schluessel
%% @return avlBaum - Der modifizierte Baum
loeschen(Tree, Key, File) ->
  loeschenHelper(Tree, Key, File, getLeftChildKey(Tree, Key), getRightChildKey(Tree, Key)).

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
    IfResult = setPredecessor(ModifyTree4, L2Key, Key)
  end,

  %% Probelem: Der Vorgaenger auf B Zeigt immer noch auf A, der Muss auf B umgebogen werden, sofern der nicht nil ist!
  PredecessorFromB = getPredecessor(Tree, Key),
  if (PredecessorFromB == nil) ->
    ModifyTree6 = sort(IfResult),
    Result = incrementExecution(ModifyTree6),
    makePicture(Result, File),
    [X, [LRotationen, RRotationen] | Rest] = Result,
    [X, [LRotationen + 1, RRotationen] | Rest];
  true ->
    %% Pruefen ob wir das linke oder rechte Kind setzten muessen
    ModifyTree5 = checkLeftOrRightSetChildKey(Tree, Key, getPredecessor(Tree, Key), [IfResult, PredecessorFromB, BKey]),
    ModifyTree6 = sort(ModifyTree5),
    Result = incrementExecution(ModifyTree6),
    makePicture(Result, File),
    incrementExecution(Result),
    [X, [LRotationen, RRotationen] | Rest] = Result,
    [X, [LRotationen + 1, RRotationen] | Rest]
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
    ModifyTree6 = sort(IfResult),
    Result = incrementExecution(ModifyTree6),
    makePicture(Result, File),

    incrementExecution(Result),
    [X, [LRotationen, RRotationen] | Rest] = Result,
    [X, [LRotationen, RRotationen + 1] | Rest];
    true ->
      %% Pruefen ob wir das linke oder rechte Kind setzten muessen
      ModifyTree5 = checkLeftOrRightSetChildKey(Tree, Key, getPredecessor(Tree, Key), [IfResult, PredecessorFromB, BKey]),
      ModifyTree6 = sort(ModifyTree5),
      Result = incrementExecution(ModifyTree6),
      makePicture(Result, File),
      Result,
      [X, [LRotationen, RRotationen] | Rest] = Result,
      [X, [LRotationen, RRotationen + 1] | Rest]
  end.

%% Diese Funktion implementiert die doppelte Linksrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
doppelLinksrotation(Tree, Key, File) ->
  io:fwrite("------------------------------------------------------------------------------" ), io:nl(),
  io:fwrite("Doppelte Linksrotation um Key: " ), io:write(Key), io:nl(),
  BKey = getRightChildKey(Tree, Key),
  ModifyTree = rechtsrotation(Tree, BKey, File),
  ResultTree = linksrotation(ModifyTree, Key, File),
  io:fwrite("------------------------------------------------------------------------------" ), io:nl(),
  ResultTree.

%% Diese Funktion implementiert die doppelte Rechtsrotation
%% @param avlBaum Tree - Der Baum in den rotiert werden soll
%% @param Integer Key - Der Vertex um den rotiert werden soll
doppelRechtsrotation(Tree, Key, File) ->
  io:fwrite("------------------------------------------------------------------------------" ), io:nl(),
  io:fwrite("Doppelte Rechtsrotation um Key: " ), io:write(Key), io:nl(),
  BKey = getLeftChildKey(Tree, Key),
  ModifyTree = linksrotation(Tree, BKey, File),
  ResultTree = rechtsrotation(ModifyTree, Key, File),
  io:fwrite("------------------------------------------------------------------------------" ), io:nl(),
  ResultTree.


%=================================================================================================================================================
%                                                                    Hilfsfunktionen
%=================================================================================================================================================
%% Erste Variante!!!!!!
loeschenHelper(Tree, Key, File, LeftChildKey, RightChildKey) when ((LeftChildKey == nil) and (RightChildKey == nil)) ->
  io:fwrite("Erste Variante"), io:nl(),
  Predecessor = getPredecessor(Tree, Key),
  if (Predecessor == nil) ->
    [X, Y | _Rest] = Tree,
    Result = [X + 1, Y],
    Result;
    true ->
      [X, Y | NodeList] = Tree,
      ModifyNodeList = [ X || X <- NodeList, Key /= getKey(X) ],
      Result = sort([X + 1, Y] ++ ModifyNodeList),
      makePicture(Result, File),
      Result
  end;
%% Zweite Variante
loeschenHelper(Tree, Key, File, LeftChildKey, RightChildKey) when ( (LeftChildKey == nil) and (RightChildKey /= nil) or ( (LeftChildKey /= nil) and (RightChildKey == nil)) ) ->
  %% Position: 1 -> rechts; 0 -> links
  [ _WhatEver, Position ] = getSuitablyChildKey(Tree, getPredecessor(Tree, Key), Key),

  %% Sonder Fall, falls Root geloescht werden mag
  SeperatCaseKey = getPredecessor(Tree, Key),

  %% if(true) -> Root Node erkannt
  if (SeperatCaseKey == nil) ->
    [ Part1, Part2 | NodeList ]= Tree,
    ModifyNodeList = [ X || X <- NodeList, lists:nth(2, X) /= Key ],
    ModifyTree = [Part1, Part2] ++ ModifyNodeList,

    % Richtige Seite ermitteln
    if (LeftChildKey == nil) ->
      ResultF = setPredecessor(ModifyTree, getRightChildKey(Tree, Key), nil);
      true ->
        ResultF = setPredecessor(ModifyTree, getLeftChildKey(Tree, Key), nil)
    end,
    ResultE = sort(ResultF),
    Result = incrementExecution(ResultE),
    makePicture(Result, File),
    Result;

    true ->
      % Parent Node von Key herausziehen und vorbereiten
      ParentKey = getPredecessor(Tree, Key),
      ParentNode = getNode(Tree, ParentKey),
      [PrefixX, KeyX, [LeftChildX, RightChildX], HeightX, PredecessorX] = ParentNode,

      if (LeftChildKey == nil) ->
        % Child von Parent neuen Key referenzieren
        if (Position == 0) ->
          ModifyParentNode = [PrefixX, KeyX, [RightChildKey, RightChildX], HeightX, PredecessorX];
          true ->
            ModifyParentNode = [PrefixX, KeyX, [LeftChildX, RightChildKey], HeightX, PredecessorX]
        end;
        true ->
          % Child von Parent neuen Key referenzieren
          if (Position == 0) ->
            ModifyParentNode = [PrefixX, KeyX, [LeftChildKey, RightChildX], HeightX, PredecessorX];
            true ->
              ModifyParentNode = [PrefixX, KeyX, [LeftChildX, LeftChildKey], HeightX, PredecessorX]
          end
      end,

      % Das alte Key-Node Element muss rausgeworfen werden
      [ Part1, Part2 | NodeList ]= Tree,
      ModifyNodeList = [ X || X <- NodeList, lists:nth(2, X) /= Key ],

      ModifyTree = nodeInserter(ModifyNodeList, ParentKey, ModifyParentNode, [], Part1, Part2),
      ResultF = sort(ModifyTree),
      Result = incrementExecution(ResultF),
      makePicture(Result, File),
      Result
  end;
%% Dritte Variante
loeschenHelper(Tree, Key, File, LeftChildKey, RightChildKey) when (LeftChildKey /= nil) and (RightChildKey /= nil) ->
  % Maximalen Knoten in linken Teilbaum hollen
  MaxKey = getMaximumKey(Tree, Key),
  KeyNode = getNode(Tree, Key),
  [ Part1, Part2 | NodeList ]= Tree,
  [PrefixX, _KeyX, [LeftChildX, RightChildX], HeightX, PredecessorX] = KeyNode,
  ModifyKeyNode = [PrefixX, MaxKey, [LeftChildX, RightChildX], HeightX, PredecessorX],
  ModifyNodeList = [ X || X <- NodeList, lists:nth(2, X) /= MaxKey ],
  ModifyTree = nodeInserter(ModifyNodeList, Key, ModifyKeyNode, [], Part1, Part2),

  % Precondition Falls das zu loeschende Element kein Root Knoten ist
  ParentKey = getPredecessor(Tree, Key),
  %% Position: 1 -> rechts; 0 -> links
  [ _WhatEver, Position ] = getSuitablyChildKey(Tree, ParentKey, Key),

  if (ParentKey /= nil) ->
    %In diesen Fall muss der Vorgaenger auf den neuen Knoten zeigen!
    %Child von Parent neuen Key referenzieren
    if (Position == 0) ->
      ModifyTree2 = setLeftChildKey(ModifyTree, ParentKey, MaxKey);
      true ->
        ModifyTree2 = setRightChildKey(ModifyTree, ParentKey, MaxKey)
    end;
    true ->
      % Referenzen umbiegen
      ParentFromMaxKey = getPredecessor(Tree, MaxKey),
      ModifyTreeTODO = setRightChildKey(ModifyTree, ParentFromMaxKey, nil),
      ModifyTree2 = setPredecessor(ModifyTreeTODO, ParentFromMaxKey, MaxKey),
      ModifyTree2
  end,
  ResultF = incrementExecution(ModifyTree2),
  Result = sort(ResultF),
  makePicture(Result, File),
  Result;
loeschenHelper(_Tree, _Key, _File, _LeftChildKey, _RightChildKey) ->
  soEinFallExestiertNichtERROR_ERROR_ERROR_ERROR_ERROR_ERROR_ERROR_ERROR_ERROR.

%% Precondtion bal(v) = h(Tr) – h(Tl) ∈ {-1,0,1}
%% Funktion ermittelt ob ein Baum die AVL-Bedingung verletzt hat/nicht ausbalanciert ist.
%% Ganz automatisch balanciert er den Baum wieder mittels der Rotationen aus.
%% @param AVL-ADT Tree - Die Abstrakte Datenstruktur AVL-Baum
%% @param Integer Key - Der Schluessel der zuletzt an dem Baum gehaengt wurde,
%%                      von diesen Key wird geprueft ob die AVL-Bedingung mittels bottom-up verletzt wurde
toBalanceOut(Tree, Key, File) ->

  % Hier steht ueber welchen Node rotiert werden soll und welche Rotation notwendig sei
  % Result Example = [ 43, [0, 0] ]
  % [0, 0] -> Rechtsrotation; [1, 1] -> Linksrotation;
  % [1, 0] -> Doppelte Rechtsrotation; [0, 1] -> Doppelte Linksrotation
  [ToRotateKey, RotationCode] = toBalanceOutHelper(Tree, Key, [], getHeight(Tree, Key)),

  if ([0, 0] == RotationCode) ->
       rechtsrotation(Tree, ToRotateKey, File);
    ([0, 1] == RotationCode) ->
       doppelLinksrotation(Tree, ToRotateKey, File);
    ([1, 0] == RotationCode) ->
       doppelRechtsrotation(Tree, ToRotateKey, File);
    ([1, 1] == RotationCode) ->
      linksrotation(Tree, ToRotateKey, File);
    true ->
      Tree
  end.

toBalanceOutHelper(Tree, Key, DirectionList, FinalDeep) ->
  ParentKey = getPredecessor(Tree, Key),

  % Abbruchbedingung falls keine Rotation notwendig ist
  if (ParentKey == nil) ->
    ["Hund", "Rotation ist  nicht notwendig"];
  true ->

    % Maximale Tiefe zu gegenueber liegenden Teilbaum
    MaxDeepFromParentNode_Prototyp = getMaxDeep(Tree, lists:nth(1, getSuitablyChildKey(Tree, ParentKey, Key))),

    % Pruefung falls MaxDeepFromParent 0 ist, heisst wir haben versucht auf nil zuzugreifen und deswegen nehmen wir die Tiefe von seinen Eltern Node
    if (MaxDeepFromParentNode_Prototyp == 0) ->
      MaxDeepFromParentNode = getHeight(Tree, ParentKey);
    true ->
      MaxDeepFromParentNode = MaxDeepFromParentNode_Prototyp
    end,

    %% Precondtion bal(v) = h(Tr) – h(Tl) ∈ {-1,0,1}
    if ( FinalDeep > (MaxDeepFromParentNode + 1) ) ->
      ResultDirectionList = DirectionList ++ [lists:nth(2,  getSuitablyChildKey(Tree, ParentKey, Key))],
      [ ParentKey, [lists:nth(length(ResultDirectionList) - 1, ResultDirectionList) , lists:last(ResultDirectionList) ] ];
    true ->
     toBalanceOutHelper(Tree, ParentKey, DirectionList ++ [lists:nth(2,  getSuitablyChildKey(Tree, ParentKey, Key))], FinalDeep)
    end

   end.

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
          makePicture(ResultTree, File),
          %% Pruefen ob der AVL baum ausbalanciert werden muss,
          toBalanceOut(ResultTree, Key, File)
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

          %% Pruefen ob der AVL baum ausbalanciert werden muss,
          %toBalanceOut(ResultTree, Key, "")
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
  %timer:sleep(1000),
  [ NewHead | NewTail ] = Tail,
  listEinfuegenHelper(ModifyTree, NewHead, NewTail, File).

%% Diese funktion fuegt Elemente aus ganzer liste nacheinander in eine ADT ein
insertKeyFromListWithoutPicture(Tree, KeyList) ->
  [ Head | Tail ] = KeyList,
  listEinfuegenHelperWithoutPicture(Tree, Head, Tail).
listEinfuegenHelperWithoutPicture(Tree, Head, []) -> einfuegenWithoutPicture(Tree, Head);
listEinfuegenHelperWithoutPicture(Tree, Head, Tail) ->
  ModifyTree = einfuegenWithoutPicture(Tree, Head),
  [ NewHead | NewTail ] = Tail,
  listEinfuegenHelperWithoutPicture(ModifyTree, NewHead, NewTail).

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

%% Funktion tauscht einen Node aus START
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

%=================================================================================================================================================
%                                                                     GETTER
%=================================================================================================================================================
% Gibt die Maximalen Key
getMaximumKey(Tree, Key) ->
  getMaximumKeyHelper(Tree, getLeftChildKey(Tree, Key), Key).
getMaximumKeyHelper(_Tree, Key, Result) when Key == nil -> Result;
getMaximumKeyHelper(Tree, Key, _Result) ->
  getMaximumKeyHelper(Tree, getRightChildKey(Tree, Key), Key).

%% Funktion gibt das Kind zum Parent Key das != Key ist
%% Sowie auf welcher Seite der Key von Parent liegt
%% 1 -> rechts; 0 -> links
getSuitablyChildKey(Tree, ParentKey, Key) ->
  ChildKeyLeft = getLeftChildKey(Tree, ParentKey),
  ChildKeyRight = getRightChildKey(Tree, ParentKey),
  if (Key == ChildKeyLeft) ->
    [ChildKeyRight, 0];
    true ->
      [ChildKeyLeft, 1]
  end.

%% Diese Funktion ermittelt die maximale Tiefe die an den Node Key dran haengt
%% @param AVL-Baum Tree - AVL Baum auf dem gearbeitet wird
%% @para Integer Key - Schluessel von dem aus nachgeschaut wird
%% @result - Der tiefste Punkt als Integer Wert
getMaxDeep(_Tree, Key) when Key == nil -> 0;
getMaxDeep(Tree, Key) ->
  getMaxDeepHelper(Tree, [Key], [getHeight(Tree, Key)]).
getMaxDeepHelper(_Tree, [], DeepList) -> lists:max(DeepList);
getMaxDeepHelper(Tree, KeyList, DeepList) ->
  Key = lists:nth(1, KeyList),
  LeftKey = getLeftChildKey(Tree, Key),
  RightKey = getRightChildKey(Tree, Key),
  ModifyKeyList = lists:delete(Key, KeyList),

  if (LeftKey == nil) ->
    ModifyKeyList2 = ModifyKeyList,
    ModifyDeepList = DeepList;
    true ->
      ModifyKeyList2 = ModifyKeyList ++ [LeftKey],
      ModifyDeepList = DeepList ++ [getHeight(Tree, LeftKey)]
  end,

  if (RightKey == nil) ->
    ModifyKeyList3 = ModifyKeyList2,
    ModifyDeepList2 = ModifyDeepList;
    true ->
      ModifyKeyList3 = ModifyKeyList2 ++ [RightKey],
      ModifyDeepList2 = ModifyDeepList ++ [getHeight(Tree, RightKey)]
  end,
  getMaxDeepHelper(Tree, ModifyKeyList3, ModifyDeepList2).

%% Gibt den linken Knoten von einem Schluessel
%% @return Key
getLeftChildKey(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getLeftChildHelper(Tree, Key, Boolean).
getLeftChildHelper(_Tree, _Key, Bool) when Bool == false -> io:fwrite("key is not integer"), nil;
getLeftChildHelper(Tree, Key, _Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [LeftKey, _RightKey], _Height, _KeyTyp] = Node,
  LeftKey.

%% Gibt den rechten Knoten von einem Schluessel
%% @return Key
getRightChildKey(Tree, Key) ->
  Boolean = isAvailable(Tree, Key),
  getRightChildHelper(Tree, Key, Boolean).
getRightChildHelper(_Tree, _Key, Bool) when Bool == false -> io:fwrite("key not found"), nil;
getRightChildHelper(Tree, Key, _Bool) ->
  Node = getNode(Tree, Key),
  [_Prefix, _NodeKey, [_LeftKey, RightKey], _Height, _KeyTyp] = Node,
  RightKey.

%% TODO: Preconditon, falls der Schuessel nicht vorhanden ist
%% Gibt einen gesamten Knoten zu einen Schluessel
%% @return Node
getNode(_Tree, Key) when is_integer(Key) == false -> nil;
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

%% Gibt die Hoehe von einen Node zurueck
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

%% Gibt die Hoehe eines Nodes zurueck
getHeight(Node) ->
  lists:nth(4, Node).

%% Gibt die Ausfuehrung Anzahl einer ADT zurueck
getExecuteNumber(Tree) ->
  lists:nth(1, Tree).

