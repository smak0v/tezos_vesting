type vestingParams is record [
    startTimestamp : timestamp;
    secondsPerTick : nat;
    tokensPerTick : nat;
]

type storage is record [
    vestedAmount : nat;
    vestingAddress : address;
    adminAddress : address;
    vestingParams : vestingParams;
]

type return is list(operation) * storage

type action is
| Default of unit
| SetDelegate of option(key_hash)
| Vest of nat

function setDelegate(const delegate : option(key_hash); const s : storage) : return is
block {
    var response : list(operation) := nil;

    if Tezos.sender =/= s.adminAddress then
        failwith("Access denied")
    else
        skip;

    response := Tezos.set_delegate(delegate) # response;
} with (response, s)

function vest(const value : nat; var s : storage) : return is
block {
    const today : timestamp = Tezos.now;
    const seconds : nat = abs(today - s.vestingParams.startTimestamp);
    const ticks : nat = seconds / s.vestingParams.secondsPerTick;
    const openTokensAmount : nat = ticks * s.vestingParams.tokensPerTick;

    if value + s.vestedAmount > openTokensAmount then
        failwith("Not allowed amount")
    else
        skip;

    var response : list(operation) := nil;

    s.vestedAmount := s.vestedAmount + value;

    case (Tezos.get_contract_opt(s.vestingAddress) : option(contract(unit))) of
    | None -> skip
    | Some(contract) -> block {
        response := Tezos.transaction(unit, value * 1mutez, contract) # response;
    }
    end;
} with (response, s)

function main(const a : action; const s : storage) : return is
case a of
| Default -> ((nil : list(operation)), s)
| SetDelegate(d) -> setDelegate(d, s)
| Vest(value) -> vest(value, s)
end
