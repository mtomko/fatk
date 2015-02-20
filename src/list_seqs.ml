open Core.Std
open Extensions

let list_seqs file_name =
  let file_in = in_channel_of file_name in
  let item_stream = Fasta.fasta_stream_of_channel file_in in
  try
    Stream.iter (fun (fa : Fasta.item) -> print_endline fa.name) item_stream
  with e ->
    close_in_noerr file_in;
    raise e
       
let cmd =
  Command.basic
    ~summary:"List the sequences in the provided FASTA file"
    Command.Spec.(empty +> anon ("file" %: file))
                   (fun file_name () -> list_seqs file_name)


