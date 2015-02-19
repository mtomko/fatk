open Core.Std

(*let trace = Log.make_trace "fatk"*)

(*let info = Log.make_info "fatk"*)

let in_channel_of file_name =
  if file_name = "-" then stdin
  else open_in file_name
       
let list_seqs =
  Command.basic ~summary:"List the sequences in the provided FASTA file"
                Command.Spec.(empty +> anon ("file" %: file))
                               (fun file_name () ->
                                let file_in = in_channel_of file_name in
                                let item_stream = Fasta.fasta_stream_of_channel file_in in
                                try
                                  Stream.iter (fun (fa : Fasta.item) -> print_endline fa.name) item_stream
                                with e ->
                                     close_in_noerr file_in;
                                     raise e)

let command = Command.group ~summary:"Process FASTA files"
                            [ "list", list_seqs; ]

let () = Command.run command                            
