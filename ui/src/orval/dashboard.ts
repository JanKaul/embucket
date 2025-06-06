/**
 * Generated by orval v7.9.0 🍺
 * Do not edit manually.
 * UI Router API
 * Defines the specification for the UI Catalog API
 * OpenAPI spec version: 1.0.2
 */
import { useInfiniteQuery, useQuery } from '@tanstack/react-query';
import type {
  DataTag,
  DefinedInitialDataOptions,
  DefinedUseInfiniteQueryResult,
  DefinedUseQueryResult,
  InfiniteData,
  QueryClient,
  QueryFunction,
  QueryKey,
  UndefinedInitialDataOptions,
  UseInfiniteQueryOptions,
  UseInfiniteQueryResult,
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

export const getGetDashboardInfiniteQueryOptions = <
  TData = InfiniteData<Awaited<ReturnType<typeof getDashboard>>>,
  TError = ErrorType<ErrorResponse>,
>(options?: {
  query?: Partial<UseInfiniteQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>>;
  request?: SecondParameter<typeof useAxiosMutator>;
}) => {
  const { query: queryOptions, request: requestOptions } = options ?? {};

  const queryKey = queryOptions?.queryKey ?? getGetDashboardQueryKey();

  const queryFn: QueryFunction<Awaited<ReturnType<typeof getDashboard>>> = ({ signal }) =>
    getDashboard(requestOptions, signal);

  return { queryKey, queryFn, ...queryOptions } as UseInfiniteQueryOptions<
    Awaited<ReturnType<typeof getDashboard>>,
    TError,
    TData
  > & { queryKey: DataTag<QueryKey, TData, TError> };
};

export type GetDashboardInfiniteQueryResult = NonNullable<Awaited<ReturnType<typeof getDashboard>>>;
export type GetDashboardInfiniteQueryError = ErrorType<ErrorResponse>;

export function useGetDashboardInfinite<
  TData = InfiniteData<Awaited<ReturnType<typeof getDashboard>>>,
  TError = ErrorType<ErrorResponse>,
>(
  options: {
    query: Partial<
      UseInfiniteQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>
    > &
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
): DefinedUseInfiniteQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> };
export function useGetDashboardInfinite<
  TData = InfiniteData<Awaited<ReturnType<typeof getDashboard>>>,
  TError = ErrorType<ErrorResponse>,
>(
  options?: {
    query?: Partial<
      UseInfiniteQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>
    > &
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
): UseInfiniteQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> };
export function useGetDashboardInfinite<
  TData = InfiniteData<Awaited<ReturnType<typeof getDashboard>>>,
  TError = ErrorType<ErrorResponse>,
>(
  options?: {
    query?: Partial<
      UseInfiniteQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>
    >;
    request?: SecondParameter<typeof useAxiosMutator>;
  },
  queryClient?: QueryClient,
): UseInfiniteQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> };

export function useGetDashboardInfinite<
  TData = InfiniteData<Awaited<ReturnType<typeof getDashboard>>>,
  TError = ErrorType<ErrorResponse>,
>(
  options?: {
    query?: Partial<
      UseInfiniteQueryOptions<Awaited<ReturnType<typeof getDashboard>>, TError, TData>
    >;
    request?: SecondParameter<typeof useAxiosMutator>;
  },
  queryClient?: QueryClient,
): UseInfiniteQueryResult<TData, TError> & { queryKey: DataTag<QueryKey, TData, TError> } {
  const queryOptions = getGetDashboardInfiniteQueryOptions(options);

  const query = useInfiniteQuery(queryOptions, queryClient) as UseInfiniteQueryResult<
    TData,
    TError
  > & { queryKey: DataTag<QueryKey, TData, TError> };

  query.queryKey = queryOptions.queryKey;

  return query;
}

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
