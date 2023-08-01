
all:
	$(GCC) $(CFLAG) \
	$(SRC)/ltpdeliv.c \
	$(SRC)/libltpP.c \
	$(SRC)/platform_sm.c \
	$(SRC)/ion.c \
	$(SRC)/platform.c \
	$(SRC)/sdrxn.c \
	$(SRC)/sdrlist.c \
	$(SRC)/sdrmgt.c \
	$(SRC)/zco.c \
	$(SRC)/psm.c \
	$(SRC)/smlist.c \
	$(SRC)/smrbt.c \
	$(SRC)/sdrstring.c \
	$(SRC)/sdrcatlg.c \
	$(SRC)/sdrhash.c \
	$(SRC)/ltpei.c \
	$(SRC)/lyst.c \
	$(SRC)/memmgr.c \
	$(SRC)/rfx.c \
	$(SRC)/sptrace.c \
	$(SRC)/bulk.c \
	$(SRC)/sdrtable.c \
	-I$(INC) \
	$(PLATFORM) \
	-o $(OUT_BIN)/ltpdeliv

# Only for windows
# cp ../ion-open-source-4.1.1/ltp/include/ltp.h inc

# grep -rn Sdr_table_create ../ion-open-source-4.1.1/ --exclude=*.js --exclude=*.cpp --exclude=*.supp --exclude=*.pod --exclude=*.css

# find ../ion-open-source-4.1.1/ -name ltpextensions.c

# cp ../ion-open-source-4.1.1/ltp/daemon/ltpdeliv.c src

# cp ../ion-open-source-4.1.1/ltp/library/ltpP.h inc

# cp ../ion-open-source-4.1.1/ltp/library/ltpei.h inc

# ../ion-open-source-4.1.1/ltp/library/libltpP.c:1144:LtpVdb	*getLtpVdb()
# ../ion-open-source-4.1.1/ltp/library/ltpP.h:717:extern LtpVdb		*getLtpVdb();
# cp ../ion-open-source-4.1.1/ltp/library/libltpP.c src
# cp ../ion-open-source-4.1.1/ltp/library/ltpP.h inc

# ../ion-open-source-4.1.1/ici/include/platform_sm.h:82:extern void		sm_SemEnd(sm_SemId semId);
# ../ion-open-source-4.1.1/ici/library/platform_sm.c:898:void	sm_SemEnd(sm_SemId i)
# cp ../ion-open-source-4.1.1/ici/include/platform_sm.h inc
# cp ../ion-open-source-4.1.1/ici/library/platform_sm.c src

# ../ion-open-source-4.1.1/ici/include/ion.h:491:extern void		ionPauseAttendant(ReqAttendant *attendant);
# ../ion-open-source-4.1.1/ici/library/ion.c:1984:void	ionPauseAttendant(ReqAttendant *attendant)
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

# ../ion-open-source-4.1.1/ici/include/sdrlist.h:91:extern Object		sdr_list_first(Sdr sdr, Object list);
# ../ion-open-source-4.1.1/ici/sdr/sdrlist.c:527:Object	sdr_list_first(Sdr sdrv, Object list)
# cp ../ion-open-source-4.1.1/ici/include/sdrlist.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrlist.c src

# ../ion-open-source-4.1.1/ici/include/sdrmgt.h:61:extern void		Sdr_free(const char *file, int line,
# ../ion-open-source-4.1.1/ici/sdr/sdrmgt.c:1026:void	Sdr_free(const char *file, int line, Sdr sdrv, Object object)
# cp ../ion-open-source-4.1.1/ici/include/sdrmgt.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrmgt.c src

# ../ion-open-source-4.1.1/ici/include/zco.h:321:extern Object	zco_create(	Sdr sdr,
# ../ion-open-source-4.1.1/ici/library/zco.c:640:Object	zco_create_file_ref(Sdr sdr, char *pathName, char *cleanupScript,
# cp ../ion-open-source-4.1.1/ici/include/zco.h inc
# cp ../ion-open-source-4.1.1/ici/library/zco.c src

# cp ../ion-open-source-4.1.1/ltp/library/ltpP.h inc

# cp ../ion-open-source-4.1.1/ici/sdr/sdrP.h inc

# cp ../ion-open-source-4.1.1/ici/include/bulk.h inc

# ../ion-open-source-4.1.1/ici/include/psm.h:125:extern PsmAddress	Psm_zalloc(const char *, int, PsmPartition, size_t);
# ../ion-open-source-4.1.1/ici/library/psm.c:1133:PsmAddress	Psm_zalloc(const char *file, int line, PsmPartition partition,
# cp ../ion-open-source-4.1.1/ici/include/psm.h inc
# cp ../ion-open-source-4.1.1/ici/library/psm.c src

# ../ion-open-source-4.1.1/ici/include/smlist.h:72:extern PsmAddress	Sm_list_insert_last(const char *file, int line,
# ../ion-open-source-4.1.1/ici/library/smlist.c:307:PsmAddress	Sm_list_insert_last(const char *fileName, int lineNbr,
# cp ../ion-open-source-4.1.1/ici/include/smlist.h inc
# cp ../ion-open-source-4.1.1/ici/library/smlist.c src

