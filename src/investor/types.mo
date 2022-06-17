import Principal "mo:base/Principal";

module {
    public type UserId = Principal;
    public type PositionId = Nat;
    public type TraderId = Principal;

    public type Profile = {
        id: UserId;
        displayName: Text;
        investedPositions: [PositionId];
        bio: ?Text;
        follows: [TraderId];
        
    };

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints
    };
};