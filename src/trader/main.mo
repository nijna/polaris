import Trie "mo:base/Trie";
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


    public shared(msg) func create (displayName: Text) : async Result.Result<(), Error> {
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
            famePoints = 0;
            openedPositions = 0;
            successfulPositions = 0;
            failedPositions = 0;
            bio = null;
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
    public shared(msg) func read () : async Result.Result<Types.Profile, Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        // if (Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#NotAuthorized);
        // };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        return Result.fromOption(result, #NotFound);
    };

    // Update bio
    public shared(msg) func updateBio (bio: Text) : async Result.Result<(), Error> {
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
            // Do not allow updates to profiles that haven't been created yet
            case null {
                #err(#NotFound)
            };
            case (? v) {
                let updateProfile: Types.Profile = {
                    id = callerId;
                    displayName = v.displayName;
                    famePoints = v.famePoints;
                    openedPositions = v.openedPositions;
                    successfulPositions = v.successfulPositions;
                    failedPositions = v.failedPositions;
                    bio = ?bio;
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
    public shared(msg) func delete () : async Result.Result<(), Error> {
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

    // Chack if investor with given Principal exists
    public shared func principalExists (userId: Types.UserId) : async Bool {
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
    public shared func readFamePoints (userId: Types.UserId) : async Types.FamePoints {
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

    private func key(x : Principal) : Trie.Key<Principal> {
        return { key = x; hash = Principal.hash(x) }
    };
}
