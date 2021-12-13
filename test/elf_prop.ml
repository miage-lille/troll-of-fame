open TOF.Elf
open Generator.Fantasy

let elf_invariance_1 =
  QCheck2.Test.make
    ~count:1000
    ~name:"Elf value should always be positive"
    ~print:elf_print
    elf_gen
    (fun elf -> value elf > 0)


(* ADD NEW TESTS BELOW *)

(* let elf_invariance_2 =
   QCheck2.Test.make
     ~count:1000
     ~name:"The value of a High elf must be an even number"
     ~print:elf_print
     elf_high_gen
     (fun elf -> value elf mod 2 = 0) *)

let elf_prop_set =
  (* ADD EACH TEST IN THE LIST *)
  List.map
    QCheck_alcotest.to_alcotest
    [ elf_invariance_1 (* ; elf_invariance_2  *) ]