# ../ion-open-source-4.1.1/ici/include/smrbt.h:47:extern PsmAddress	Sm_rbt_create(const char *file, int line,
# ../ion-open-source-4.1.1/ici/library/smrbt.c:93:PsmAddress	Sm_rbt_create(const char *file, int line,
# cp ../ion-open-source-4.1.1/ici/include/smrbt.h inc
# cp ../ion-open-source-4.1.1/ici/library/smrbt.c src

# ../ion-open-source-4.1.1/ici/include/sdrstring.h:57:extern int		sdr_string_read(Sdr sdr, char *into, Object string);
# ../ion-open-source-4.1.1/ici/sdr/sdrstring.c:117:int	sdr_string_read(Sdr sdrv, char *into, Object string)
# cp ../ion-open-source-4.1.1/ici/include/sdrstring.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrstring.c src

# ../ion-open-source-4.1.1/ici/include/sdr.h:44:extern Object		sdr_find(Sdr sdr, char *name, int *type);
# ../ion-open-source-4.1.1/ici/sdr/sdrcatlg.c:151:Object	sdr_find(Sdr sdrv, char *name, int *type)
# cp ../ion-open-source-4.1.1/ici/include/sdr.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrcatlg.c src

# ../ion-open-source-4.1.1/ici/include/sdrhash.h:45:extern Object		Sdr_hash_create(const char *file, int line, Sdr sdr,
# ../ion-open-source-4.1.1/ici/sdr/sdrhash.c:26:Object	Sdr_hash_create(const char *file, int line, Sdr sdrv, int keyLength,
# cp ../ion-open-source-4.1.1/ici/include/sdrhash.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrhash.c src

# ../ion-open-source-4.1.1/ltp/library/ltpei.c:223:void	ltpei_destroy_extension(Sdr sdr, Object elt, void *arg)
# ../ion-open-source-4.1.1/ltp/library/ltpei.h:185:extern void	ltpei_destroy_extension(Sdr, Object, void *);
# cp ../ion-open-source-4.1.1/ltp/library/ltpei.c src
# cp ../ion-open-source-4.1.1/ltp/library/ltpei.h inc

# cp ../ion-open-source-4.1.1/ltp/library/ext/ltpextensions.c inc

# ../ion-open-source-4.1.1/ici/include/lyst.h:77:LystElt lyst_next(LystElt);
# ../ion-open-source-4.1.1/ici/library/lyst.c:429:lyst_next(LystElt elt)
# cp ../ion-open-source-4.1.1/ici/include/lyst.h inc
# cp ../ion-open-source-4.1.1/ici/library/lyst.c src

# cp ../ion-open-source-4.1.1/ici/library/lystP.h inc

# ../ion-open-source-4.1.1/ici/include/memmgr.h:77:void		memmgr_destroy(uaddr smId, PsmPartition *partition);
# ../ion-open-source-4.1.1/ici/library/memmgr.c:351:void	memmgr_destroy(uaddr smId, PsmPartition *partition)
# cp ../ion-open-source-4.1.1/ici/include/memmgr.h inc
# cp ../ion-open-source-4.1.1/ici/library/memmgr.c src

# ../ion-open-source-4.1.1/ici/include/rfx.h:35:extern void	rfx_erase_data(PsmPartition partition, PsmAddress nodeData,
# ../ion-open-source-4.1.1/ici/library/rfx.c:236:void	rfx_erase_data(PsmPartition partition, PsmAddress nodeData,
# cp ../ion-open-source-4.1.1/ici/include/rfx.h inc
# cp ../ion-open-source-4.1.1/ici/library/rfx.c src

# ../ion-open-source-4.1.1/ici/include/sptrace.h:95:extern void		sptrace_log_memo(PsmPartition trace, uaddr addr,
# ../ion-open-source-4.1.1/ici/library/sptrace.c:333:void	sptrace_log_memo(PsmPartition trace, uaddr addr, char *text,
# cp ../ion-open-source-4.1.1/ici/include/sptrace.h inc
# cp ../ion-open-source-4.1.1/ici/library/sptrace.c src

# ../ion-open-source-4.1.1/ici/bulk/STUB_BULK/bulk.c:111:void	bulk_destroy(unsigned long item)
# ../ion-open-source-4.1.1/ici/include/bulk.h:19:extern void		bulk_destroy(unsigned long item);
# cp ../ion-open-source-4.1.1/ici/bulk/STUB_BULK/bulk.c src
# cp ../ion-open-source-4.1.1/ici/include/bulk.h inc

# ../ion-open-source-4.1.1/ici/include/sdrtable.h:30:extern Object		Sdr_table_create(const char *file, int line,
# ../ion-open-source-4.1.1/ici/sdr/sdrtable.c:37:Object	Sdr_table_create(const char *file, int line, Sdr sdrv, int rowSize,
# cp ../ion-open-source-4.1.1/ici/include/sdrtable.h inc
# cp ../ion-open-source-4.1.1/ici/sdr/sdrtable.c src








