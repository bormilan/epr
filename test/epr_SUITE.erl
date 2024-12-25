-module(epr_SUITE).

-behaviour(ct_suite).

-elvis([{elvis_style, atom_naming_convention, disable}]).

-type config() :: [{atom(), term()}].

-export_type([config/0]).

-export([all/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([start_test/1]).

-elvis([{elvis_style, no_block_expressions, disable}]).

-dialyzer({no_underspecs, all/0}).

-spec all() -> [atom()].
all() ->
    [start_test].

-spec init_per_suite(config()) -> config().
init_per_suite(Config) ->
    {ok, _} = application:ensure_all_started(epr),
    Config.

-spec end_per_suite(config()) -> config().
end_per_suite(Config) ->
    application:stop(epr),
    Config.

-spec start_test(Config :: config()) -> {ok, ok}.
start_test(_Config) ->
    ok.
