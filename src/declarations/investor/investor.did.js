export const idlFactory = ({ IDL }) => {
  const Error = IDL.Variant({
    'NotEnoughFamePoints' : IDL.Null,
    'NotFound' : IDL.Null,
    'NotAuthorized' : IDL.Null,
    'AlreadyExists' : IDL.Null,
  });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Null, 'err' : Error });
  const UserId = IDL.Principal;
  const Profile = IDL.Record({
    'id' : UserId,
    'investedPositions' : IDL.Vec(IDL.Nat),
  });
  const Result = IDL.Variant({ 'ok' : Profile, 'err' : Error });
  return IDL.Service({
    'create' : IDL.Func([], [Result_1], []),
    'delete' : IDL.Func([], [Result_1], []),
    'read' : IDL.Func([], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
