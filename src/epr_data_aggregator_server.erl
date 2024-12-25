-module(epr_data_aggregator_server).
-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2]).

-type state() :: map().

start_link() ->
    gen_server:start_link(?MODULE, #{}, []).

-spec init(map()) -> {ok, state()}.
init(Param) -> {ok, Param}.

handle_cast({add_data, Id, Data}, State) ->
    NewState = State#{Id => Data},
    io:format(user, "~n----------------------------------~n", []),
    io:format(user, ": ~p~n", [NewState]),
    io:format(user, "------------------------------------~n", []),
    {noreply, NewState}.

handle_call(_, _, _) -> ok.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, State) ->
    io:format(user, "Processor terminated with file name: ~p~n", [State]),
    ok;
terminate(Error, _State) ->
    io:format(user, "Error: ~p~n", [Error]),
    ok.
