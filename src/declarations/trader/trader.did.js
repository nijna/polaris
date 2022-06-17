export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'NotEnoughFamePoints' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'AlreadyExists' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const UserId = IDL.Principal;
  const FamePoints = IDL.Nat;
  const Profile = IDL.Record({
    'id' : UserId,
    'bio' : IDL.Opt(IDL.Text),
    'displayName' : IDL.Text,
    'famePoints' : FamePoints,
    'successfulPositions' : IDL.Nat,
    'failedPositions' : IDL.Nat,
    'openedPositions' : IDL.Nat,
  });
  const Result_1 = IDL.Variant({ 'ok' : Profile, 'err' : Error });
  return IDL.Service({
    'createTraderProfile' : IDL.Func([IDL.Text], [Result], []),
    'deleteTraderProfile' : IDL.Func([], [Result], []),
    'readTraderFamePoints' : IDL.Func([UserId], [FamePoints], []),
    'readTraderProfile' : IDL.Func([], [Result_1], []),
    'traderPrincipalExists' : IDL.Func([UserId], [IDL.Bool], []),
    'updateTraderBio' : IDL.Func([IDL.Text], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
