%%%-------------------------------------------------------------------
%%% @author Team: 4
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Okt 2014 16:33
%%%-------------------------------------------------------------------
-module(utility).

%% API
-export([writeInNewFile/2, readFromFile/1, getTimestampInMilliSeconds/0, addListInArrayS/3, arrayStoList/1, giveDefaultFile/1
        , averageValue/1, toString/1, writeInNewFileWithoutDelete/2, writeInNewFileWithoutDeleteWithoutNL/2  ]).

%% Erstellt eine neue Datei, falls eine schon vorhanden ist, wird sie geloescht
%% @param String File - Pfad wo die Datei abgelegt werden soll
%% @param Object Input - Inhalt der rein geschrieben werden soll
%% @result ok oder error
writeInNewFile(File, Input) ->
  ModifyFile = giveDefaultFile(File),
  ModifyInput = lists:flatten(io_lib:format("~p", [Input])),
  file:delete(ModifyFile ),
  {ok, MyFile} = file:open(ModifyFile , [write]),
  file:write(MyFile, ModifyInput ++ "\n"),
  file:close(MyFile).

writeInNewFileWithoutDelete(File, Input) ->
  ModifyFile = giveDefaultFile(File),
  ModifyInput = lists:flatten(io_lib:format("~p", [Input])),

  {ok, MyFile} = file:open(ModifyFile , [append]),
  file:write(MyFile, ModifyInput ++ "\n"),
  file:close(MyFile).

writeInNewFileWithoutDeleteWithoutNL(File, Input) ->
  ModifyFile = giveDefaultFile(File),
  ModifyInput = lists:flatten(io_lib:format("~p", [Input])),

  {ok, MyFile} = file:open(ModifyFile , [append]),
  file:write(MyFile, ModifyInput),
  file:close(MyFile).

%% Liest aus einer Datei den Inhalt und konvertiert den in eine Liste
%% Voraussetzung es ist z.B. so in der Datei gespeichert: [1,2,3,4,5]
%% @param String File - Der Pfad zur Datei
%% @result List
readFromFile(File) ->
  ModifyFile = giveDefaultFile(File),
  {ok, BinaryResult} = file:read_file(ModifyFile),
  ListWithNull = toRealList(binary_to_list(BinaryResult)),
  lists:delete(lists:last(ListWithNull), ListWithNull).

%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================
toRealList(List) ->
  lists:map(fun(X) -> {Int, _} = string:to_integer(X),
    Int end,
    string:tokens(List, "[, \n") ).


getTimestampInMilliSeconds() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega * 1000000 + Sec) * 1000 + round(Micro/1000).

%% Fuegt die Elemente aus einer Liste ins Array
addListInArrayS(Array, List, AryPositon) ->
  [Head | Tail] = List,
  addListInArrayS(Array, Head, Tail, AryPositon).
addListInArrayS(Array, Head, [], CurrentAryPos) -> arrayS:setA(Array, CurrentAryPos, Head);
addListInArrayS(Array, Head, Tail, CurrentAryPos) ->
  [NewHead | NewTail] = Tail,
  addListInArrayS(arrayS:setA(Array, CurrentAryPos, Head), NewHead, NewTail, CurrentAryPos + 1).

%% Funktion macht ein arrayS zur einer Erlang Liste
arrayStoList(Array) ->
  arrayStoList(Array, 0, arrayS:lengthA(Array) - 1, []).
arrayStoList(_Array, CurrentIndex, LastIndex, ResultList) when CurrentIndex > LastIndex -> ResultList;
arrayStoList(Array, CurrentIndex, LastIndex, ResultList) ->
  arrayStoList(Array, CurrentIndex + 1, LastIndex, ResultList ++ [arrayS:getA(Array, CurrentIndex)]).

%% Gibt den Zahlen Pfad zurueck
giveDefaultFile(File) ->
  if (File == zahlen) ->
    NewPath = "logFiles/sort1/zahlen.dat";
    (File == sortiert) ->
      NewPath = "logFiles/sort1/sortiert.dat";
    (File == messung) ->
      "logFiles/sort1/messung.log";
    true ->
      NewPath = File
  end.

%% Diese Funktion berechnet den Mittelwert!
averageValue(List) ->
  [Head | Tail] = List,
  averageValue(Head, Tail, 0, length(List)).
averageValue(Head, Tail, AverageValue, Lengh) when Tail == [] -> trunc((AverageValue + Head) / Lengh);
averageValue(Head, Tail, AverageValue, Length) ->
  [NewHead | NewTail] = Tail,
  averageValue(NewHead, NewTail, AverageValue + Head, Length).


toString(Object) ->
  lists:flatten(io_lib:format("~p", [Object])).







