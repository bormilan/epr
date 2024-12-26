%%%-------------------------------------------------------------------
%% @doc epr public API
%% @end
%%%-------------------------------------------------------------------

-module(epr_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    epr_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
