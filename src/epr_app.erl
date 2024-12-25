%%%-------------------------------------------------------------------
%% @doc epr public API
%% @end
%%%-------------------------------------------------------------------

-module(epr_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    ProcessingFiles = ["python/processing.py", "python/processing2.py"],

    Pids = epr_processor_engine:init(ProcessingFiles),
    epr_processor_engine:run(Pids),

    epr_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
