.PHONY: doxy
doxy:
	doxygen doxy.gen 1> /dev/null

.PHONY: gnu
gnu:
	cd gnu ; $(MAKE)

