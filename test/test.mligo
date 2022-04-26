#import "../contracts/main.mligo" "Random"
#import "./helpers/random.mligo" "Random_helper"

let alice: address = Test.nth_bootstrap_account 0
let bob: address = Test.nth_bootstrap_account 1

let test =
    let init_storage = Random_helper.base_storage(alice, bob, 100n) in
    let rdm = Random_helper.originate(init_storage) in
    let s_init = Test.get_storage rdm.taddr in
    //let () = Test.log(s_init) in

    let _test_should_works = (* chest key/payload and time matches -> OK *)

        let payload : bytes = 0x0a in
        let time_secret : nat = 10n in
        let (my_chest,chest_key) = Test.create_chest payload time_secret in

        let payload2 : bytes = 0x0b in
        let time_secret2 : nat = 99n in
        let (my_chest2,chest_key2) = Test.create_chest payload2 time_secret2 in

        //let () = Test.log("chests created") in

        let x : Random.parameter contract = Test.to_contract rdm.taddr in

        // alice commits
        //let () = Test.log("alice commits") in
        let () = Test.set_source alice in
        let commit_args : Random.Parameter.Types.commit_param = {secret_action=my_chest} in
        //let () = Test.log(commit_args) in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args)) 10mutez in

        //let () = Test.log("check alice chest") in
        let s : Random.storage = Test.get_storage rdm.taddr in
        let response : bool = match Map.find_opt alice s.secrets with
        | None -> false
        | Some x -> true
        in
        //let () = Test.log(s) in
        let () = assert (response) in

        // bob commits
        //let () = Test.log("bob commits") in
        let () = Test.set_source bob in
        let commit_args2 : Random.Parameter.Types.commit_param = {secret_action=my_chest2} in
        //let () = Test.log(commit_args) in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args2)) 10mutez in

        //let () = Test.log("check bob chest") in
        let s3 : Random.storage = Test.get_storage rdm.taddr in
        let response2 : bool = match Map.find_opt bob s3.secrets with
        | None -> false
        | Some x -> true
        in
        //let () = Test.log(s3) in
        let () = assert (response2) in

        // alice reveals
        //let () = Test.log("alice reveals") in
        let () = Test.set_source alice in
        let reveal_args : Random.Parameter.Types.reveal_param = (chest_key, time_secret) in
        //let () = Test.log(reveal_args) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args)) 0mutez in

        // bob reveals
        //let () = Test.log("bob reveals") in
        let () = Test.set_source bob in
        let reveal_args2 : Random.Parameter.Types.reveal_param = (chest_key2, time_secret2) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args2)) 0mutez in

        //let () = Test.log("check storage") in
        let s2 : Random.storage = Test.get_storage rdm.taddr in
        //let () = Test.log(s2) in
        let () = assert (s2.result_nat <> (None : nat option)) in
        "OK"
    in
    ()

