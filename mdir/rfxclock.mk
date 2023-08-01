
all:
	$(GCC) $(CFLAG) \
	$(SRC)/rfxclock.c \
	$(SRC)/platform_sm.c \
	$(SRC)/ion.c \
	$(SRC)/rfx.c \
	$(SRC)/smlist.c \
	$(SRC)/psm.c \
	$(SRC)/platform.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrxn.c \
	$(SRC)/memmgr.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrlist.c \
	$(SRC)/zco.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/sptrace.c \
	$(SRC)/lyst.c \
	$(SRC)/bulk.c \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/rfxclock

# Only for windows
# cp ../ion-open-source-4.1.1/ici/include/sdrstring.h inc 

# grep -rn bulk_destroy ../ion-open-source-4.1.1/ --exclude=*.js --exclude=*.cpp --exclude=*.supp --exclude=*.pod

# find ../ion-open-source-4.1.1/ -name lystP.h


# cp ../ion-open-source-4.1.1/ici/daemon/rfxclock.c src

# ../ion-open-source-4.1.1/ici/include/platform_sm.h:98:extern void		*sm_TaskVar(void **arg);
# ../ion-open-source-4.1.1/ici/library/platform_sm.c:2090:void	*sm_TaskVar(void **arg)

# cp ../ion-open-source-4.1.1/ici/include/platform_sm.h inc
# cp ../ion-open-source-4.1.1/ici/library/platform_sm.c src

# ../ion-open-source-4.1.1/ici/library/ion.c:1289:IonVdb	*getIonVdb()
# ../ion-open-source-4.1.1/ici/include/ion.h:528:extern IonVdb		*getIonVdb();
# cp ../ion-open-source-4.1.1/ici/library/ion.c src
# cp ../ion-open-source-4.1.1/ici/include/ion.h inc

# ../ion-open-source-4.1.1/ici/include/rfx.h:204:extern IonNode		*findNode(IonVdb *ionvdb, uvast nodeNbr,
# ../ion-open-source-4.1.1/ici/library/rfx.c:333:IonNode	*findNode(IonVdb *ionvdb, uvast nodeNbr, PsmAddress *nextElt)

# cp ../ion-open-source-4.1.1/ici/include/rfx.h inc
# cp ../ion-open-source-4.1.1/ici/library/rfx.c src

# ../ion-open-source-4.1.1/ici/library/smlist.c:610:PsmAddress	sm_list_first(PsmPartition partition, PsmAddress list)
# ../ion-open-source-4.1.1/ici/include/smlist.h:93:extern PsmAddress	sm_list_first(PsmPartition partition, PsmAddress list);
# cp ../ion-open-source-4.1.1/ici/library/smlist.c src
# cp ../ion-open-source-4.1.1/ici/include/smlist.h inc

# ../ion-open-source-4.1.1/ici/include/psm.h:90:extern void		*psp(PsmPartition, PsmAddress);
# ../ion-open-source-4.1.1/ici/library/psm.c:379:void    *psp(PsmPartition partition, PsmAddress address)
# cp ../ion-open-source-4.1.1/ici/include/psm.h inc
# cp ../ion-open-source-4.1.1/ici/library/psm.c src

# ../ion-open-source-4.1.1/ici/library/platform.c:1747:int	_iEnd(const char *fileName, int lineNbr, const char *arg)
# ../ion-open-source-4.1.1/ici/include/platform.h:814:extern int			_iEnd(const char *, int, const char *);
# cp ../ion-open-source-4.1.1/ici/library/platform.c src
# cp ../ion-open-source-4.1.1/ici/include/platform.h inc

# ../ion-open-source-4.1.1/ici/include/smrbt.h:80:extern void		Sm_rbt_delete(const char *file, int line,
# ../ion-open-source-4.1.1/ici/library/smrbt.c:568:void	Sm_rbt_delete(const char *file, int line, PsmPartition partition,
# cp ../ion-open-source-4.1.1/ici/include/smrbt.h inc
# cp ../ion-open-source-4.1.1/ici/library/smrbt.c src

