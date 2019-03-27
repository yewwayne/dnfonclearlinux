#!/bin/bash -e
# Query installed bundles and produce an equivalent list of packages

function clr_bundles_git {
	if [[ -e clr-bundles ]]; then (cd clr-bundles; git fetch; git checkout --force $1)
	else
		git clone https://github.com/clearlinux/clr-bundles.git
		git -C clr-bundles checkout $1
	fi
}

function bundles_to_packages {
	clr_bundles_git $1
	while read bundle; do
		if [[ -f clr-bundles/bundles/$bundle ]]; then
			sed '/^#/d; /^include(/d; /^$/d' clr-bundles/bundles/$bundle
		else
			# This is a pundle
			echo $bundle
		fi
	done
}

function remove_deps {
	# Filter out packages which are dependencies of other packages in the same list
	sort -u - > packages
	xargs dnf --releasever=$1 repoquery --requires --resolve --recursive --qf %{name} < packages | sort -u > deps
	comm -23 packages deps
}

function get_cache_dir {
	tmpdir=/var/tmp/
	prefix=dnfonclearlinux-$USER
	for dir in $tmpdir/$prefix-*; do
		if test -d $dir -a -O $dir -a -w $dir; then
			echo $dir
			return
		fi
	done
	mktemp -d -p $tmpdir $prefix-XXXXXXXX
}

VERSION=$(</usr/share/clear/version)
CACHE_DIR=$(get_cache_dir)
cd $CACHE_DIR
ls /usr/share/clear/bundles | bundles_to_packages $VERSION | remove_deps $VERSION
