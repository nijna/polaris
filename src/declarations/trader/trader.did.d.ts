import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Error = { 'NotEnoughFamePoints' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null };
export type FamePoints = bigint;
export type InvestorId = Principal;
export interface Profile {
  'id' : UserId,
  'bio' : [] | [string],
  'country' : [] | [string],
  'displayName' : string,
  'assesedRisk' : [] | [bigint],
  'level' : bigint,
  'famePoints' : FamePoints,
  'creationTime' : bigint,
  'successfulPositions' : bigint,
  'followers' : Array<InvestorId>,
  'failedPositions' : bigint,
  'openedPositions' : bigint,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : Profile } |
  { 'err' : Error };
export type UserId = Principal;
export interface _SERVICE {
  'createTraderProfile' : ActorMethod<
    [string, [] | [string], [] | [string]],
    Result,
  >,
  'deleteTraderProfile' : ActorMethod<[], Result>,
  'followTrader' : ActorMethod<[UserId, InvestorId], boolean>,
  'readAllTraderProfiles' : ActorMethod<[], Array<[UserId, Profile]>>,
  'readTraderFamePoints' : ActorMethod<[UserId], FamePoints>,
  'readTraderProfile' : ActorMethod<[], Result_1>,
  'setPassword' : ActorMethod<[string], Result>,
  'traderPrincipalExists' : ActorMethod<[UserId], boolean>,
  'unfollowTrader' : ActorMethod<[UserId, InvestorId], boolean>,
  'updateTraderBio' : ActorMethod<[string], Result>,
  'validatePassword' : ActorMethod<[string], boolean>,
}
