# This is probably the only thing users would want to change:
INSTALL_PATH = /usr/local/

PWD := $(shell pwd)

export SRC = $(PWD)/src
export INC = $(PWD)/inc
export OUT_BIN = $(PWD)/bin
export MAN = $(PWD)/man
export SCR = $(PWD)/scripts

# Just locally:
MDIR = $(PWD)/mdir
LIB = $(PWD)/lib

export CFLAG = -g -Wall -DSPACE_ORDER=3 -Wall -DBP_EXTENDED -lm -pthread

export PLATFORM = -lm -pthread
export GCC = /usr/bin/gcc

# Just locally:
MAKE = /usr/bin/make -f

.PHONY: all clean distclean install

all:
	$(MAKE) $(MDIR)/bping.mk
	$(MAKE) $(MDIR)/bpecho.mk
	$(MAKE) $(MDIR)/lgsend.mk
	$(MAKE) $(MDIR)/lgagent.mk
	$(MAKE) $(MDIR)/bpversion.mk
	$(MAKE) $(MDIR)/bptrace.mk
	$(MAKE) $(MDIR)/bpstats.mk
	$(MAKE) $(MDIR)/bplist.mk
	$(MAKE) $(MDIR)/sdrwatch.mk
	$(MAKE) $(MDIR)/psmwatch.mk
	$(MAKE) $(MDIR)/bpdriver.mk
	$(MAKE) $(MDIR)/bpcounter.mk
	$(MAKE) $(MDIR)/udpclo.mk
	$(MAKE) $(MDIR)/udpcli.mk
	$(MAKE) $(MDIR)/bpadmin.mk
	$(MAKE) $(MDIR)/ionadmin.mk
	$(MAKE) $(MDIR)/ltpadmin.mk
	$(MAKE) $(MDIR)/ipnadmin.mk
	$(MAKE) $(MDIR)/bprecvfile.mk
	$(MAKE) $(MDIR)/bpsendfile.mk
	$(MAKE) $(MDIR)/bpsink.mk
	$(MAKE) $(MDIR)/bpsource.mk
	$(MAKE) $(MDIR)/rfxclock.mk
	$(MAKE) $(MDIR)/ionwarn.mk
	$(MAKE) $(MDIR)/ltpclock.mk
	$(MAKE) $(MDIR)/ltpdeliv.mk
	$(MAKE) $(MDIR)/udplso.mk
	$(MAKE) $(MDIR)/udplsi.mk
	$(MAKE) $(MDIR)/ltpmeter.mk
	$(MAKE) $(MDIR)/bptransit.mk
	$(MAKE) $(MDIR)/ipnadminep.mk
	$(MAKE) $(MDIR)/ltpclo.mk
	$(MAKE) $(MDIR)/bpclock.mk
	$(MAKE) $(MDIR)/ltpcli.mk
	$(MAKE) $(MDIR)/ipnfw.mk
	$(MAKE) $(MDIR)/bpclm.mk
	$(MAKE) $(MDIR)/ionrestart.mk
	$(MAKE) $(MDIR)/bpchat.mk
#
bping:
	$(MAKE) $(MDIR)/bping.mk
#
bpecho:
	$(MAKE) $(MDIR)/bpecho.mk
#
lgsend:
	$(MAKE) $(MDIR)/lgsend.mk
#
lgagent:
	$(MAKE) $(MDIR)/lgagent.mk
#
bpversion:
	$(MAKE) $(MDIR)/bpversion.mk
#
bptrace:
	$(MAKE) $(MDIR)/bptrace.mk
#
bpstats:
	$(MAKE) $(MDIR)/bpstats.mk
#
bplist:
	$(MAKE) $(MDIR)/bplist.mk
#
sdrwatch:
	$(MAKE) $(MDIR)/sdrwatch.mk
#
psmwatch:
	$(MAKE) $(MDIR)/psmwatch.mk
#
bpdriver:
	$(MAKE) $(MDIR)/bpdriver.mk
#
bpcounter:
	$(MAKE) $(MDIR)/bpcounter.mk
#
udpclo:
	$(MAKE) $(MDIR)/udpclo.mk
#
udpcli:
	$(MAKE) $(MDIR)/udpcli.mk
#
bpadmin:
	$(MAKE) $(MDIR)/bpadmin.mk
#
ionadmin:
	$(MAKE) $(MDIR)/ionadmin.mk
#
ltpadmin:
	$(MAKE) $(MDIR)/ltpadmin.mk
#
ipnadmin:
	$(MAKE) $(MDIR)/ipnadmin.mk
#
bprecvfile:
	$(MAKE) $(MDIR)/bprecvfile.mk
#
bpsendfile:
	$(MAKE) $(MDIR)/bpsendfile.mk
#
bpsink:
	$(MAKE) $(MDIR)/bpsink.mk
#
bpsource:
	$(MAKE) $(MDIR)/bpsource.mk
#
rfxclock:
	$(MAKE) $(MDIR)/rfxclock.mk
#
ionwarn:
	$(MAKE) $(MDIR)/ionwarn.mk
#
ltpclock:
	$(MAKE) $(MDIR)/ltpclock.mk
#
ltpdeliv:
	$(MAKE) $(MDIR)/ltpdeliv.mk
#
udplso:
	$(MAKE) $(MDIR)/udplso.mk
#
udplsi:
	$(MAKE) $(MDIR)/udplsi.mk
#
ltpmeter:
	$(MAKE) $(MDIR)/ltpmeter.mk
#
bptransit:
	$(MAKE) $(MDIR)/bptransit.mk
#
ipnadminep:
	$(MAKE) $(MDIR)/ipnadminep.mk
#
ltpclo:
	$(MAKE) $(MDIR)/ltpclo.mk
#
bpclock:
	$(MAKE) $(MDIR)/bpclock.mk
#
ltpcli:
	$(MAKE) $(MDIR)/ltpcli.mk
#
ipnfw:
	$(MAKE) $(MDIR)/ipnfw.mk
#
bpclm:
	$(MAKE) $(MDIR)/bpclm.mk
#
ionrestart:
	$(MAKE) $(MDIR)/ionrestart.mk
#
bpchat:
	$(MAKE) $(MDIR)/bpchat.mk	
					
install:
	cp -v $(OUT_BIN)/* $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstart $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstart.awk $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/ionstop $(INSTALL_PATH)/bin
	cp -v $(OUT_BIN)/killm $(INSTALL_PATH)/bin
	cp -v $(MAN)/* $(INSTALL_PATH)/man

clean:
	@rm -f $(OUT_BIN)/* > /dev/null

distclean:
	@rm -f $(INC)/* > /dev/null
	@rm -f $(SRC)/* > /dev/null
	@rm -f $(LIB)/* > /dev/null
	@rm -f $(OUT_BIN)/* > /dev/null
	@rm -f $(MAN)/* > /dev/null






