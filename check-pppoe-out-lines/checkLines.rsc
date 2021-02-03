#auto check and reconnect bridge lines by Alna7ari
#the pppoe-out interfaces must name with defualt named like pppoe-out1
#enjoy...
{
:global ipsArray {"82.114.160.45"; "8.8.8.8"; "1.1.1.1"}; # use this array to ping every ip for test connection
foreach pppClient in=[/interface pppoe-client find where disabled=no] do={

	do {
		:global clientName [/interface get $pppClient name];
		:global totalTrafficUsed [/interface get $pppClient rx-packet];
		:put $totalTrafficUsed;
		:delay 5s;
		:global newTotalTrafficUsed [/interface get $pppClient rx-packet];
		:if ($totalTrafficUsed != $newTotalTrafficUsed) do={
			:log info ("calc traffic check: the client: $clientName is already connected");
			:error "";
		}
		:global pingCount 0;
		foreach ipAddress in=$ipsArray do={
			:set pingCount ($pingCount + [ping "$ipAddress" interface=$pppClient count=1]);
		};
		
		:if ($pingCount >= 1) do={ 
			:log info ("ping check: the client: $clientName is already connected");
			:error "";
		}
		/interface enable $pppClient; 
		} on-error={ :put "not-found"}
	}
	:delay 10s;
	execute {
		/system script run check-lines;
		/quit
	}
}
