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
  {call, ?WDGMSTATEM, init, [frequency([{20, return({eqc_c:address_of('Tst_Cfg1'), false})},
                                   {0, return({{ptr, int, 0}, true})}])]}.

%%% -WdgM_GetMode---------------------------------------------------------------

getmode_command(_S) ->
  {call, ?WDGMSTATEM, getmode, [frequency([{20, return(false)},
                                           {0, return(true)}])]}.

%%% -WdgM_SetMode---------------------------------------------------------------

setmode_command(_S) ->
  {call, ?WDGMSTATEM, setmode, [choose(0,3), choose(1,2)]}.


%%% -WdgM_DeInit----------------------------------------------------------------

deinit_command(_S) ->
  {call, ?WDGMSTATEM, deinit, []}.


%%% -WdgM_CheckpointReached-----------------------------------------------------

checkpointreached_command(S) ->
  {call, ?WDGMSTATEM, checkpointreached, checkpoint_gen(S)}.

checkpoint_gen(S) ->
  ValidSEid = [0,1,2,3,4],
  ?LET(SEid, frequency([{20, oneof(ValidSEid)}, %% either choose one of the valid SEid
                        {0, return(999)}]), %% or a phony
        case SEid of
          999 -> [999, 999]; %% if the phony, also choose a phony CPid
          _   ->
            LCPs = lists:flatten(wdgm_checkpointreached:get_args_given_LS(S#state.logicalTable, SEid)),
            wdgm_checkpointreached:choose_SE_and_CP(S, LCPs)
        end).


%%% -WdgM_UpdateAliveCounter----------------------------------------------------
%% Deprecated

%%% -WdgM_GetLocalStatus--------------------------------------------------------

getlocalstatus_command(_S) ->
  {call, ?WDGMSTATEM, getlocalstatus, [choose(1,5),
                                    frequency([{20, return(false)},
                                               {0, return(true)}])]}.

%%% -WdgM_GetGlobalStatus-------------------------------------------------------

getglobalstatus_command(_S) ->
  {call, ?WDGMSTATEM, getglobalstatus, [frequency([{20, return(false)},
                                               {0, return(true)}])]}.

%%% -WdgM_PerformReset----------------------------------------------------------

performreset_command (_S) ->
  {call, ?WDGMSTATEM, performreset, []}.

%%% -WdgM_GetFirstExpiredSEID---------------------------------------------------

getfirstexpiredseid_command(_S) ->
  {call, ?WDGMSTATEM, getfirstexpiredseid, [frequency([{20, return(false)},
                                                   {0, return(true)}])]}.


%%% -WdgM_MainFunction----------------------------------------------------------

mainfunction_command(_S) ->
  {call, ?WDGMSTATEM, mainfunction, []}.
