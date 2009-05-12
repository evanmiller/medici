%%%-------------------------------------------------------------------
%%% File    : medici_client_sup.erl
%%% Author  : Jim McCoy <>
%%% Description : 
%%%
%%% Created :  6 May 2009 by Jim McCoy <>
%%%-------------------------------------------------------------------
-module(medici_client_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(NUM_CLIENTS, 8).

%%====================================================================
%% API functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the supervisor
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link([]).

start_link(MediciOpts) ->
    supervisor:start_link(?MODULE, MediciOpts).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Func: init(Args) -> {ok,  {SupFlags,  [ChildSpec]}} |
%%                     ignore                          |
%%                     {error, Reason}
%% Description: Whenever a supervisor is started using 
%% supervisor:start_link/[2,3], this function is called by the new process 
%% to find out about restart strategy, maximum restart frequency and child 
%% specifications.
%%--------------------------------------------------------------------
init(MediciOpts) ->
    ClientCount = proplists:get_value(num_clients, MediciOpts, ?NUM_CLIENTS),
    ChildList = [{'medici_client_'++integer_to_list(ChildNum), 
		  {medici_client, start_link, MediciOpts},
		  permanent,
		  2000,
		  worker,
		  [medici_client]} || ChildNum <- list:seq(1, ClientCount)]
    {ok,{{one_for_one,ClientCount*2,5}, ChildList}}.

%%====================================================================
%% Internal functions
%%====================================================================
