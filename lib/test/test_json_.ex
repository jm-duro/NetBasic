include std/filesys.e
include lib/_debug_.e
include lib/_json_.e
include get.e

constant JSON_DATA = {
  "{\"key1\" : {\"key1.1\" : 2}, \"key2\" : 2}",
  "[120,183,\"alpha\",\"beta\",\"gamma\"]",
  "{\"age\" : 51.5, \"details\" : [120,183], \"embedded\" : { \"three\" : 3.0, \"arr\" : [1,2,3,\"alpha\",\"beta\",\"gamma\"]} }",
  "{\"him\" : true, \"her\" : false, \"nothing\" : null }",
  "{\"dog\" : {\"name\" : \"Rover\", \"gender\" : \"male\"}}",
--  "{\"configure\":[{\"access-control\":[{\"access-list\":[]}]},{\"slot\":[]},{\"system\":[{\"date-and-time\":[{\"sntp\":[{\"server\":[]}]}]},{\"syslog\":[]}]},{\"management\":[{\"login-user\":[]},{\"snmp\":[{\"community\":[]}]},{\"access\":[]},{\"tacacsplus\":[{\"group\":[]}]}]},{\"qos\":[{\"policer-profile\":[]},{\"shaper-profile\":[]},{\"wred-profile\":[]},{\"queue-block-profile\":[{\"queue\":[]}]},{\"queue-group-profile\":[{\"queue-block\":[]}]}]},{\"port\":[{\"l2cp-profile\":[]},{\"ethernet\":[]},{\"svi\":[]}]},{\"bridge\":[{\"port\":[]},{\"vlan\":[]}]},{\"flows\":[{\"classifier-profile\":[]},{\"flow\":[]}]},{\"router\":[{\"interface\":[{\"dhcp-client\":[]}]}]},{\"oam\":[{\"cfm\":[{\"maintenance-domain\":[{\"maintenance-association\":[{\"mep\":[]}]}]}]}]},{\"test\":[{\"rfc2544\":[{\"profile-name\":[]}]}]}]}"
  "{\"sessionId\":\"01bd8a1c4d3bf479eb58afd5be0d29f0\",\"status\":0,\"value\":{\"acceptSslCerts\":true,\"applicationCacheEnabled\":false,\"browserConnectionEnabled\":false,\"browserName\":\"chrome\",\"chrome\":{\"chromedriverVersion\":\"2.27.440196 (3b42f4145a4fd223b41f39bb38aaf90508be7a96)\",\"userDataDir\":\"/tmp/.org.chromium.Chromium.8wSmXJ\"},\"cssSelectorsEnabled\":true,\"databaseEnabled\":false,\"handlesAlerts\":true,\"hasTouchScreen\":false,\"javascriptEnabled\":true,\"locationContextEnabled\":true,\"mobileEmulationEnabled\":false,\"nativeEvents\":true,\"networkConnectionEnabled\":false,\"pageLoadStrategy\":\"normal\",\"platform\":\"Linux\",\"rotatable\":false,\"takesHeapSnapshot\":true,\"takesScreenshot\":true,\"unexpectedAlertBehaviour\":\"\",\"version\":\"57.0.2987.98\",\"webStorageEnabled\":true}}"
}

--------------------------------------------------------------------------------

sequence result

f_debug = open(InitialDir & SLASH & "debug.log", "w")

for i = 1 to length(JSON_DATA) do
  result = json_to_sequence(JSON_DATA[i])
  analyze_object(result, "result", f_debug)
end for

close(f_debug)
puts(1, "Finished!\n")
void = wait_key()

