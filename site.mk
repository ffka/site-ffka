GLUON_SITE_PACKAGES := \
	gluon-mesh-batman-adv-15 \
	gluon-respondd \
	gluon-alfred \
	gluon-autoupdater \
	gluon-config-mode-core \
	gluon-config-mode-autoupdater \
	gluon-config-mode-contact-info \
	gluon-config-mode-geo-location \
	gluon-config-mode-hostname \
	gluon-config-mode-mesh-vpn \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-luci-admin \
	gluon-luci-autoupdater \
	gluon-luci-portconfig \
	gluon-luci-wifi-config \
	gluon-luci-private-wifi \
	gluon-next-node \
	gluon-mesh-vpn-fastd \
	gluon-setup-mode \
	gluon-status-page \
	haveged \
	iptables \
	iwinfo

DEFAULT_GLUON_CHECKOUT := v2016.2.1

# Allow overriding the checkout from the command line
GLUON_CHECKOUT ?= $(DEFAULT_GLUON_CHECKOUT)

# add addition network drivers and usb stuff only to targes where disk space does not matter.
ifeq ($(GLUON_TARGET),x86-generic)
GLUON_SITE_PACKAGES += \
        kmod-usb-core \
        kmod-usb2 \
        kmod-usb-hid \
        kmod-usb-net \
        kmod-usb-net-asix \
        kmod-usb-net-dm9601-ether \
        kmod-sky2 \
        kmod-r8169 \
        kmod-forcedeth \
        kmod-8139too \
	kmod-atl2
endif

ifeq ($(GLUON_TARGET),x86-64)
GLUON_SITE_PACKAGES += \
        kmod-usb-core \
        kmod-usb2 \
        kmod-usb-hid \
        kmod-usb-net \
        kmod-usb-net-asix \
        kmod-usb-net-dm9601-ether \
        kmod-sky2 \
        kmod-r8169 \
        kmod-forcedeth \
        kmod-8139too \
	kmod-atl2
endif

DEFAULT_GLUON_RELEASE := 0.2.99~beta$(shell date '+%Y%m%d')

#Saved for future use
# $(shell git --git-dir=$(this_dir)/.git \
#		--work-tree=$(this_dir) describe --tags --always --dirty \
#		--match "v*" \
#		| sed -e 's/^\(v[^-]\+\)-\([0-9]\+-g[0-9a-f]\{7\}.*\)$$/\1+\2/' \
#		| sed -e 's/^\(v[^-]\+\)-\(beta.*\)$$/\1~\2/' \
#		| sed -e 's/^\(v[^~]\+~beta[^-]\+\)-\([0-9]\+-g[0-9a-f]\{7\}.*\)$$/\1+\2/' \
#		| sed -e 's/^v//')

##	DEFAULT_GLUON_RELEASE
#		version string to use for images
#		gluon relies on
#			opkg compare-versions "$1" '>>' "$2"
#		to decide if a version is newer or not.

# replace magic in version number as follows:
# v0.31-4-gf390c9d				--> 0.31+4-gf390c9d
# v0.32-beta.1 					--> 0.32~beta.1
# v0.30-beta.1-2-g11c8a08-dirty	--> 0.30~beta.1+2-g11c8a08-dirty
# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 0

# Languages to include
GLUON_LANGS ?= en de

GLUON_REGION ?= eu

GLUON_ATH10K_MESH ?= 11s
