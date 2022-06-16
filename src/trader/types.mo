import Principal "mo:base/Principal";

module {
    public type UserId = Principal;

    public type FamePoints = Nat;

    public type Profile = {
        id: UserId;
        famePoints: FamePoints;
        displayName: Text;
        bio: ?Text;
        openedPositions: Nat;
        successfulPositions: Nat;
        failedPositions: Nat;    
    };


    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints
    };
};