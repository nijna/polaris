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
  'create' : ActorMethod<[string], Result>,
  'delete' : ActorMethod<[], Result>,
  'principalExists' : ActorMethod<[UserId], boolean>,
  'read' : ActorMethod<[], Result_1>,
  'readFamePoints' : ActorMethod<[UserId], FamePoints>,
  'updateBio' : ActorMethod<[string], Result>,
}