let test2 =
    let init_storage = Random_helper.base_storage(alice, bob, 1n) in
    let rdm = Random_helper.originate(init_storage) in
    let s_init = Test.get_storage rdm.taddr in

    let _test_rollD1000 =

        let payload : bytes = 0x0a1234 in
        let time_secret : nat = 10n in
        let (my_chest,chest_key) = Test.create_chest payload time_secret in

        let payload2 : bytes = 0x0b455469 in
        let time_secret2 : nat = 84n in
        let (my_chest2,chest_key2) = Test.create_chest payload2 time_secret2 in

        //let () = Test.log("chests created") in

        let x : Random.parameter contract = Test.to_contract rdm.taddr in

        // alice commits
        //let () = Test.log("alice commits") in
        let () = Test.set_source alice in
        let commit_args : Random.Parameter.Types.commit_param = {secret_action=my_chest} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args)) 10mutez in

        // bob commits
        //let () = Test.log("bob commits") in
        let () = Test.set_source bob in
        let commit_args2 : Random.Parameter.Types.commit_param = {secret_action=my_chest2} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args2)) 10mutez in

        // alice reveals
        //let () = Test.log("alice reveals") in
        let () = Test.set_source alice in
        let reveal_args : Random.Parameter.Types.reveal_param = (chest_key, time_secret) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args)) 0mutez in

        // bob reveals
        //let () = Test.log("bob reveals") in
        let () = Test.set_source bob in
        let reveal_args2 : Random.Parameter.Types.reveal_param = (chest_key2, time_secret2) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args2)) 0mutez in

        //let () = Test.log("check storage") in
        let s2 : Random.storage = Test.get_storage rdm.taddr in
        let () = Test.log(s2.result_nat) in
        let () = assert (s2.result_nat <> (None : nat option)) in
        "OK"
        //Test.log("test finished")
    in
    let _test_rollD20 =

        let payload : bytes = 0x0a1234 in
        let time_secret : nat = 10n in
        let (my_chest,chest_key) = Test.create_chest payload time_secret in

        let payload2 : bytes = 0x0b455469 in
        let time_secret2 : nat = 84n in
        let (my_chest2,chest_key2) = Test.create_chest payload2 time_secret2 in

        //let () = Test.log("chests created") in

        let x : Random.parameter contract = Test.to_contract rdm.taddr in

        // alice reset
        //let () = Test.log("alice reset") in
        let () = Test.set_source alice in
        let reset_args : Random.Parameter.Types.reset_param = {min=1n; max=20n} in
        let _ = Test.transfer_to_contract_exn x (Reset(reset_args)) 0mutez in

        //let () = Test.log("check storage") in
        //let store_reseted : Random.storage = Test.get_storage rdm.taddr in
        //let () = Test.log(store_reseted) in

        // alice commits
        //let () = Test.log("alice commits") in
        let () = Test.set_source alice in
        let commit_args : Random.Parameter.Types.commit_param = {secret_action=my_chest} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args)) 10mutez in

        // bob commits
        //let () = Test.log("bob commits") in
        let () = Test.set_source bob in
        let commit_args2 : Random.Parameter.Types.commit_param = {secret_action=my_chest2} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args2)) 10mutez in

        // alice reveals
        //let () = Test.log("alice reveals") in
        let () = Test.set_source alice in
        let reveal_args : Random.Parameter.Types.reveal_param = (chest_key, time_secret) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args)) 0mutez in

        // bob reveals
        //let () = Test.log("bob reveals") in
        let () = Test.set_source bob in
        let reveal_args2 : Random.Parameter.Types.reveal_param = (chest_key2, time_secret2) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args2)) 0mutez in

        //let () = Test.log("check storage") in
        let s2 : Random.storage = Test.get_storage rdm.taddr in
        let () = Test.log(s2.result_nat) in
        let () = assert (s2.result_nat <> (None : nat option)) in
        let result : nat = Option.unopt s2.result_nat in
        let () = assert (result <= s2.max) in
        let () = assert (result >= s2.min) in
        "OK"
        //Test.log("test finished")
    in
    let _test_rollD20_again =

        let payload : bytes = 0x0a1234 in
        let time_secret : nat = 10n in
        let (my_chest,chest_key) = Test.create_chest payload time_secret in

        let payload2 : bytes = 0x0b455469 in
        let time_secret2 : nat = 84n in
        let (my_chest2,chest_key2) = Test.create_chest payload2 time_secret2 in

        //let () = Test.log("chests created") in

        let x : Random.parameter contract = Test.to_contract rdm.taddr in

        // alice reset
        //let () = Test.log("alice reset") in
        let () = Test.set_source alice in
        let reset_args : Random.Parameter.Types.reset_param = {min=1n; max=20n} in
        let _ = Test.transfer_to_contract_exn x (Reset(reset_args)) 0mutez in

        //let () = Test.log("check storage") in
        //let store_reseted : Random.storage = Test.get_storage rdm.taddr in
        //let () = Test.log(store_reseted) in


        // alice commits
        //let () = Test.log("alice commits") in
        let () = Test.set_source alice in
        let commit_args : Random.Parameter.Types.commit_param = {secret_action=my_chest} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args)) 10mutez in

        // bob commits
        //let () = Test.log("bob commits") in
        let () = Test.set_source bob in
        let commit_args2 : Random.Parameter.Types.commit_param = {secret_action=my_chest2} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args2)) 10mutez in

        // alice reveals
        //let () = Test.log("alice reveals") in
        let () = Test.set_source alice in
        let reveal_args : Random.Parameter.Types.reveal_param = (chest_key, time_secret) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args)) 0mutez in

        // bob reveals
        //let () = Test.log("bob reveals") in
        let () = Test.set_source bob in
        let reveal_args2 : Random.Parameter.Types.reveal_param = (chest_key2, time_secret2) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args2)) 0mutez in

        //let () = Test.log("check storage") in
        let s2 : Random.storage = Test.get_storage rdm.taddr in
        let () = Test.log(s2.result_nat) in
        let () = assert (s2.result_nat <> (None : nat option)) in
        let result : nat = Option.unopt s2.result_nat in
        let () = assert (result <= s2.max) in
        let () = assert (result >= s2.min) in
        "OK"
        //Test.log("test finished")
    in
    let _test_rollD20_again_again =

        let payload : bytes = 0x0a1234 in
        let time_secret : nat = 10n in
        let (my_chest,chest_key) = Test.create_chest payload time_secret in

        let payload2 : bytes = 0x0b455469 in
        let time_secret2 : nat = 84n in
        let (my_chest2,chest_key2) = Test.create_chest payload2 time_secret2 in

        //let () = Test.log("chests created") in

        let x : Random.parameter contract = Test.to_contract rdm.taddr in

        // alice reset
        //let () = Test.log("alice reset") in
        let () = Test.set_source alice in
        let reset_args : Random.Parameter.Types.reset_param = {min=1n; max=20n} in
        let _ = Test.transfer_to_contract_exn x (Reset(reset_args)) 0mutez in

        //let () = Test.log("check storage") in
        //let store_reseted : Random.storage = Test.get_storage rdm.taddr in
        //let () = Test.log(store_reseted) in

        // alice commits
        //let () = Test.log("alice commits") in
        let () = Test.set_source alice in
        let commit_args : Random.Parameter.Types.commit_param = {secret_action=my_chest} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args)) 10mutez in

        // bob commits
        //let () = Test.log("bob commits") in
        let () = Test.set_source bob in
        let commit_args2 : Random.Parameter.Types.commit_param = {secret_action=my_chest2} in
        let _ = Test.transfer_to_contract_exn x (Commit(commit_args2)) 10mutez in

        // alice reveals
        //let () = Test.log("alice reveals") in
        let () = Test.set_source alice in
        let reveal_args : Random.Parameter.Types.reveal_param = (chest_key, time_secret) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args)) 0mutez in

        // check locked tez before bob reveals
        let bob_balance_of_before_reveal = Test.get_balance bob in
        let storage_before_bob_reveals : Random.storage = Test.get_storage rdm.taddr in
        let bob_locked_tez_opt : tez option = Map.find_opt bob storage_before_bob_reveals.locked_tez in
        let bob_locked_tez_before_reveal : tez =  match bob_locked_tez_opt with
        | None -> 0tez
        | Some tez_val -> tez_val
        in
        let () = assert(bob_locked_tez_before_reveal = 10mutez) in

        // bob reveals
        //let () = Test.log("bob reveals") in
        let () = Test.set_source bob in
        let reveal_args2 : Random.Parameter.Types.reveal_param = (chest_key2, time_secret2) in
        let _ = Test.transfer_to_contract_exn x (Reveal(reveal_args2)) 0mutez in

        // check locked tez after bob reveals
        let storage_after_bob_reveals : Random.storage = Test.get_storage rdm.taddr in
        let bob_locked_tez_opt : tez option = Map.find_opt bob storage_after_bob_reveals.locked_tez in
        let bob_locked_tez_after_reveal : tez =  match bob_locked_tez_opt with
        | None -> 0tez
        | Some tez_val -> tez_val
        in
        let () = assert(bob_locked_tez_after_reveal = 0mutez) in

        //let () = Test.log("check storage") in
        let s2 : Random.storage = Test.get_storage rdm.taddr in
        let () = Test.log(s2.result_nat) in
        let () = assert (s2.result_nat <> (None : nat option)) in
        let result : nat = Option.unopt s2.result_nat in
        let () = assert (result <= s2.max) in
        let () = assert (result >= s2.min) in
        "OK"
        //Test.log("test finished")
    in
    ()
