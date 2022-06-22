import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Char "mo:base/Char";
import Text "mo:base/Text";
import Array "mo:base/Array";
import List "mo:base/List";
import Map "mo:base/HashMap";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
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
    stable var profilePassStore : Trie.Trie<Types.UserId, Text> = Trie.empty();
    stable var profileStoreBinanceApiKeys : Trie.Trie<Types.UserId, [Nat32]> = Trie.empty();


    public shared(msg) func createInvestorProfile (displayName : Text, bio : ?Text) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;

        //Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

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
    public query(msg) func readInvestorProfile () : async Result.Result<Types.Profile, Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

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
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

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
                let r1 = Trie.find(
                    profilePassStore,
                    key(callerId),
                    Principal.equal
                );
                switch (r1) {
                    case null {};
                    case (? _v) {
                        profilePassStore := Trie.replace(
                            profilePassStore,
                            key(callerId),
                            Principal.equal,
                            null
                        ).0;
                    };
                };
                let r2 = Trie.find(
                    profileStoreBinanceApiKeys,
                    key(callerId),
                    Principal.equal
                );
                switch (r2) {
                    case null {};
                    case (? _v) {
                        profileStoreBinanceApiKeys := Trie.replace(
                            profileStoreBinanceApiKeys,
                            key(callerId),
                            Principal.equal,
                            null
                        ).0;
                    };
                };

                #ok(());
            };
        };
    };

    public shared(msg) func followTrader (traderId : Types.TraderId) : async Result.Result<(), Error> {
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };
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
                        // TODO: change to buffer append
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
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };
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

    // IMPORTANT: Don't pass the actuall password but salt:hash on prod
    public shared(msg) func setPassword (password : Text) : async Result.Result<(), Error> {
        let callerId = msg.caller;

        let profile = Trie.find(profiles, key(callerId), Principal.equal);
        
        switch(profile) {
            case (null) {
                #err(#NotAuthorized)
            };
            case (? v) {
                let (newProfilesPassStore, existing) = Trie.put(
                    profilePassStore,
                    key(callerId),
                    Principal.equal,
                    password
                );
                switch existing {
                    case (null) {
                        profilePassStore := newProfilesPassStore;
                        #ok(())
                    };
                    case (? x) {
                        #err(#AlreadyExists)
                    };
                }
            };
        };
    };

    //TODO move to utils
    public query func validatePassword (password : Text, callerId: Types.UserId) : async Bool {
        let pass = Trie.find(profilePassStore, key(callerId), Principal.equal);

        switch(pass) {
            case (null) {
                return false
            };
            case (? v) {
                // TODO: Don't compare password with stored password but passed hash(password + salt) with stored password
                if (v == password) {
                    return true
                }
                else {
                    return false
                }
            };
            
        };
    };

    // TODO move to utils
    public shared(msg) func debugUpsertBinanceApiKeyFromPlainText(apiKey : Text, password : Text) : async Result.Result<(), Error> {
        let callerId = msg.caller;
        
        // TODO: uncomment after testing
        // let passwordValid = validatePassword(password, callerId);
        // if (passwordValid == false) {
        //     return #err(#NotAuthorized)
        // };

        let passwordSize = Text.size(password);
        let charsApi = Text.toIter(apiKey);
        let charsPass = Iter.toList(Text.toIter(password));

        var cpassNatArray : [Nat32] = [];
        
        var x = 0;

        for (i in charsApi) {
            let passChar = List.get(charsPass, x % passwordSize);
            
            switch (passChar) {
                case (null) {};
                case (? v) {
                    cpassNatArray := Array.append<Nat32>(cpassNatArray, [Char.toNat32(i) ^ Char.toNat32(v)]);
                    x += 1;
                }
            };
        };

        let newProfileStoreBinanceApiKeys = Trie.put(
            profileStoreBinanceApiKeys,
            key(callerId),
            Principal.equal,
            cpassNatArray
        ).0;
        
        profileStoreBinanceApiKeys := newProfileStoreBinanceApiKeys;

        return #ok(())
        
        
    };

    // TODO move to utils
    public query(msg) func retrieveApiKey(password : Text) : async Result.Result<(Text), Error> {
        let callerId = msg.caller;

        // TODO: uncomment after testing
        // let passwordValid : Bool = validatePassword(password, callerId);
        // if (passwordValid == false) {
        //     return #err(#NotAuthorized)
        // };
        let binanceKey = Trie.find(
            profileStoreBinanceApiKeys,
            key(callerId),
            Principal.equal
        );

        if (binanceKey == null) {
            return #ok((""))
        };        
        switch (binanceKey) {
            case null {
                return #ok((""))
            };
            case (? v){

                let passwordSize = Text.size(password);
                let charsPass = Iter.toList(Text.toIter(password));

                var cArray : [Char] = [];
                
                var x = 0;

                for (i in Iter.fromArray(v)) {
                    let passChar = List.get(charsPass, x % passwordSize);
                    
                    switch (passChar) {
                        case (null) {};
                        case (? v) {
                        cArray := Array.append<Char>(cArray, [Char.fromNat32(i ^ Char.toNat32(v))]);
                        x += 1;
                        }
                    };
                };

                return #ok((Text.fromIter(Iter.fromArray(cArray))));
            };
        };
    };

    private func key(x : Principal) : Trie.Key<Principal> {
        return { key = x; hash = Principal.hash(x) }
    };
    private func textKey(t: Text) : Trie.Key<Text> { { key = t; hash = Text.hash t } };
}
