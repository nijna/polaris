export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'NotEnoughFamePoints' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'AlreadyExists' : IDL.Null,
  });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const UserId = IDL.Principal;
  const PositionId = IDL.Nat;
  const TraderId = IDL.Principal;
  const Profile = IDL.Record({
    'id' : UserId,
    'bio' : IDL.Opt(IDL.Text),
    'displayName' : IDL.Text,
    'investedPositions' : IDL.Vec(PositionId),
    'follows' : IDL.Vec(TraderId),
  });
  const Result = IDL.Variant({ 'ok' : Profile, 'err' : Error });
  return IDL.Service({
    'createInvestorProfile' : IDL.Func(
        [IDL.Text, IDL.Opt(IDL.Text)],
        [Result_1],
        [],
      ),
    'deleteInvestorProfile' : IDL.Func([], [Result_1], []),
    'readInvestorProfile' : IDL.Func([], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
