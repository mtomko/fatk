open OUnit2
open Extensions

(* Some simple test data *)
let alist = ["foo"; "bar"; "baz"; "quux"]

let elist = []

(* Test cases *)
let filter_test _ =
  let starts_with c s = s.[0] = c in
  let expected = ["bar"; "baz"] in
  let input = Stream.of_list alist in
  let actual = Stream.filter ~pred:(starts_with 'b') ~stream:input in
  let actual_list = Stream.npeek 3 actual in
  assert_equal expected actual_list

let zip_with_index_test _ =
  let expected = [("foo", 1); ("bar", 2); ("baz", 3); ("quux", 4)] in
  let input = Stream.of_list alist in
  let actual = Stream.zip_with_index input ~base:1 in
  let actual_list = Stream.npeek 4 actual in
  assert_equal expected actual_list

(* Suite *)
let suite = "suite">:::
  ["filter_test">:: filter_test;
   "zip_with_index_test">:: zip_with_index_test]
