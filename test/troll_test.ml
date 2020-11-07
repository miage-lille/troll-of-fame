open TOF
open TOF.Troll

let given_empty_kills_when_i_got_1 () =
  let faeor = Elf.{ role = Swordsman; race = Dark_Elf }
  and aklass_before = { name = "Aklass"; kills = ElvesMap.empty } in
  let aklass_after = i_got 1 faeor aklass_before in
  Alcotest.(check int)
    "should add key faeor with value 1"
    (ElvesMap.find faeor aklass_after.kills)
    1


let given_one_faeor_when_remove () =
  let faeor = Elf.{ role = Swordsman; race = Dark_Elf }
  and aklass_before = { name = "Aklass"; kills = ElvesMap.empty } in
  let aklass_with_faeor = i_got 1 faeor aklass_before in
  let aklass_without_faeor = i_got (-1) faeor aklass_with_faeor in
  Alcotest.(check (option int))
    "shouldn't have key faeor"
    (ElvesMap.find_opt faeor aklass_without_faeor.kills)
    None


let given_empty_kills_when_i_got_5 () =
  let faeor = Elf.{ role = Swordsman; race = Dark_Elf }
  and aklass_before = { name = "Aklass"; kills = ElvesMap.empty } in
  let aklass_after = i_got 5 faeor aklass_before in
  Alcotest.(check int)
    "should add key faeor with value 5"
    (ElvesMap.find faeor aklass_after.kills)
    5


let given_i_got_1_when_i_got_one () =
  let faeor = Elf.{ role = Swordsman; race = Dark_Elf }
  and aklass_before = { name = "Aklass"; kills = ElvesMap.empty } in
  let aklass_got_1 = i_got 1 faeor aklass_before
  and aklass_got_one = i_got_one faeor aklass_before in
  Alcotest.(check bool)
    "should be the same"
    (aklass_got_1 = aklass_got_one)
    true


let given_a_score_after_oops_he_survived () =
  let faeor = Elf.{ role = Swordsman; race = Dark_Elf }
  and aklass_before = { name = "Aklass"; kills = ElvesMap.empty } in
  let aklass_after = i_got_one faeor aklass_before |> oops_he_survived faeor in
  Alcotest.(check bool)
    "should be the same as before"
    (aklass_before = aklass_after)
    true


let given_empty_kills_when_scoring () =
  let aklass = { name = "Aklass"; kills = ElvesMap.empty } in
  Alcotest.(check int) "should be 0" (scoring aklass) 0


let given_a_warlock_resurrect_all_elves_when_scoring () =
  let faeor = Elf.{ role = Swordsman; race = Dark_Elf }
  and aklass = { name = "Aklass"; kills = ElvesMap.empty } in
  let score = i_got_one faeor aklass |> all_elves_resurrected |> scoring in
  Alcotest.(check int) "should be 0" score 0


let troll_set =
  let open Alcotest in
  [ test_case
      "Given empty kills when i_got 1 should add key faeor with value 1"
      `Quick
      given_empty_kills_when_i_got_1
  ; test_case
      "Given one faeor when i_got -1 shouldn't have key faeor"
      `Quick
      given_one_faeor_when_remove
  ; test_case
      "Given empty kills when i_got 5 should add key faeor with value 5"
      `Quick
      given_empty_kills_when_i_got_5
  ; test_case
      "Given i_got 1 when i_got_one should be the same"
      `Quick
      given_i_got_1_when_i_got_one
  ; test_case
      "Given a score after oops_he_survived should be the same as before"
      `Quick
      given_a_score_after_oops_he_survived
  ; test_case
      "Given empty kills when scoring should be 0"
      `Quick
      given_empty_kills_when_scoring
  ; test_case
      "Given a warlock resurrect all elves when scoring should be 0"
      `Quick
      given_a_warlock_resurrect_all_elves_when_scoring
  ]
