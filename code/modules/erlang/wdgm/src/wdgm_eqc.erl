-module(wdgm_eqc).

-include_lib("eqc/include/eqc.hrl").

-compile(export_all).

-define(C_CODE, wdgm_wrapper).

%% -Eqc start-------------------------------------------------------------------

getPath(Xs) ->
         filename:join(lists:takewhile(fun (X) -> X /= "modules" end,
                                       filename:split(filename:absname(".")))++["modules"] ++ Xs) ++ "/".

lib_dir() -> getPath(["c","WdgM","out"]).
src_dir() -> getPath(["c","WdgM","eqc"]).

start() ->
        eqc_c:start(wdgm_wrapper,[{c_src,src_dir() ++ "wdgm_wrapper.c"},
                                  {exclude_functions,[]},{additional_files,
                                                          [lib_dir() ++ "WdgM_Pbcfg.o",
                                                           lib_dir() ++ "WdgM_Lcfg.o",
                                                           lib_dir() ++ "Dem.o",
                                                           lib_dir() ++ "Det.o",
                                                           lib_dir() ++ "Mcu.o",
                                                           lib_dir() ++ "Rte.o",
                                                           lib_dir() ++ "SchM_WdgM.o",
                                                           lib_dir() ++ "WdgIf.o",
                                                           lib_dir() ++ "WdgM.o"]}]).

%start() ->
%  eqc_c:start(?C_CODE,
%	      [{c_src, "wdgm_wrapper.c"},
%	       {exclude_functions,[]},
%	       {additional_files, ["../out/WdgM_Pbcfg.o","../out/WdgM_Lcfg.o",
%				   "../out/Dem.o","../out/Det.o","../out/Mcu.o",
%				   "../out/Rte.o","../out/SchM_WdgM.o",
%				   "../out/WdgIf.o", "../out/WdgM.o"]}]) .
