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
  const Result_1 = IDL.Variant({ 'ok' : Profile, 'err' : Error });
  return IDL.Service({
    'createInvestorProfile' : IDL.Func(
        [IDL.Text, IDL.Opt(IDL.Text)],
        [Result],
        [],
      ),
    'deleteInvestorProfile' : IDL.Func([], [Result], []),
    'followTrader' : IDL.Func([TraderId], [Result], []),
    'readInvestorProfile' : IDL.Func([], [Result_1], []),
    'unfollowTrader' : IDL.Func([TraderId], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
