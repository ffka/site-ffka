
all:
	@echo "Available make-targets:"
	@echo "gluonbranch:                        show the gluon branch site.mk requires"
	@echo "                                    ex: \$> make -f jenkins.mk gluonbranch"
	@echo "                                    # v2016.1.4"
	@echo "targets:                            show enabled gluon targets aka SOC models to build freifunk firmware for."
	@echo "                                    This requires the current working directory being the gluon source tree."
	@echo "                                    ex: \$> cd <gluon-src-tree>; make -f <path to site-conf>/jenkins.mk targets"
	@echo "tag <stable|beta|experiemntal>:     returns the latest tag for the given release line. To get the correct branches,"
	@echo "                                    the current working dir must be the dir the jenkins.mk file is i.n"
	@echo "                                    ex: \$> make -f jenkins.mk tag stable"
	@echo "                                    # v0.2.90-stable.1"

# gluonbranch
ifeq ($(MAKECMDGOALS),gluonbranch)

include site.mk

.PHONY: gluonbranch
gluonbranch:
	@echo $(GLUON_CHECKOUT)
endif

# targets
ifeq ($(MAKECMDGOALS),targets)

GLUONDIR:=${CURDIR}
include $(GLUONDIR)/include/gluon.mk
include $(GLUONDIR)/targets/targets.mk

.PHONY: targets
targets:
	@echo $(GLUON_TARGETS)
endif


# tag
ifeq (tag,$(firstword $(MAKECMDGOALS)))

TAG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(TAG_ARGS):;@:)

.PHONY: tag
tag:
	@git tag | grep -i -- '-$(TAG_ARGS)' | sort -rn | head -n 1
endif
