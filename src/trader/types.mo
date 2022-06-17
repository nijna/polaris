import Principal "mo:base/Principal";

module {
    public type UserId = Principal;

    public type FamePoints = Nat;

    public type InvestorId = Principal;

    public type Profile = {
        id: UserId;
        creationTime: Int;
        famePoints: FamePoints;
        country: ?Text;
        displayName: Text;
        bio: ?Text;
        openedPositions: Nat;
        successfulPositions: Nat;
        failedPositions: Nat;
        followers: [InvestorId];
        assesedRisk: ?Nat;
        level: Nat;
    };


    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints
    };
};