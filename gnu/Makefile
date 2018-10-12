all:
	$(MAKE) -f nuc976.mk binutils

doxy: ./doxy_mk
	./doxy_mk nuc976.mk

./doxy_%: doxy_%.lex Makefile
	flex -o $@.c $< && cc -o $@ $@.c && chmod +x $@

