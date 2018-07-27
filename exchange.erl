%% @author Turiya
%% @doc @todo Add description to exchange.


-module(exchange).

%% ====================================================================
%% API functions
%% ====================================================================


%% @author Turiya
%% @doc @todo Add description to assign.


-import(lists,[append/2,concat/1,flatten/1]).
-import(string,[equal/2]).
-import(file,[consult/1]).
-import(calling,[deadpool/4]).
-export([make/1, main_proc/1, start/0,prnt/1]). 


%%USE THIS FUNCTION TO PASS LIST OF TUPLES {name,process_id} 
prnt([])->ok;
prnt([H|T])->{Caller,Calee} = H,
			 io:format(Caller),
			 io:format(" : "),
			 io:format("~w~n", [Calee]), 
			 prnt(T).


%% CREATE PROCESS 
make([])->ok;
make([H|T])->
%% 	io:fwrite(aaaa),
	{Caller,Calee} = H,
	Pid = spawn(calling,deadpool,[Calee,self(),0,Caller]),
	register(Caller,Pid),
	make(T).
get_timestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega*1000000 + Sec)*1000 + round(Micro/1000).	




%% Master Server
main_proc(State)->
	receive
		{P_to, P_msg, P_from, P_time} ->
			Msg = lists:concat([P_to," received ", P_msg, " message from " ,P_from, "[",P_time,"]","\n"]),
			io:fwrite(Msg),
			main_proc(State+1)
	after
		2000->
			ok
	end.


start() ->
	{_,B} = file:consult("C:/Users/Turiya/eclipse/java-oxygen2/eclipse/calls.txt"),
	make(B),
	io:fwrite("** Calls to be made **\n"),
	prnt(B),
	io:fwrite("\n\n"),
	main_proc(0).






%% ====================================================================
%% Internal functions
%% ====================================================================


