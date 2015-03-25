open Core_kernel.Std
open OUnit2

let seq = "ACTGTGTGTGCAGTCAGTGCCCCTTTGAGCCGTATCGCA"

let seq_name = "gi|389389|Martian Mitochondrion, complete genome"

let to_string_test _ =
  let item = { Fasta.Item.name = seq_name; sequence = seq } in
  let expected = String.concat [">"; seq_name; "\n"; seq] in
  let actual = Fasta.to_string item in
  assert_equal expected actual

(* Suite *)
let suite = "fasta_test">:::
  ["to_string_test">:: to_string_test]
