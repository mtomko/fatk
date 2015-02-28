open Core_kernel.Std
open Extensions

(** Represents a single entry in a FASTA file *)       
module Item : sig
  type t = { name : bytes; sequence : bytes; }
end

(** Creates a FASTA item stream from the input channel *)
val fasta_stream_of_channel : in_channel -> Item.t Stream.t

(** Creates a string representation of the FASTA item *)
val to_string : ?width : int -> Item.t -> string
