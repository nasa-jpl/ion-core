#
# Build list for ION-core 4.1.2
#
BUILD_LIST_INCLUDED = YES

#
# PART I: Mandatory Features (do not edit)
#
# ICI
PROGRAMS := ionadmin ionwarn rfxclock ionrestart 
# BPv7
PROGRAMS += bpadmin bpclm bpclock bptransit ipnadmin ipnadminep ipnfw
# Utility Programs
PROGRAMS += bpsink bpsource bpecho bping bpstats bptrace 

#
# PART II: Optional Feature List
#
# This list can be modified. At least one CLA must be included.
# ICI
PROGRAMS += psmwatch sdrwatch 
# BPv7
PROGRAMS += bpversion 
PROGRAMS += lgagent lgsend
# CLA: must include at least one of STCP, UDP, or LTP 
PROGRAMS += stcpcli stcpclo 
PROGRAMS += udpcli udpclo 
PROGRAMS += ltpcli ltpclo udplsi udplso ltpclock ltpdeliv ltpmeter ltpadmin

# Utility Programs
PROGRAMS += bprecvfile bpsendfile 
PROGRAMS += bpchat 
PROGRAMS += bpcounter bpdriver
PROGRAMS += bplist

#
# PART III: PLATFORM & BP Extension
#
# Work-in-progress