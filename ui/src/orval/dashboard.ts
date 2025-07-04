/**
 * Generated by orval v7.10.0 🍺
 * Do not edit manually.
 * UI Router API
 * Defines the specification for the UI Catalog API
 * OpenAPI spec version: 1.0.2
 */
import { useQuery } from '@tanstack/react-query';
import type {
  DataTag,
  DefinedInitialDataOptions,
  DefinedUseQueryResult,
  QueryClient,
  QueryFunction,
  QueryKey,
  UndefinedInitialDataOptions,
  UseQueryOptions,
  UseQueryResult,
} from '@tanstack/react-query';

import { useAxiosMutator } from '../lib/axiosMutator';
import type { ErrorType } from '../lib/axiosMutator';
import type { Dashboard, ErrorResponse } from './models';

type SecondParameter<T extends (...args: never) => unknown> = Parameters<T>[1];

export const getDashboard = (
  options?: SecondParameter<typeof useAxiosMutator>,
  signal?: AbortSignal,
) => {
  return useAxiosMutator<Dashboard>({ url: `/ui/dashboard`, method: 'GET', signal }, options);
};

export const getGetDashboardQueryKey = () => {
  return [`/ui/dashboard`] as const;
};

export const getGetDashboardQueryOptions = <
  TData = Awaited<ReturnType<typeof getDashboard>>,
  TError = ErrorType<ErrorResponse>,
>(options?: {
  query?: Partial<UseQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>>;
  request?: SecondParameter<typeof useAxiosMutator>;
}) => {
  const { query: queryOptions, request: requestOptions } = options ?? {};

  const queryKey = queryOptions?.queryKey ?? getGetDashboardQueryKey();

  const queryFn: QueryFunction<Awaited<ReturnType<typeof getDashboard>>> = ({ signal }) =>
    getDashboard(requestOptions, signal);

  return { queryKey, queryFn, ...queryOptions } as UseQueryOptions<
    Awaited<ReturnType<typeof getDashboard>>,
    TError,
    TData
  > & { queryKey: DataTag<QueryKey, TData, TError> };
};

export type GetDashboardQueryResult = NonNullable<Awaited<ReturnType<typeof getDashboard>>>;
export type GetDashboardQueryError = ErrorType<ErrorResponse>;

export function useGetDashboard<
  TData = Awaited<ReturnType<typeof getDashboard>>,
  TError = ErrorType<ErrorResponse>,
>(
  options: {
    query: Partial<UseQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>> &
      Pick<
        DefinedInitialDataOptions<
          Awaited<ReturnType<typeof getDashboard>>,
          TError,
          Awaited<ReturnType<typeof getDashboard>>
        >,
        'initialData'
      >;
    request?: SecondParameter<typeof useAxiosMutator>;
  },
  queryClient?: QueryClient,
): DefinedUseQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> };
export function useGetDashboard<
  TData = Awaited<ReturnType<typeof getDashboard>>,
  TError = ErrorType<ErrorResponse>,
>(
  options?: {
    query?: Partial<UseQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>> &
      Pick<
        UndefinedInitialDataOptions<
          Awaited<ReturnType<typeof getDashboard>>,
          TError,
          Awaited<ReturnType<typeof getDashboard>>
        >,
        'initialData'
      >;
    request?: SecondParameter<typeof useAxiosMutator>;
  },
  queryClient?: QueryClient,
): UseQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> };
export function useGetDashboard<
  TData = Awaited<ReturnType<typeof getDashboard>>,
  TError = ErrorType<ErrorResponse>,
>(
  options?: {
    query?: Partial<UseQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>>;
    request?: SecondParameter<typeof useAxiosMutator>;
  },
  queryClient?: QueryClient,
): UseQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> };

export function useGetDashboard<
  TData = Awaited<ReturnType<typeof getDashboard>>,
  TError = ErrorType<ErrorResponse>,
>(
  options?: {
    query?: Partial<UseQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>>;
    request?: SecondParameter<typeof useAxiosMutator>;
  },
  queryClient?: QueryClient,
): UseQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> } {
  const queryOptions = getGetDashboardQueryOptions(options);

  const query = useQuery(queryOptions, queryClient) as UseQueryResult<TData, TError> & {
    queryKey: DataTag<QueryKey, TData, TError>;
  };

  query.queryKey = queryOptions.queryKey;

  return query;
}
