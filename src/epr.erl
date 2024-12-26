-module(epr).

-compile({nowarn_unused_function, [init/1, run/1, shutdown/2]}).

-ifdef(TEST).

-export([init/1, run/1, shutdown/2]).

-endif.

init(Files) ->
    ProcessingFiles = Files,
    {_, AggServerPid} = epr_data_aggregator_server:start_link(),

    Pids =
        lists:map(fun(FileName) ->
                     {ok, Pid} = epr_processor_server:start_link(FileName, AggServerPid),
                     Pid
                  end,
                  ProcessingFiles),

    {AggServerPid, Pids}.

run(Pids) ->
    lists:map(fun(Pid) -> spawn(gen_server, cast, [Pid, run]) end, Pids).

shutdown(AggServerPid, ProcessorPids) ->
    Pids = [AggServerPid | ProcessorPids],
    % gen_server:cast(AggServerPid, stop),
    lists:map(fun(Pid) -> gen_server:cast(Pid, stop) end, Pids).
