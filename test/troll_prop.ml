open TOF.Troll
open Generator.Fantasy

let troll_invariance =
  QCheck.Test.make
    ~count:1000
    ~name:"Troll score should always be >= 0"
    troll_arbitrary
    (fun troll -> scoring troll >= 0)


(* let troll_inverse =
  QCheck.Test.make
    ~count:1000
    ~name:"oops_he_survived should always be inverse of i_got_one"
    troll_elf_arbitrary
    (fun (troll, elf) ->
      i_got_one elf troll |> oops_he_survived elf |> scoring = scoring troll) *)

let troll_prop_set =
  (* ADD EACH TEST IN THE LIST *)
  List.map
    QCheck_alcotest.to_alcotest
    [ troll_invariance (* ; troll_inverse  *) ]
