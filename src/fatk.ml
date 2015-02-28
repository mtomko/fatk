open Core.Std
open Extensions

(** get a channel from the file name, using stdin if the file is '-' *)
let in_channel_of file_name =
  if file_name = "-" then stdin
  else open_in file_name
       
(** Creates a stream of FASTA records over the file *)               
let item_stream_of file_name =
  let file_in = in_channel_of file_name in
  Fasta.fasta_stream_of_channel file_in

(** Applies a function f to the provided input channel, closing it when done,
    unless the channel is stdin *)
let with_channel mk_chan ~f =
  let inc = mk_chan () in
  protect ~f:(fun () -> f inc)
          ~finally:(fun () ->
                    if not (phys_equal inc stdin) then In_channel.close inc)
                 
let with_items f file_name chan_to_stream =
  with_channel
    (fun _ -> in_channel_of file_name)
    ~f:(fun inc ->
        let stream = chan_to_stream inc in f stream)
          
(** Processes a stream of Fasta.Item.t extracted from the file *)
let with_items fn file_name =
  with_items fn file_name Fasta.fasta_stream_of_channel

(** Applies the function f to each Fasta.Item.t found in the file *)
let with_each_item f file_name =
  let stream_handler stream =
    Stream.iter (fun x -> f x) stream in
  with_items stream_handler file_name

