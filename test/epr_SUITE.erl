-module(epr_SUITE).

-behaviour(ct_suite).

-elvis([{elvis_style, atom_naming_convention, disable}]).

-type config() :: [{atom(), term()}].

-export_type([config/0]).

-export([all/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([run_hello_world_from_python/1]).

-elvis([{elvis_style, no_block_expressions, disable}]).

-dialyzer({no_underspecs, all/0}).

-spec all() -> [atom()].
all() ->
    [run_hello_world_from_python].

-spec init_per_suite(config()) -> config().
init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(epr),
    Config.

-spec end_per_suite(config()) -> config().
end_per_suite(Config) ->
    application:stop(epr),
    Config.

-spec run_hello_world_from_python(Config :: config()) -> ok.
run_hello_world_from_python(_Config) ->
    ok.
