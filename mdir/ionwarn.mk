
all:
	$(GCC) $(CFLAG) \
	$(SRC)/ionwarn.c \
	$(SRC)/lyst.c \
	$(SRC)/ion.c \
	$(SRC)/platform.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/zco.c \
	$(SRC)/bulk.c \
	$(SRC)/smrbt.c \
	$(SRC)/psm.c \
	$(SRC)/sdrstring.c \
	$(SRC)/platform_sm.c \
	$(SRC)/memmgr.c \
	$(SRC)/smlist.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrlist.c \
	$(SRC)/rfx.c \
	$(SRC)/sptrace.c \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ionwarn

# Only for windows
# cp ../ion-open-source-4.1.1/ici/include/smlist.h inc

# grep -rn sptrace_log_memo ../ion-open-source-4.1.1/ --exclude=*.js --exclude=*.cpp --exclude=*.supp --exclude=*.pod

# find ../ion-open-source-4.1.1/ -name lystP.h


# cp ../ion-open-source-4.1.1/ici/utils/ionwarn.c src

# ../ion-open-source-4.1.1/ici/include/lyst.h:75:LystElt lyst_first(Lyst);
# ../ion-open-source-4.1.1/ici/library/lyst.c:415:lyst_first(Lyst list)
# cp ../ion-open-source-4.1.1/ici/include/lyst.h inc
# cp ../ion-open-source-4.1.1/ici/library/lyst.c src

# cp ../ion-open-source-4.1.1/ici/library/lystP.h inc

# ../ion-open-source-4.1.1/ici/include/ion.h:470:extern void		*allocFromIonMemory(const char *, int, size_t);
# ../ion-open-source-4.1.1/ici/library/ion.c:182:void	*allocFromIonMemory(const char *fileName, int lineNbr, size_t length)
# cp ../ion-open-source-4.1.1/ici/include/ion.h inc
# cp ../ion-open-source-4.1.1/ici/library/ion.c src

# ../ion-open-source-4.1.1/ici/include/platform.h:804:extern void			_putErrmsg(const char *, int, const char *,
# ../ion-open-source-4.1.1/ici/library/platform.c:1625:void	_putErrmsg(const char *fileName, int lineNbr, const char *text,
# cp ../ion-open-source-4.1.1/ici/include/platform.h inc
# cp ../ion-open-source-4.1.1/ici/library/platform.c src

# ../ion-open-source-4.1.1/ici/include/sdrxn.h:214:extern int		sdr_begin_xn(Sdr sdr);
# ../ion-open-source-4.1.1/ici/sdr/sdrxn.c:1771:int	sdr_begin_xn(Sdr sdrv)
# cp ../ion-open-source-4.1.1/ici/include/sdrxn.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrxn.c src

# cp ../ion-open-source-4.1.1/ici/sdr/sdrP.h inc

# ../ion-open-source-4.1.1/ici/include/sdrmgt.h:73:extern void		sdr_stage(Sdr sdr, char *into, Object from,
# ../ion-open-source-4.1.1/ici/sdr/sdrmgt.c:191:void	sdr_stage(Sdr sdrv, char *into, Object from, size_t length)
# cp ../ion-open-source-4.1.1/ici/include/sdrmgt.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrmgt.c src

# ../ion-open-source-4.1.1/ici/include/zco.h:215:extern double	zco_get_file_occupancy(Sdr sdr,
# ../ion-open-source-4.1.1/ici/library/zco.c:296:double	zco_get_file_occupancy(Sdr sdr, ZcoAcct acct)
# cp ../ion-open-source-4.1.1/ici/include/zco.h inc
# cp ../ion-open-source-4.1.1/ici/library/zco.c src

# ../ion-open-source-4.1.1/ici/bulk/STUB_BULK/bulk.c:111:void	bulk_destroy(unsigned long item)
# ../ion-open-source-4.1.1/ici/include/bulk.h:19:extern void		bulk_destroy(unsigned long item);
# cp ../ion-open-source-4.1.1/ici/bulk/STUB_BULK/bulk.c src
# cp ../ion-open-source-4.1.1/ici/include/bulk.h inc

