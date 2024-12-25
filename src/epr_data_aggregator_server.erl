-module(epr_data_aggregator_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-type state() :: map().

-export_type([state/0]).

start_link() ->
    gen_server:start_link(?MODULE, #{}, []).

-spec init(map()) -> {ok, state()}.
init(Param) ->
    {ok, Param}.

handle_cast({add_data, Id, Data}, State) ->
    NewState = State#{Id => Data},
    io:format(user, ": ~p~n", [NewState]),
    {noreply, NewState}.

handle_call(_, _, State) ->
    {reply, ok, State}.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n", [Msg]),
    {noreply, State}.

terminate(normal, State) ->
    io:format(user, "Processor terminated with file name: ~p~n", [State]),
    ok;
terminate(Error, _State) ->
    io:format(user, "Error: ~p~n", [Error]),
    ok.
