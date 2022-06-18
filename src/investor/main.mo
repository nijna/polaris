import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Types "./types";

import Trader "canister:trader";

actor Investor {

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints;
        #InvestorAlreadyFollowed;
        #CouldntFollowTrader;
        #CouldntUnfollowTrader;
    };
    
    stable var profiles : Trie.Trie<Types.UserId, Types.Profile> = Trie.empty();

    public shared(msg) func createInvestorProfile (displayName : Text, bio : ?Text) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        // Associate user profile with their principal
        let userProfile: Types.Profile = {
            id = callerId;
            displayName = displayName;
            investedPositions = [];
            bio = bio;
            follows = [];
        };

        let (newProfiles, existing) = Trie.put(
            profiles,           // Target trie
            key(callerId),      // Key
            Principal.equal,    // Equality checker
            userProfile
        );

        // If there is an original value, do not update
        switch(existing) {
            // If there are no matches, update profiles
            case null {
                profiles := newProfiles;
                #ok(());
            };
            // Matches pattern of type - opt Profile
            case (? v) {
                #err(#AlreadyExists);
            };
        };
    };

    // Read profile
    public shared(msg) func readInvestorProfile () : async Result.Result<Types.Profile, Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        return Result.fromOption(result, #NotFound);
    };


    // Delete profile
    public shared(msg) func deleteInvestorProfile () : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );

        switch (result){
            // Do not try to delete a profile that hasn't been created yet
            case null {
                #err(#NotFound);
            };
            case (? v) {
                profiles := Trie.replace(
                    profiles,           // Target trie
                    key(callerId),     // Key
                    Principal.equal,          // Equality checker
                    null
                ).0;
                #ok(());
            };
        };
    };

    public shared(msg) func followTrader (traderId : Types.TraderId) : async Result.Result<(), Error> {
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };
        let investorProfile = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        switch (investorProfile) {
            case (null) {
                return #err(#NotFound)
            };
            case (? v) {
                let investorFollowed = Array.find<Types.TraderId>(v.follows, func(x : Types.TraderId) { Principal.equal(x , traderId ) });
                if (investorFollowed != null) {
                    return #err(#InvestorAlreadyFollowed);
                }
                else {
                    let result : Bool = await Trader.followTrader(traderId, callerId);
                    if (result == false) {
                        return #err(#CouldntFollowTrader);
                    }
                    else {
                        let follows = Array.append<Principal>([traderId], v.follows);

                        let newInvestorProfile: Types.Profile = {
                            id = v.id;
                            displayName = v.displayName;
                            investedPositions = v.investedPositions;
                            bio = v.bio;
                            follows = follows;
                        };
                        profiles := Trie.replace(
                            profiles,           // Target trie
                            key(callerId),      // Key
                            Principal.equal,    // Equality checker
                            ?newInvestorProfile
                        ).0;
                        return #ok(());
                    };
                };
            };
        };
    };
    

    public shared(msg) func unfollowTrader (traderId : Types.TraderId) : async Result.Result<(), Error> {
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };
        let investorProfile = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        switch (investorProfile) {
            case (null) {
                return #err(#NotFound)
            };
            case (? v) {
                
                let result : Bool = await Trader.unfollowTrader(traderId, callerId);
                if (result == false) {
                    return #err(#CouldntUnfollowTrader);
                }
                else {
                    let follows = Array.filter(v.follows, func(x: Types.TraderId) : Bool { x != traderId });

                    let newInvestorProfile: Types.Profile = {
                        id = v.id;
                        displayName = v.displayName;
                        investedPositions = v.investedPositions;
                        bio = v.bio;
                        follows = follows;
                    };
                    profiles := Trie.replace(
                        profiles,
                        key(callerId),
                        Principal.equal,
                        ?newInvestorProfile
                    ).0;
                    return #ok(());
                };
            };
        };
    };

    private func key(x : Principal) : Trie.Key<Principal> {
        return { key = x; hash = Principal.hash(x) }
    };
}
