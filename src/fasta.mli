open Core_kernel.Std

(** Represents an entry in a FASTA file *)
type item = {
  name : string;
  sequence : Dna.Seq.t
}

(** Creates a FASTA item stream from the input channel *)
val fasta_stream_of_channel : in_channel -> item Stream.t
