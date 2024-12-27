-module(epr_data_aggregator_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-type state() :: map().

-export_type([state/0]).

start_link() ->
    gen_server:start_link(?MODULE, #{}, []).

-spec init(map()) -> {ok, state()}.
init(Param) ->
    {ok, Param}.

handle_cast({add_data, Id, Data}, State) ->
    NewState = State#{Id => Data},
    {noreply, NewState};
handle_cast(stop, State) ->
    {stop, normal, State}.

handle_call(get_state, _From, State) ->
    {reply, State, State}.

terminate(normal, State) ->
    io:format(user, "Processor terminated with state: ~p~n", [State]),
    ok.
