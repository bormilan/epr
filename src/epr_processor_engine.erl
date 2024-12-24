-module(epr_processor_engine).

-export([init/1, run/1]).

init(Filenames) ->
    %TODO: I want to add some error handling and only
    %return those that are passed. Now we return all.
    A = lists:map(fun(FileName) ->
                epr_processor_server:start_link(FileName)
              end,
              Filenames),
    io:format(user, "~n----------------------------------~n", []),
    io:format(user, "A: ~p~n", [A]),
    io:format(user, "------------------------------------~n", []),
    A.

run(PidList) ->
    lists:map(fun({ok, Pid}) ->
                spawn(gen_server, call, [Pid, run])
              end,
              PidList),
    receive
        Cucc -> 
            io:format(user, "~n----------------------------------~n", []),
            io:format(user, "B: ~p~n", [Cucc]),
            io:format(user, "------------------------------------~n", [])
    end.

