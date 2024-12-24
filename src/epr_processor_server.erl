-module(epr_processor_server).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2]).

-type state() :: #{file_name => string()}.

%%% Client API
start_link(FileName) ->
    io:format(user, "~n----------------------------------~n", []),
    io:format(user, "~p~n", [FileName]),
    io:format(user, "------------------------------------~n", []),
    gen_server:start_link(?MODULE, FileName, []).

-spec init(FileName :: string()) -> {ok, state()}.
init(FileName) -> {ok, #{file_name => FileName}}.

handle_call(run, _From, #{file_name := FileName} = State) ->
    {reply, run_python_script(FileName), State}.

handle_cast(_, _) -> ok.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, State) ->
    io:format(user, "Processor terminated with file name: ~p~n", [State]),
    ok.

%%% Private functions
run_python_script(FileName) ->
    Command = "python3 " ++ FileName,
    io:format(user, "~n----------------------------------~n", []),
    io:format(user, "~p~n", [Command]),
    io:format(user, "------------------------------------~n", []),
    % "python/processing.py",
    Port = open_port({spawn, Command}, [binary, exit_status]),
    loop(Port).

loop(Port) ->
    receive
        {Port, {data, Data}} ->
            io:format("Python output: ~s", [Data]),
            loop(Port);
        {Port, closed} ->
            io:format("Python script finished~n"),
            ok
    end.

