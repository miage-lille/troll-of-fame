open TOF.Elf

let given_2_warlock_dark_elves () =
  let doomshadow = { role = Warlock; race = Dark_Elf }
  and thundershade = { role = Warlock; race = Dark_Elf } in
  Alcotest.(check bool) "Should be equal" (doomshadow = thundershade) true


let given_1_archer_dark_elf_and_1_swordsman_high_elf_when_value () =
  let faeor = { role = Swordsman; race = High_Elf }
  and shadowblight = { role = Archer; race = Dark_Elf } in
  Alcotest.(check int) "Should be equal" (value shadowblight) (value faeor)


let elf_set =
  let open Alcotest in
  [ test_case
      "Given 2 warlock dark elves should be equal"
      `Quick
      given_2_warlock_dark_elves
  ; test_case
      "Given 1 archer dark elf and 1 swordsman high elf when value should be \
       equal"
      `Quick
      given_1_archer_dark_elf_and_1_swordsman_high_elf_when_value
  ]
