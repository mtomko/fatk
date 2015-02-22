open Core.Std
open Extensions
       
(** get a channel from the file name, using stdin if the file is '-' *)
let in_channel_of file_name =
  if file_name = "-" then stdin
  else open_in file_name

(** create a stream of FASTA records over the file *)               
let item_stream_of file_name =
  let file_in = in_channel_of file_name in
  Fasta.fasta_stream_of_channel file_in

(** Applies the function to all items in the file *)
let with_items fn file_name =
  let channel = in_channel_of file_name in
  try
    let stream = Fasta.fasta_stream_of_channel channel in
    fn stream
  with e ->
    close_in_noerr channel;
    raise e

