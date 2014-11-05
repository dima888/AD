%%%-------------------------------------------------------------------
%%% @author foxhound
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% Pseudocode:
%%% prozedur SelectionSort( A : Liste sortierbarer Elemente )
%%%   n = Länge( A )
%%%   links = 0
%%%   wiederhole
%%%     min = links
%%%     für jedes i von links + 1 bis n wiederhole
%%%       falls A[ i ] < A[ min ] dann
%%%         min = i
%%%       ende falls
%%%     ende für
%%%     Vertausche A[ min ] und A[ links ]
%%%     links = links + 1
%%%   solange links < n
%%% prozedur ende

%%%
%%% @end
%%% Created : 28. Okt 2014 11:40
%%%-------------------------------------------------------------------
-module(selectionSort).
-author("foxhound").

%% API
-export([selectionS/3]).

%% Einzige Schnittstelle nach aussen
selectionS(Array, Von, Bis) ->
  %N = arrayS:lengthA(Array),
  I = Von,
  N = Bis,
  Links = Von,

  %psydoCodeWiederholle(Array, Von, Bis, N, Links, 0).
  psydoCodeWiederholle(Array, I, N, Links).

%=================================================================================================================================================
%                                                 Sortieralogorithmus Komponenten ohne verlangsamung
%=================================================================================================================================================

%%%   wiederhole
%%%     min = links
%%        InnereSchleife
%%%     Vertausche A[ min ] und A[ links ]
%%%     links = links + 1
%%%   solange links < n
%psydoCodeWiederholle(Array, Von, Bis, N, Links, I) when not(Links < N) -> Array;
%psydoCodeWiederholle(Array, Von, Bis, N, Links, I) ->
psydoCodeWiederholle(Array, I, N, Links) when not(Links < N) -> Array;
psydoCodeWiederholle(Array, I, N, Links) ->

  Min = Links,

  %ModifyMin = psydoCodeFuerJedesIvonLinks(Array, Von, Bis, N, Links, I, Min),
  ModifyMin = psydoCodeFuerJedesIvonLinks(Array, I, N, Links, Min),

  % Elemente zum vertauschen beschaffen
  ArrayMin = arrayS:getA(Array, ModifyMin),
  ArrayLinks = arrayS:getA(Array, Links),

  % Vertausche Array[ min ] und Array[ links ]
  ModifyArray = arrayS:setA(Array, Links, ArrayMin),
  ModifyArray2 = arrayS:setA(ModifyArray, ModifyMin, ArrayLinks),

  %psydoCodeWiederholle(ModifyArray2, Von, Bis, N, Links + 1, I + 1).
  psydoCodeWiederholle(ModifyArray2, I + 1, N, Links + 1).


%%%     für jedes i von links + 1 bis n wiederhole
%%%       falls A[ i ] < A[ min ] dann
%%%         min = i
%%%       ende falls
%%%     ende für
%psydoCodeFuerJedesIvonLinks(Array, Von, Bis, N, Links, I, Min) when (I >= N) -> Min;
%psydoCodeFuerJedesIvonLinks(Array, Von, Bis, N, Links, I, Min) ->
psydoCodeFuerJedesIvonLinks(Array, I, N, Links, Min) when (I >= N) -> Min;
psydoCodeFuerJedesIvonLinks(Array, I, N, Links, Min) ->



  AvonI = arrayS:getA(Array, I),
  AvonMin = arrayS:getA(Array, Min),

  %io:fwrite("( A[i] < A[min] )  => "), io:write(AvonI), io:fwrite(" - "), io:write(AvonMin), io:nl(),

  if ( AvonI < AvonMin ) ->
        %psydoCodeFuerJedesIvonLinks(Array, Von, Bis, N, Links, I + 1, I);
        psydoCodeFuerJedesIvonLinks(Array, I + 1, N, Links, I);

    true ->
      %psydoCodeFuerJedesIvonLinks(Array, Von, Bis, N, Links, I + 1, Min)
      psydoCodeFuerJedesIvonLinks(Array, I + 1, N, Links, Min)
  end.

























