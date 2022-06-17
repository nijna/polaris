import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Error = { 'NotEnoughFamePoints' : null } |
  { 'ClosingTimeInPast' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'AlreadyExists' : null } |
  { 'StopLossHigherThanSpot' : null } |
  { 'PositionAlreadyClosed' : null } |
  { 'TargetLowerThanSpot' : null };
export type Exchange = { 'Binance' : null };
export type InvestorId = Principal;
export type OpenerId = Principal;
export type Pair = { 'BTCUSDT' : null } |
  { 'BNBUSDT' : null };
export interface Position {
  'id' : PositionId,
  'active' : boolean,
  'pair' : Pair,
  'successfulPosition' : [] | [boolean],
  'targetPrice' : number,
  'demoPosition' : boolean,
  'creationTime' : bigint,
  'investorIds' : Array<InvestorId>,
  'spotPrice' : number,
  'stopLossPrice' : number,
  'closingTime' : bigint,
  'exchange' : Exchange,
  'openerId' : OpenerId,
}
export type PositionId = bigint;
export type Result = { 'ok' : Position } |
  { 'err' : Error };
export type Result_1 = { 'ok' : null } |
  { 'err' : Error };
export interface _SERVICE {
  'closePosition' : ActorMethod<[PositionId], Result_1>,
  'getAllActivePositions' : ActorMethod<[], Array<[PositionId, Position]>>,
  'getAllActivePositionsByInvestor' : ActorMethod<
    [InvestorId],
    Array<[PositionId, Position]>,
  >,
  'getAllActivePositionsByTrader' : ActorMethod<
    [OpenerId],
    Array<[PositionId, Position]>,
  >,
  'getAllClosedPositions' : ActorMethod<[], Array<[PositionId, Position]>>,
  'getAllClosedPositionsByInvestor' : ActorMethod<
    [InvestorId],
    Array<[PositionId, Position]>,
  >,
  'getAllClosedPositionsByTrader' : ActorMethod<
    [OpenerId],
    Array<[PositionId, Position]>,
  >,
  'getAllPositions' : ActorMethod<[], Array<[PositionId, Position]>>,
  'getAllPositionsByInvestor' : ActorMethod<
    [InvestorId],
    Array<[PositionId, Position]>,
  >,
  'getAllPositionsByTrader' : ActorMethod<
    [OpenerId],
    Array<[PositionId, Position]>,
  >,
  'openPosition' : ActorMethod<
    [Pair, Exchange, number, number, number, bigint, boolean],
    Result_1,
  >,
  'readPosition' : ActorMethod<[PositionId], Result>,
}
