-module(epr_processor_server).
-behaviour(gen_server).

-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2]).

-type state() :: #{file_name => string(), aggregator_server => pid()}.

%%% Client API
start_link(FileName, AggServer) ->
    gen_server:start_link(?MODULE, {FileName, AggServer}, []).

-spec init(FileName :: string()) -> {ok, state()}.
init({FileName, AggServer}) ->
    {ok, #{file_name => FileName
          , aggregator_server => AggServer}}.

handle_cast(run, #{file_name := FileName, aggregator_server := AggServer} = State) ->
    Command = "python3 " ++ FileName,
    Port = open_port({spawn, Command}, [binary, exit_status]),
    loop(Port, FileName, AggServer),

    {noreply, State}.

handle_call(_, _, _) -> ok.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, State) ->
    io:format(user, "Processor terminated with file name: ~p~n", [State]),
    ok;
terminate(Error, State) ->
    io:format(user, "Error: ~p~n", [Error]),
    io:format(user, "State: ~p~n", [State]),
    ok.

%%%%%%%%%%%%%%%%%%%%%
%%% Private functions
%%%%%%%%%%%%%%%%%%%%%

loop(Port, FileName, AggServer) ->
    receive
        {Port, {data, Data}} ->
            gen_server:cast(AggServer, {add_data, FileName, Data}),
            loop(Port, FileName, AggServer);
        {Port, closed} ->
            io:format("Python script finished~n"),
            ok
    end.

