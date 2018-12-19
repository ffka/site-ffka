include site.mk
.PHONY: echo
echo:
	$(info export COMMIT_DESCRIPTION="$(COMMIT_DESCRIPTION)")

	$(info export GLUON_CHECKOUT="$(GLUON_CHECKOUT)")
	$(info export GLUON_RELEASE="$(GLUON_RELEASE)")
	$(info export GLUON_BRANCH="$(GLUON_BRANCH)")
	$(info export GLUON_PRIORITY="$(GLUON_PRIORITY)")
