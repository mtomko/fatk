open Core.Std
open OUnit2

let test_data = "test-data/"

let simple_file = String.concat [test_data; "short.fasta"]

let scaffolds_file = String.concat [test_data; "scaffolds.fna"]

let program = "bin/fatk"

let list_of_stream stream =
  let result = ref [] in
  Stream.iter (fun value -> result := value :: !result) stream;
  List.rev !result

let string_of_stream stream =
  let chars = list_of_stream stream in
  String.of_char_list chars

let list_seqs_test ctxt =
  let expected = String.concat
    ~sep:"\n"
    ["Scaffold_0"; "Scaffold_1"; "Scaffold_2"; "Scaffold_3"; "Scaffold_4\n"] in
  let foutput stream =
    let actual = string_of_stream stream in
    assert_equal expected actual
  in
  assert_command ~ctxt ~foutput program ["list"; scaffolds_file]

let suite = "integration_test">:::
  ["list_seqs_test">:: list_seqs_test]
