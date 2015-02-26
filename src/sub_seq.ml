open Core.Std
open Extensions

let sub_seq file_name seq_name start length =
  Fatk.with_items
    (fun stream ->
     let matching_seqs =
       Stream.filter ~pred:(fun (f: Fasta.Item.t) -> f.name = seq_name) ~stream in
     let handler (item: Fasta.Item.t) =
       print_endline (String.sub item.sequence ~pos:(start - 1) ~len: length) in
     Stream.iter handler matching_seqs) file_name

let cmd =
  Command.basic
    ~summary:"Print a substring in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: string)
    +> anon ("seq_name" %: string)
    +> flag "-s" (required int) ~doc: " start position (1-based)"
    +> flag "-l" (required int) ~doc: " length"
  )
  (fun file_name seq_name start length () -> sub_seq file_name seq_name start length)
                     
       
       
