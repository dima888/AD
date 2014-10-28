%%%-------------------------------------------------------------------
%%% @author foxhound
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Okt 2014 16:33
%%%-------------------------------------------------------------------
-module(myIO).
-author("foxhound").

%% API
-export([writeInNewFile/2, readFromFile/1]).

%% Erstellt eine neue Datei, falls eine schon vorhanden ist, wird sie geloescht
%% @param String Path - Pfad wo die Datei abgelegt werden soll
%% @param Object Input - Inhalt der rein geschrieben werden soll
%% @result ok oder error
writeInNewFile(File, Input) ->
  ModifyInput = lists:flatten(io_lib:format("~p", [Input])),
  file:delete(File),
  {ok, MyFile} = file:open(File, [write]),
  file:write(MyFile, ModifyInput),
  file:close(MyFile).

%% Liest aus einer Datei den Inhalt und konvertiert den in eine Liste
%% Voraussetzung es ist z.B. so in der Datei gespeichert: [1,2,3,4,5]
%% @param String File - Der Pfad zur Datei
%% @result List
readFromFile(File) ->
  if (File == nil) ->
    ModifyFile = "logFiles/sort1/zahlen.dat";
    true ->
      ModifyFile = File
  end,
  {ok, BinaryResult} = file:read_file(ModifyFile),
  toRealList(binary_to_list(BinaryResult)).

%=================================================================================================================================================
%                                                     HILFS FUNKTIONEN
%=================================================================================================================================================
toRealList(List) ->
  lists:map(fun(X) -> {Int, _} = string:to_integer(X),
    Int end,
    string:tokens(List, "[, \n") ).


