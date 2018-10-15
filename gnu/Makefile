NUC = -f nuc976.mk

toolchain:
	$(MAKE) $(NUC) dirs libs0 binutils gcc0 gdb

clean:
	$(MAKE) $(NUC) clean

distclean:
	$(MAKE) $(NUC) distclean


doxy: ./doxy_mk
	./doxy_mk nuc976.mk

./doxy_%: doxy_%.lex Makefile
	flex -o $@.c $< && cc -o $@ $@.c && chmod +x $@

