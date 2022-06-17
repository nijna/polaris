import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Error = { 'NotEnoughFamePoints' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null };
export type FamePoints = bigint;
export interface Profile {
  'id' : UserId,
  'bio' : [] | [string],
  'displayName' : string,
  'famePoints' : FamePoints,
  'successfulPositions' : bigint,
  'failedPositions' : bigint,
  'openedPositions' : bigint,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : Profile } |
  { 'err' : Error };
export type UserId = Principal;
export interface _SERVICE {
  'createInvestor' : ActorMethod<[string], Result>,
  'deleteInvestorProfile' : ActorMethod<[], Result>,
  'investorPrincipalExists' : ActorMethod<[UserId], boolean>,
  'readInvestorFamePoints' : ActorMethod<[UserId], FamePoints>,
  'readInvestorProfile' : ActorMethod<[], Result_1>,
  'updateInvestorBio' : ActorMethod<[string], Result>,
}
