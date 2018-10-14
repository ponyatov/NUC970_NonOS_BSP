toolchain:
	$(MAKE) -f nuc976.mk dirs binutils libs0 gcc0 gdb

doxy: ./doxy_mk
	./doxy_mk nuc976.mk

./doxy_%: doxy_%.lex Makefile
	flex -o $@.c $< && cc -o $@ $@.c && chmod +x $@

