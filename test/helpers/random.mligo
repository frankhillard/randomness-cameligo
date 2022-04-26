#import "../../contracts/main.mligo" "Random"

(* Some types for readability *)
type taddr = (Random.parameter, Random.storage) typed_address
type contr = Random.parameter contract
type originated = {
    addr: address;
    taddr: taddr;
    contr: contr;
}

(* Initialize storage of Randmness contract *)
let base_storage
  (player_1, player_2, min : address * address * nat)
: Random.storage =
  {participants =
     Set.add
       player_1
       (Set.add player_2 (Set.empty : address set));
   locked_tez = (Map.empty : (address, tez) map);
   secrets = (Map.empty : (address, chest) map);
   decoded_payloads = (Map.empty : (address, bytes) map);
   result_nat = (None : nat option);
   last_seed = 3268854739249n;
   max = 1000n;
   min = min}

(* Originate Random contract *)
let originate (init_storage : Random.storage) =
  let (taddr, _, _) =
    Test.originate Random.main init_storage 0mutez in
  let contr = Test.to_contract taddr in
  let addr = Tezos.address contr in
  {addr = addr; taddr = taddr; contr = contr}

(* Call entry point of Random contr contract *)
let call (p, contr : Random.parameter * contr) =
    Test.transfer_to_contract contr p 0mutez

(* TODO: helpers for commit, reveal, reset *)
