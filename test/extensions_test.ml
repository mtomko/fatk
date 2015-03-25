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

let zip_with_index_test0 _ =
  let expected = [("foo", 0); ("bar", 1); ("baz", 2); ("quux", 3)] in
  let input = Stream.of_list alist in
  let actual = Stream.zip_with_index input (* use the default base 0 *) in
  let actual_list = Stream.npeek 5 actual in
  assert_equal expected actual_list

let zip_with_index_test1 _ =
  let expected = [("foo", 1); ("bar", 2); ("baz", 3); ("quux", 4)] in
  let input = Stream.of_list alist in
  let actual = Stream.zip_with_index input ~base:1 in
  let actual_list = Stream.npeek 4 actual in
  assert_equal expected actual_list

(* Suite *)
let suite = "extensions_test">:::
  ["filter_test">:: filter_test;
   "zip_with_index_test0">:: zip_with_index_test0;
   "zip_with_index_test1">:: zip_with_index_test1]
