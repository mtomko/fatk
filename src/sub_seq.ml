open Core.Std
open Extensions

let sub_seq file_name seq_name seq_number start length =
  let p = Fatk.matcher seq_name seq_number in
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
