open OUnit2

let () =
  run_test_tt_main ~exit
  ("fatk">::: [Extensions_test.suite])
