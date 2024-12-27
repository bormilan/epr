-module(epr_test).

-include_lib("eunit/include/eunit.hrl").

workflow_test() ->
    ProcessingFiles =
        ["test/epr_test_python_data/processing.py", "test/epr_test_python_data/processing2.py"],

    {Aggregator, Pids} = epr:init(ProcessingFiles),
    epr:run(Pids),

    timer:sleep(1000),
    State = gen_server:call(Aggregator, get_state),

    ?assertEqual(#{"test/epr_test_python_data/processing.py" => "szia lajos",
                   "test/epr_test_python_data/processing2.py" => "szia sanyi"},
                 State),

    epr:shutdown(Aggregator, Pids),
    ok.

windows_result_test() ->
    ?assertEqual("szia lajos", epr_processor_server:process_data(<<"szia lajos\r\n">>)),
    ok.
