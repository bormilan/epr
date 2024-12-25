-module(epr_processor_engine).

-export([init/1, run/1]).

init(Filenames) ->
    %TODO: I want to add some error handling and only
    %return those that are passed. Now we return all.
    {_, AggServerPid} = epr_data_aggregator_server:start_link(),
    lists:map(fun(FileName) -> epr_processor_server:start_link(FileName, AggServerPid) end,
              Filenames).

run(PidList) ->
    lists:map(fun({ok, Pid}) -> spawn(gen_server, cast, [Pid, run]) end, PidList).
