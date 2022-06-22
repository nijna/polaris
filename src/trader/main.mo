import Trie "mo:base/Trie";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

import Types "./types";

actor Trader {

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints
    };

    stable var profiles : Trie.Trie<Types.UserId, Types.Profile> = Trie.empty();
    stable var profilePassStore : Trie.Trie<Types.UserId, Text> = Trie.empty();

    public shared(msg) func createTraderProfile (displayName: Text, country: ?Text , bio: ?Text) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        // Associate user profile with their principal
        let userProfile: Types.Profile = {
            id = callerId;
            creationTime = Time.now();
            displayName = displayName;
            country = country;
            famePoints = 0;
            openedPositions = 0;
            successfulPositions = 0;
            failedPositions = 0;
            bio = bio;
            followers = [];
            assesedRisk = null;
            level = 1;
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
    public query(msg) func readTraderProfile () : async Result.Result<Types.Profile, Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if (Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        return Result.fromOption(result, #NotFound);
    };

    // Update bio
    public shared(msg) func updateTraderBio (bio: Text) : async Result.Result<(), Error> {
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
            // Do not allow updates to profiles that haven't been created yet
            case null {
                #err(#NotFound)
            };
            case (? v) {
                let updateProfile: Types.Profile = {
                    id = callerId;
                    creationTime = v.creationTime;
                    country = v.country;
                    displayName = v.displayName;
                    famePoints = v.famePoints;
                    openedPositions = v.openedPositions;
                    successfulPositions = v.successfulPositions;
                    failedPositions = v.failedPositions;
                    bio = ?bio;
                    followers = v.followers;
                    assesedRisk = v.assesedRisk;
                    level = v.level;
                };
                profiles := Trie.replace(
                    profiles,           // Target trie
                    key(callerId),      // Key
                    Principal.equal,    // Equality checker
                    ?updateProfile
                ).0;
                #ok(());
            };
        };
    };

    // Delete profile
    public shared(msg) func deleteTraderProfile () : async Result.Result<(), Error> {
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
                #ok(());
            };
        };
    };

    // Chack if investor with given Principal exists
    public query func traderPrincipalExists (userId: Types.UserId) : async Bool {
        let result = Trie.find(
            profiles,
            key(userId),
            Principal.equal
        );
        switch (result){
            case null (
                return false
            );
            case (? v) {
                return true
            };
        };
    };

    // read traders Fame Points
    public shared query func readTraderFamePoints (userId: Types.UserId) : async Types.FamePoints {
        let r = Trie.find(
            profiles,
            key(userId),
            Principal.equal
        );
        switch (r) {
            case null (
                return 0
            );
            case (? v) {
                return v.famePoints
            };
        };
    };

    // read All trader profiles    
    public query func readAllTraderProfiles () : async [(Types.UserId, Types.Profile)] {
        let arrayTraderProfiles : [(Types.UserId, Types.Profile)] = Iter.toArray(Trie.iter(profiles));
    };

    public shared(msg) func followTrader(traderId: Types.UserId, investorId : Types.InvestorId) : async Bool {
        let trader = Trie.find(
            profiles,
            key(traderId),
            Principal.equal
        );
        let callerId = msg.caller;
        // TODO: add check if caller was Investor canister!

        switch(trader) {
            case(null) {
                return false
            };
            case(? v) {

                let followerExists = Array.find<Types.InvestorId>(v.followers, func(x : Types.InvestorId) { Principal.equal(x , investorId ) });
                if (followerExists != null) {
                    return false
                };

                let followers = Array.append<Principal>([investorId], v.followers);

                let updateProfile: Types.Profile = {
                    id = traderId;
                    creationTime = v.creationTime;
                    country = v.country;
                    displayName = v.displayName;
                    famePoints = v.famePoints;
                    openedPositions = v.openedPositions;
                    successfulPositions = v.successfulPositions;
                    failedPositions = v.failedPositions;
                    bio = v.bio;
                    followers = followers;
                    assesedRisk = v.assesedRisk;
                    level = v.level;
                };
                profiles := Trie.replace(
                    profiles,           // Target trie
                    key(traderId),      // Key
                    Principal.equal,    // Equality checker
                    ?updateProfile
                ).0;

                return true
            }
        };
    };

    public shared(msg) func unfollowTrader(traderId: Types.UserId, investorId : Types.InvestorId) : async Bool {
        let trader = Trie.find(
            profiles,
            key(traderId),
            Principal.equal
        );
        let callerId = msg.caller;
        // TODO: add check if caller was Investor canister!
        
        switch(trader) {
            case(null) {
                return false
            };
            case(? v) {

                let followers = Array.filter(v.followers, func(x: Types.InvestorId) : Bool { x != investorId });

                let updateProfile: Types.Profile = {
                    id = traderId;
                    creationTime = v.creationTime;
                    country = v.country;
                    displayName = v.displayName;
                    famePoints = v.famePoints;
                    openedPositions = v.openedPositions;
                    successfulPositions = v.successfulPositions;
                    failedPositions = v.failedPositions;
                    bio = v.bio;
                    followers = followers;
                    assesedRisk = v.assesedRisk;
                    level = v.level;
                };
                profiles := Trie.replace(
                    profiles,           // Target trie
                    key(traderId),      // Key
                    Principal.equal,    // Equality checker
                    ?updateProfile
                ).0;

                return true
            }
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

    // TODO move to utils
    public query(msg) func validatePassword (password : Text) : async Bool {
        let callerId = msg.caller;
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

    private func key(x : Principal) : Trie.Key<Principal> {
        return { key = x; hash = Principal.hash(x) }
    };
}
