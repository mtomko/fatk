open Core.Std
open Extensions

let list_seqs file_name print_lengths =
  let file_in = in_channel_of file_name in
  let item_stream = Fasta.fasta_stream_of_channel file_in in
  try
    Stream.iter
      (fun (fa : Fasta.item) ->
       let () = print_string fa.name in
       if print_lengths then
         let () = print_string "\t" in
         let () = print_int (String.length fa.sequence) in
         print_endline ""
       else
         print_endline ""
       )
      item_stream
  with e ->
    close_in_noerr file_in;
    raise e
       
let cmd =
  Command.basic
    ~summary:"List the sequences in the provided FASTA file"
    Command.Spec.(
    empty
    +> anon ("file" %: file)
    +> flag "-l" no_arg ~doc: " list sequence lengths"
  )
  (fun file_name print_lengths () -> list_seqs file_name print_lengths)


