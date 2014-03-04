%%% @author  <sebastianwo@MEG-865>
%%% @copyright (C) 2013,
%%% @doc
%%%
%%% @end
%%% Created :  6 Dec 2013 by  <sebastianwo@MEG-865>

-module(wdgm_command).

-include_lib("eqc/include/eqc.hrl").
-include("wdgm_config.hrl").

-compile(export_all).

-define(WDGMSTATEM, wdgm_statem_eqc).


%%% -WdgM_Init------------------------------------------------------------------

init_command(_S) ->
  {call, ?WDGMSTATEM, init, [frequency([{20, return({eqc_c:address_of(?CONFIG_FILE), false})},
                                   {1, return({{ptr, "WdgM_ConfigType", 0}, true})}])]}.

%%% -WdgM_GetMode---------------------------------------------------------------

getmode_command(_S) ->
  {call, ?WDGMSTATEM, getmode, [frequency([{20, return(false)},
                                           {1, return(true)}])]}.

%%% -WdgM_SetMode---------------------------------------------------------------

setmode_command(_S) ->
  {call, ?WDGMSTATEM, setmode, [choose(0,3), choose(1,2)]}. %% borde avspegla de aktuella värdena

%%% -WdgM_DeInit----------------------------------------------------------------

deinit_command(_S) ->
  {call, ?WDGMSTATEM, deinit, []}.


%%% -WdgM_CheckpointReached-----------------------------------------------------

checkpointreached_command(S) ->
  {call, ?WDGMSTATEM, checkpointreached, checkpoint_gen(S)}.

checkpoint_gen(S) ->
  case wdgm_pre:checkpointreached_pre(S) of
    false -> [false];
    true ->
      SEs = wdgm_config_params:get_supervised_entities(),
      ActivatedSEid   = [SEid
                         || {SEid,_} <- SEs,
                            wdgm_config_params:is_activated_SE_in_mode(S#state.currentMode, SEid)],
      DeactivatedSEid = [SEid
                         || {SEid,_} <- SEs,
                            not lists:member(SEid, ActivatedSEid)],
      ?LET(SEid, frequency([{20, oneof(case ActivatedSEid of
                                          [] -> [999];
                                          Xs -> Xs
                                       end)},   %% either choose one of the valid SEid
                                                % (This demands there is at least one ActivatedSEid)
                            {1, oneof(DeactivatedSEid++[999])}, % (This demands there is at least one DeactivatedSEid)
                            {1, return(999)}]), %% or a phony
           return(case SEid of
             999 -> [999, 999]; %% if the phony, also choose a phony CPid
             _   ->
               ?LET(LCPs, frequency( %% mostly prioritize checkpointreached, but also make room for negative testing
                        [
                         {1,return(lists:map(fun(X) -> {found,SEid,X} end,wdgm_config_params:get_CPs_of_SE(SEid)))},
                         {20,return(lists:flatten(wdgm_checkpointreached:get_args_given_LS(S#state.logicalTable, SEid)))}
                        ]),
               wdgm_checkpointreached:choose_SE_and_CP(S, LCPs))
           end))
  end.


%%% -WdgM_UpdateAliveCounter----------------------------------------------------
%% Deprecated

%%% -WdgM_GetLocalStatus--------------------------------------------------------

getlocalstatus_command(_S) ->
  {call, ?WDGMSTATEM, getlocalstatus, [frequency([{20, choose(0,4)},
                                                  {1, return(999)}]),
                                       frequency([{20, return(false)},
                                                  {1, return(true)}])]}.

%%% -WdgM_GetGlobalStatus-------------------------------------------------------

getglobalstatus_command(_S) ->
  {call, ?WDGMSTATEM, getglobalstatus, [frequency([{20, return(false)},
                                                   {1, return(true)}])]}.

%%% -WdgM_PerformReset----------------------------------------------------------

performreset_command (_S) ->
  {call, ?WDGMSTATEM, performreset, []}.

%%% -WdgM_GetFirstExpiredSEID---------------------------------------------------

getfirstexpiredseid_command(_S) ->
  {call, ?WDGMSTATEM, getfirstexpiredseid, [frequency([{20, return(false)},
                                                       {1, return(true)}])]}.


%%% -WdgM_MainFunction----------------------------------------------------------

mainfunction_command(_S) ->
  {call, ?WDGMSTATEM, mainfunction, []}.

%%% -WdgM_GetVersionInfo--------------------------------------------------------

getversioninfo_command(_S) ->
  {call, ?WDGMSTATEM, getversioninfo, [frequency([{20, return(false)},
                                                  {1, return(true)}])]}.
