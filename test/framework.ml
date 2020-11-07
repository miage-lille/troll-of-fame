open Alcotest
open Elf_test
open Elf_prop
open Troll_test
open Troll_prop

let test_suite =
  [ ("Elf unit tests", elf_set)
  ; ("Troll unit tests", troll_set)
  ; ("Elf property tests", elf_prop_set)
  ; ("Troll property tests", troll_prop_set)
  ]
