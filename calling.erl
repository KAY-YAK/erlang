%% @author Turiya
%% @doc @todo Add description to calling.


-module(calling).

%% ====================================================================
%% API functions
%% ====================================================================
-export([deadpool/4]).
-import(string,[equal/2]).
%% func deadpool
deadpool(Msg, M_pid, State, S_name)->
	if
		State == 0 ->
			timer:sleep(500),
			lists:foreach(fun(X) -> whereis(X)!{S_name,"intro",self()} end, Msg),
			deadpool(Msg, M_pid, State + 1, S_name);
		State > 0 ->
			receive
				{P_name, P_msg, P_ini_time} -> 
					case equal(P_msg,"intro") of
						true ->
							{_,_,Time} = erlang:now(),
							M_pid!{S_name,P_msg, P_name, Time},
							whereis(P_name)!{S_name, "reply",Time},
							NewState = State + 1,
							deadpool(Msg, M_pid, NewState + 1, S_name);
						false ->
							M_pid!{S_name,P_msg, P_name, P_ini_time},
							NewState = State + 1,
							deadpool(Msg, M_pid, NewState, S_name)
					end
			after
				1000->
					io:fwrite(lists:concat([S_name," has received no calls for 1 second, ending...","\n\n"]))
			end
		  
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================


