import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Error = { 'NotEnoughFamePoints' : null } |
  { 'CouldntUnfollowTrader' : null } |
  { 'CouldntFollowTrader' : null } |
  { 'InvestorAlreadyFollowed' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null };
export type PositionId = bigint;
export interface Profile {
  'id' : UserId,
  'bio' : [] | [string],
  'displayName' : string,
  'investedPositions' : Array<PositionId>,
  'follows' : Array<TraderId>,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : string } |
  { 'err' : Error };
export type Result_2 = { 'ok' : Profile } |
  { 'err' : Error };
export type TraderId = Principal;
export type UserId = Principal;
export interface _SERVICE {
  'createInvestorProfile' : ActorMethod<[string, [] | [string]], Result>,
  'debugUpsertBinanceApiKeyFromPlainText' : ActorMethod<
    [string, string],
    Result,
  >,
  'deleteInvestorProfile' : ActorMethod<[], Result>,
  'followTrader' : ActorMethod<[TraderId], Result>,
  'readInvestorProfile' : ActorMethod<[], Result_2>,
  'retrieveApiKey' : ActorMethod<[string], Result_1>,
  'setPassword' : ActorMethod<[string], Result>,
  'unfollowTrader' : ActorMethod<[TraderId], Result>,
  'validatePassword' : ActorMethod<[string, UserId], boolean>,
}