# ../ion-open-source-4.1.1/ici/include/sdrxn.h:272:extern void		sdr_read(Sdr sdr, char *into, Address from,
# ../ion-open-source-4.1.1/ici/sdr/sdrxn.c:2159:void	sdr_read(Sdr sdrv, char *into, Address from, size_t length)
# cp ../ion-open-source-4.1.1/ici/include/sdrxn.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrxn.c src

# ../ion-open-source-4.1.1/ici/include/memmgr.h:77:void		memmgr_destroy(uaddr smId, PsmPartition *partition);
# ../ion-open-source-4.1.1/ici/library/memmgr.c:351:void	memmgr_destroy(uaddr smId, PsmPartition *partition)
# cp ../ion-open-source-4.1.1/ici/include/memmgr.h inc
# cp ../ion-open-source-4.1.1/ici/library/memmgr.c src

# ../ion-open-source-4.1.1/ici/include/sdr.h:44:extern Object		sdr_find(Sdr sdr, char *name, int *type);
# ../ion-open-source-4.1.1/ici/sdr/sdrcatlg.c:151:Object	sdr_find(Sdr sdrv, char *name, int *type)
# cp ../ion-open-source-4.1.1/ici/include/sdr.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrcatlg.c src

# ../ion-open-source-4.1.1/ici/include/sdrlist.h:40:extern Object		Sdr_list_create(const char *file, int line,
# ../ion-open-source-4.1.1/ici/sdr/sdrlist.c:61:Object	Sdr_list_create(const char *file, int line, Sdr sdrv)
# cp ../ion-open-source-4.1.1/ici/include/sdrlist.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrlist.c src

# ../ion-open-source-4.1.1/ici/include/zco.h:273:extern void	zco_set_max_heap_occupancy(Sdr sdr,
# ../ion-open-source-4.1.1/ici/library/zco.c:576:void	zco_set_max_heap_occupancy(Sdr sdr, double limit, ZcoAcct acct)
# cp ../ion-open-source-4.1.1/ici/include/zco.h inc
# cp ../ion-open-source-4.1.1/ici/library/zco.c src

# cp ../ion-open-source-4.1.1/ici/include/bulk.h inc

# ../ion-open-source-4.1.1/ici/include/sdrmgt.h:46:extern Object		Sdr_malloc(const char *file, int line,
# ../ion-open-source-4.1.1/ici/sdr/sdrmgt.c:811:Object	Sdr_malloc(const char *file, int line, Sdr sdrv, size_t nbytes)
# cp ../ion-open-source-4.1.1/ici/include/sdrmgt.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrmgt.c src

# ../ion-open-source-4.1.1/ici/include/sptrace.h:75:extern void		sptrace_log_alloc(PsmPartition trace,
# ../ion-open-source-4.1.1/ici/library/sptrace.c:326:void	sptrace_log_alloc(PsmPartition trace, uaddr addr, size_t size,
# cp ../ion-open-source-4.1.1/ici/include/sptrace.h inc
# cp ../ion-open-source-4.1.1/ici/library/sptrace.c src

# ../ion-open-source-4.1.1/ici/include/lyst.h:45:void Lyst_clear(const char*,int,Lyst);
# ../ion-open-source-4.1.1/ici/library/lyst.c:159:Lyst_clear(const char *file, int line, Lyst list)
# cp ../ion-open-source-4.1.1/ici/include/lyst.h inc
# cp ../ion-open-source-4.1.1/ici/library/lyst.c src

# cp ../ion-open-source-4.1.1/ici/library/lystP.h inc

# ../ion-open-source-4.1.1/ici/bulk/STUB_BULK/bulk.c:111:void	bulk_destroy(unsigned long item)
# ../ion-open-source-4.1.1/ici/include/bulk.h:19:extern void		bulk_destroy(unsigned long item);
# cp ../ion-open-source-4.1.1/ici/bulk/STUB_BULK/bulk.c src
# cp ../ion-open-source-4.1.1/ici/include/bulk.h inc









