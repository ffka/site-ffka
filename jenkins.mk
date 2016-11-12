

# 'make -f jenkins.mk gluonbranch' returns the gluon branch the site.mk requires.
# $> make -f jenkins.mk gluonbranch
# v2016.1.4
# 

all:
	@echo "Available make-targets:"
	@echo "gluonbranch: show the gluon branch site.mk requires"
	@echo "targets: show enabled gluon targets aka SOC models to build freifunk firmware for."
	@echo "         this requires the site-repo (usually named 'site') is located in the gluon source dir."



ifeq ($(MAKECMDGOALS),gluonbranch)

include site.mk

gluonbranch:
	@echo $(GLUON_CHECKOUT)
endif





ifeq ($(MAKECMDGOALS),targets)
# supporting two directory layouts for gluon- and site-repo
# 1. site-repo is directly cloned inside gluon dir
# 2. site-repo is cloned parallel to gluon dir (both share the same parent), a symbolic link gluon/site points to site-repo.

ifneq ("$(wildcard ${CURDIR}/../include/gluon.mk)","")
GLUONDIR:=${CURDIR}/..
endif

ifneq ("$(wildcard ${CURDIR}/../gluon/include/gluon.mk)","")
GLUONDIR:=${CURDIR}/../gluon
endif

include $(GLUONDIR)/include/gluon.mk
include $(GLUONDIR)/targets/targets.mk

targets:
	@echo '$(GLUON_TARGETS)'
endif
