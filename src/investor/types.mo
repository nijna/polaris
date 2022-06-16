import Principal "mo:base/Principal";

module {
    public type UserId = Principal;
    public type PositionId = Nat;

    public type Profile = {
        id: UserId;
        investedPositions: [Nat];
        
    };

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints
    };
};