export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'NotEnoughFamePoints' : IDL.Null,
    'CouldntUnfollowTrader' : IDL.Null,
    'CouldntFollowTrader' : IDL.Null,
    'InvestorAlreadyFollowed' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'AlreadyExists' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const TraderId = IDL.Principal;
  const UserId = IDL.Principal;
  const PositionId = IDL.Nat;
  const Profile = IDL.Record({
    'id' : UserId,
    'bio' : IDL.Opt(IDL.Text),
    'displayName' : IDL.Text,
    'investedPositions' : IDL.Vec(PositionId),
    'follows' : IDL.Vec(TraderId),
  });
  const Result_2 = IDL.Variant({ 'ok' : Profile, 'err' : Error });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Text, 'err' : Error });
  return IDL.Service({
    'createInvestorProfile' : IDL.Func(
        [IDL.Text, IDL.Opt(IDL.Text)],
        [Result],
        [],
      ),
    'debugUpsertBinanceApiKeyFromPlainText' : IDL.Func(
        [IDL.Text, IDL.Text],
        [Result],
        [],
      ),
    'deleteInvestorProfile' : IDL.Func([], [Result], []),
    'followTrader' : IDL.Func([TraderId], [Result], []),
    'readInvestorProfile' : IDL.Func([], [Result_2], ['query']),
    'retrieveApiKey' : IDL.Func([IDL.Text], [Result_1], ['query']),
    'setPassword' : IDL.Func([IDL.Text], [Result], []),
    'unfollowTrader' : IDL.Func([TraderId], [Result], []),
    'validatePassword' : IDL.Func([IDL.Text, UserId], [IDL.Bool], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
