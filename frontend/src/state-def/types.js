// @flow

import type { Reducer } from 'redux';

export type $StateFunction<State, Payload> = Payload => State;

export type $StateFunctionMap<State> = {
  [key: string]: * => State,
};

export type $Action<Payload, StateFunctionMap> = {
  type: $Keys<StateFunctionMap>,
  payload?: Payload,
  error?: Error,
};

export type $ActionCreator<Payload, StateFunctionMap> =
  (payload?: Payload, error?: Error) => $Action<Payload, StateFunctionMap>;

export type $ActionsMap<State, StateFunctionMap> =
  $ObjMap<StateFunctionMap, $ExtractActionCreator<State, StateFunctionMap>>;

type $ExtractActionCreator<State, StateFunctionMap> =
  <Payload>(v: $StateFunction<State, Payload>) => $ActionCreator<Payload, StateFunctionMap>

// eslint-disable-next-line flowtype/no-weak-types
export type $Reducer<State, StateFunctionMap> = Reducer<State, $Action<any, StateFunctionMap>>;

export type $StateDef<State, StateFunctionMap> = {
  namespace: string,
  initializeState: State => State,
  reducer: $Reducer<State, StateFunctionMap>,
};
