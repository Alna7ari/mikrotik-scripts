#auto check and reconnect bridge lines by Alna7ari
#the pppoe-out interfaces must name with defualt named like pppoe-out1
#enjoy...
{
:global linesCount 4; #change this var to your pppoe-out count
:global ipsArray {"82.114.160.45"; "8.8.8.8"; "1.1.1.1"}; # use this array to ping every ip for test connection
for lineNumber from=1 to=$linesCount step=1 do={

	do {
		:global totalTrafficUsed [/interface get "pppoe-out$lineNumber" rx-packet];
		:put $totalTrafficUsed;
		:delay 5s;
		:global newTotalTrafficUsed [/interface get "pppoe-out$lineNumber" rx-packet];
		:if ($totalTrafficUsed != $newTotalTrafficUsed) do={
			:log info ("calc traffic check: the pppoe-out$lineNumber is already connected");
			:error "";
		}
		:global pingCount 0;
		foreach ipAddress in=$ipsArray do={
			:set pingCount ($pingCount + [ping "$ipAddress" interface="pppoe-out$lineNumber" count=1]);
		};
		
		:if ($pingCount >= 1) do={ 
			:log info ("ping check: the pppoe-out$lineNumber is already connected");
			:error "";
		}
		/interface enable "pppoe-out$lineNumber"; 
		} on-error={ :put "not-found"}
	}
	execute {
		:delay 10s;
		/system script run check-lines;
		/quit
	}
}
