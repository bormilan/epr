-module(epr_processor_server).

-behaviour(gen_server).

-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-type state() :: #{file_name => string(), aggregator_server => pid()}.

-export_type([state/0]).

-ifdef(TEST).

-export([process_data/1]).

-endif.

%%% Client API
start_link(FileName, AggServer) ->
    gen_server:start_link(?MODULE, {FileName, AggServer}, []).

-spec init({FileName :: string(), AggServer :: pid()}) -> {ok, state()}.
init({FileName, AggServer}) ->
    {ok, #{file_name => FileName, aggregator_server => AggServer}}.

handle_cast(run, #{file_name := FileName, aggregator_server := AggServer} = State) ->
    Command = "python3 " ++ FileName,
    Port = open_port({spawn, Command}, [binary, exit_status]),

    receive
        {Port, {data, Data}} ->
            ProcessedData = process_data(Data),
            gen_server:cast(AggServer, {add_data, FileName, ProcessedData})
    end,

    {noreply, State};
handle_cast(stop, State) ->
    {stop, normal, State}.

handle_call(_, _, State) ->
    {reply, ok, State}.

terminate(normal, State) ->
    io:format(user, "Processor terminated with file name: ~p~n", [State]),
    ok.

%%%%%%%%%%%%%%%%%%%%%
%%% Private functions
%%%%%%%%%%%%%%%%%%%%%

process_data(Data) ->
    string:trim(binary_to_list(Data)).
