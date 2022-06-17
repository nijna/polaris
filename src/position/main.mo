import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Trie "mo:base/Trie";
import Int "mo:base/Int";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

import Trader "canister:trader";

import Types "./types";

actor Position {


    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints;
        #ClosingTimeInPast;
        #TargetLowerThanSpot;
        #StopLossHigherThanSpot;
        #PositionAlreadyClosed;
    };

    // TO DO: replace with UUID
    stable var positionId : Types.PositionId = 0;

    stable var positions : Trie.Trie<Types.PositionId, Types.Position> = Trie.empty();

    // Open new position
    public shared(msg) func openPosition (
        pair: Types.Pair, 
        exchange: Types.Exchange,
        spotPrice: Float, 
        targetPrice: Float, 
        stopLossPrice: Float,
        closingTime: Int,
        demoPosition: Bool
    ) : async Result.Result<(), Error> {

        let callerId : Types.UserId = msg.caller;

        let exists : Bool = await Trader.traderPrincipalExists(callerId);

        if (targetPrice < spotPrice) {
            return #err(#TargetLowerThanSpot)
        };
        if (stopLossPrice > spotPrice) {
            return #err(#StopLossHigherThanSpot)
        };
        if (closingTime < Time.now()) {
            return #err(#ClosingTimeInPast)
        };  

        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        // Check if caller exists as trader
        if (exists != true) {
            return #err(#NotAuthorized);
        };

        // Check if there is enough Fame Points
        let traderFamePoints : Types.FamePoints = await Trader.readTraderFamePoints(callerId);
        if ((traderFamePoints < 200) and (demoPosition == false)) {
            return #err(#NotEnoughFamePoints);
        };

        let position: Types.Position = {
            id = positionId;
            pair = pair;
            exchange = exchange;
            spotPrice = spotPrice;
            targetPrice = targetPrice;
            stopLossPrice = stopLossPrice;
            openerId = callerId;
            investorIds = [];
            active = true;
            creationTime = Time.now();
            closingTime = closingTime;
            demoPosition = demoPosition;
            successfulPosition = null;
        };

        let (newPosition, existing) = Trie.put(
            positions,
            key(positionId),
            Int.equal,
            position
        );


        positions := newPosition;
        positionId += 1;
        #ok(());
        
    };

    // Read position
    public func readPosition (_positionId: Types.PositionId) : async Result.Result<Types.Position, Error>  {
        let result = Trie.find(
            positions,
            key(_positionId),
            Int.equal
        );
        return Result.fromOption(result, #NotFound);
    };

    // Close position by Trader
    public shared(msg) func closePosition(_positionId: Types.PositionId) : async Result.Result<(), Error> {
        let callerId : Types.UserId = msg.caller;
        
        let result = Trie.find(
            positions,
            key(_positionId),
            Int.equal
        );

        switch (result) {
            case null {
                #err(#NotFound)
            };
            case (? v) {
                // Check if it same caller who opened position
                if (v.openerId != callerId) {
                    return #err(#NotAuthorized)
                };
                // Check if position is already closed
                if ((v.active == false) or (v.closingTime <= Time.now())) {
                    #err(#PositionAlreadyClosed)
                }
                else {
                    let updatePosition : Types.Position = {
                        id = v.id;
                        pair = v.pair;
                        exchange = v.exchange;
                        spotPrice = v.spotPrice;
                        targetPrice = v.targetPrice;
                        stopLossPrice = v.stopLossPrice;
                        openerId = v.openerId;
                        investorIds = v.investorIds;
                        active = false;
                        creationTime = v.creationTime;
                        closingTime = Time.now();
                        demoPosition = v.demoPosition;
                        successfulPosition = v.successfulPosition;
                    };

                    positions := Trie.replace(
                        positions,
                        key(_positionId),
                        Int.equal,
                        ?updatePosition
                    ).0;

                    #ok(());
                };
            };
        };

    };

    // public func getActivePositions () : async [(Types.PositionId, Types.Position)]  {
    //     let activePositions = Trie.filter<Types.PositionId, Types.Position>(positions, func (k, v) {
    //         (v.active == true) and (v.closingTime > Time.now())
    //     });
    //     let arrayActivePositions : [(Types.PositionId, Types.Position)] = Iter.toArray(Trie.iter(activePositions));
    //     return activePositions
    // };

    private func key(x : Int) : Trie.Key<Int> {
        return { key = x; hash = Int.hash(x) }
    };
}
