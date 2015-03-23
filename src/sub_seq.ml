open Core.Std
open Extensions

let match_name name elt =
  let (item : Fasta.Item.t) = (fst elt) in item.name = name

let match_num num elt =
  let idx = (snd elt) in idx = num

let sub_seq file_name seq_name seq_number start length =
  let p =
    match seq_name, seq_number with
    | Some name, _ -> (match_name name)
    | None, Some num -> (match_num num)
    | _ -> failwith "Either sequence name or sequence number must be specified" in
  let f (elt: (Fasta.Item.t * int)) =
    match elt with
    | (item, _) ->
      print_endline (String.sub item.sequence ~pos:(start - 1) ~len: length) in
  Fatk.with_matching_items file_name ~p ~f

let cmd =
  Command.basic
    ~summary:"Print a substring in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: string)
    +> anon (maybe ("seq_name" %: string))
    +> flag "-n" (optional int) ~doc:"seq_num The sequence number to print"
    +> flag "-s" (required int) ~doc: " start position (1-based)"
    +> flag "-l" (required int) ~doc: " length"
  )
  (fun file_name seq_name seq_number start length () -> sub_seq file_name seq_name seq_number start length)
