open Core.Std
open Extensions

let list_seqs file_name print_lengths =
  let item_stream : Fasta.item Stream.t = Fatk.item_stream_of file_name in
  Fatk.with_each_item
    (fun (fa : Fasta.item) ->
     let () = print_string fa.name in
     if print_lengths then
       let () = print_string "\t" in
       let () = print_int (String.length fa.sequence) in
       print_endline ""
     else
       print_endline ""
    )
    file_name
       
let cmd =
  Command.basic
    ~summary:"List the sequences in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: file)
    +> flag "-l" no_arg ~doc: " list sequence lengths"
  )
  (fun file_name print_lengths () -> list_seqs file_name print_lengths)


