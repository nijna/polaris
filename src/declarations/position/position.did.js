export const idlFactory = ({ IDL }) => {
  const PositionId = IDL.Int;
  const Error = IDL.Variant({
    'NotEnoughFamePoints' : IDL.Null,
    'ClosingTimeInPast' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'AlreadyExists' : IDL.Null,
    'StopLossHigherThanSpot' : IDL.Null,
    'PositionAlreadyClosed' : IDL.Null,
    'TargetLowerThanSpot' : IDL.Null,
  });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const Pair = IDL.Variant({ 'BTCUSDT' : IDL.Null, 'BNBUSDT' : IDL.Null });
  const Exchange = IDL.Variant({ 'Binance' : IDL.Null });
  const InvestorId = IDL.Principal;
  const OpenerId = IDL.Principal;
  const Position = IDL.Record({
    'id' : PositionId,
    'active' : IDL.Bool,
    'pair' : Pair,
    'successfulPosition' : IDL.Opt(IDL.Bool),
    'targetPrice' : IDL.Float64,
    'demoPosition' : IDL.Bool,
    'creationTime' : IDL.Int,
    'investorIds' : IDL.Vec(InvestorId),
    'spotPrice' : IDL.Float64,
    'stopLossPrice' : IDL.Float64,
    'closingTime' : IDL.Int,
    'exchange' : Exchange,
    'openerId' : OpenerId,
  });
  const Result = IDL.Variant({ 'ok' : Position, 'err' : Error });
  return IDL.Service({
    'closePosition' : IDL.Func([PositionId], [Result_1], []),
    'openPosition' : IDL.Func(
        [
          Pair,
          Exchange,
          IDL.Float64,
          IDL.Float64,
          IDL.Float64,
          IDL.Int,
          IDL.Bool,
        ],
        [Result_1],
        [],
      ),
    'readPosition' : IDL.Func([PositionId], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