# ../ion-open-source-4.1.1/ici/include/smrbt.h:89:extern PsmAddress	sm_rbt_first(PsmPartition partition, PsmAddress rbt);
# ../ion-open-source-4.1.1/ici/library/smrbt.c:873:PsmAddress	sm_rbt_first(PsmPartition partition, PsmAddress rbt)
# cp ../ion-open-source-4.1.1/ici/include/smrbt.h inc
# cp ../ion-open-source-4.1.1/ici/library/smrbt.c src

# ../ion-open-source-4.1.1/ici/include/psm.h:90:extern void		*psp(PsmPartition, PsmAddress);
# ../ion-open-source-4.1.1/ici/library/psm.c:379:void    *psp(PsmPartition partition, PsmAddress address)
# cp ../ion-open-source-4.1.1/ici/include/psm.h inc
# cp ../ion-open-source-4.1.1/ici/library/psm.c src

# ../ion-open-source-4.1.1/ici/include/sdrstring.h:57:extern int		sdr_string_read(Sdr sdr, char *into, Object string);
# ../ion-open-source-4.1.1/ici/sdr/sdrstring.c:117:int	sdr_string_read(Sdr sdrv, char *into, Object string)
# cp ../ion-open-source-4.1.1/ici/include/sdrstring.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrstring.c src

# ../ion-open-source-4.1.1/ici/library/platform_sm.c:3393:int	pseudoshell(char *commandLine)
# ../ion-open-source-4.1.1/ici/include/platform_sm.h:121:extern int		pseudoshell(char *commandLine);
# cp ../ion-open-source-4.1.1/ici/library/platform_sm.c src
# cp ../ion-open-source-4.1.1/ici/include/platform_sm.h inc

# ../ion-open-source-4.1.1/ici/include/memmgr.h:52:MemAllocator	memmgr_take(	int mgrId);
# ../ion-open-source-4.1.1/ici/library/memmgr.c:243:MemAllocator	memmgr_take(int mgrId)
# cp ../ion-open-source-4.1.1/ici/include/memmgr.h inc
# cp ../ion-open-source-4.1.1/ici/library/memmgr.c src

# ../ion-open-source-4.1.1/ici/include/smlist.h:38:extern PsmAddress	Sm_list_create(const char *file, int line,
# ../ion-open-source-4.1.1/ici/library/smlist.c:84:PsmAddress	Sm_list_create(const char *fileName, int lineNbr,
# cp ../ion-open-source-4.1.1/ici/include/smlist.h int
# cp ../ion-open-source-4.1.1/ici/library/smlist.c src

# ../ion-open-source-4.1.1/ici/include/sdr.h:44:extern Object		sdr_find(Sdr sdr, char *name, int *type);
# ../ion-open-source-4.1.1/ici/sdr/sdrcatlg.c:151:Object	sdr_find(Sdr sdrv, char *name, int *type)
# cp ../ion-open-source-4.1.1/ici/include/sdr.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrcatlg.c src

# ../ion-open-source-4.1.1/ici/include/sdrlist.h:40:extern Object		Sdr_list_create(const char *file, int line,
# ../ion-open-source-4.1.1/ici/sdr/sdrlist.c:61:Object	Sdr_list_create(const char *file, int line, Sdr sdrv)
# cp ../ion-open-source-4.1.1/ici/include/sdrlist.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrlist.c src

# ../ion-open-source-4.1.1/ici/include/rfx.h:35:extern void	rfx_erase_data(PsmPartition partition, PsmAddress nodeData,
# ../ion-open-source-4.1.1/ici/library/rfx.c:236:void	rfx_erase_data(PsmPartition partition, PsmAddress nodeData,
# cp ../ion-open-source-4.1.1/ici/include/rfx.h inc
# cp ../ion-open-source-4.1.1/ici/library/rfx.c src

# ../ion-open-source-4.1.1/ici/include/sptrace.h:95:extern void		sptrace_log_memo(PsmPartition trace, uaddr addr,
# ../ion-open-source-4.1.1/ici/library/sptrace.c:333:void	sptrace_log_memo(PsmPartition trace, uaddr addr, char *text,
# cp ../ion-open-source-4.1.1/ici/include/sptrace.h inc
# cp ../ion-open-source-4.1.1/ici/library/sptrace.c src






