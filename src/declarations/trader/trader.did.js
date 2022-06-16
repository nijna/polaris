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
    'create' : IDL.Func([IDL.Text], [Result], []),
    'delete' : IDL.Func([], [Result], []),
    'principalExists' : IDL.Func([UserId], [IDL.Bool], []),
    'read' : IDL.Func([], [Result_1], []),
    'readFamePoints' : IDL.Func([UserId], [FamePoints], []),
    'updateBio' : IDL.Func([IDL.Text], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
