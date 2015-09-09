open OUnit2

let () =
  run_test_tt_main ~exit
  ("fatk">::: [Extensions_test.suite;
               Fasta_test.suite;
               Integration_test.suite])
