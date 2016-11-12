

# 'make -f jenkins.mk gluonbranch' returns the gluon branch the site.mk requires.
# $> make -f jenkins.mk gluonbranch
# v2016.1.4
# 

all:
	@echo "Available make-targets:"
	@echo "gluonbranch:	show the gluon branch site.mk requires"
	@echo "			ex: \$>  make -f jenkins.mk gluonbranch"
	@echo "			v2016.1.4"
	@echo "targets:		show enabled gluon targets aka SOC models to build freifunk firmware for."
	@echo "			This requires the current working directory being the gluon source tree."
	@echo "			example: cd <gluon-src-tree>; make -f <path to site-conf>/jenkins.mk targets"


ifeq ($(MAKECMDGOALS),gluonbranch)

include site.mk

gluonbranch:
	@echo $(GLUON_CHECKOUT)
endif

ifeq ($(MAKECMDGOALS),targets)

FORCE: ;

GLUONDIR:=${CURDIR}
include $(GLUONDIR)/include/gluon.mk
include $(GLUONDIR)/targets/targets.mk

targets: FORCE
	@echo '$(GLUON_TARGETS)'
endif
