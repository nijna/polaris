import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Error = { 'NotEnoughFamePoints' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null };
export interface Profile { 'id' : UserId, 'investedPositions' : Array<bigint> }
export type Result = { 'ok' : Profile } |
  { 'err' : Error };
export type Result_1 = { 'ok' : null } |
  { 'err' : Error };
export type UserId = Principal;
export interface _SERVICE {
  'create' : ActorMethod<[], Result_1>,
  'delete' : ActorMethod<[], Result_1>,
  'read' : ActorMethod<[], Result>,
}