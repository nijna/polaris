import Principal "mo:base/Principal";

module {
    public type OpenerId = Principal;
    public type InvestorId = Principal;
    public type UserId = Principal;

    // TO DO: replace with UUID
    public type PositionId = Int;

    public type FamePoints = Nat;

    public type Exchange = { #Binance };
    public type Pair = { #BTCUSDT; #BNBUSDT };

    public type Position = {
        id: PositionId;
        pair: Pair;
        exchange: Exchange;
        spotPrice: Float;
        targetPrice: Float;
        stopLossPrice: Float;
        openerId: OpenerId;
        investorIds: [InvestorId];
        active: Bool;
        creationTime: Int;
        closingTime: Int;
        demoPosition: Bool;
        successfulPosition: ?Bool;
    };

    public type Error = {
        #NotFound;
        #AlreadyExists;
        #NotAuthorized;
        #NotEnoughFamePoints;
        #ExhchangeNotImplementedYet;
        #ClosingTimeInPast;
    };

};