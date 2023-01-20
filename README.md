# Bubblejail

Run commands in linux containers (a.k.a. sandbox).

Bubblejail is a wrapper around [bubblewrap](https://github.com/containers/bubblewrap/).
It extends on bubblewrap's
[bubblewrap-shell example](https://github.com/containers/bubblewrap/blob/b8e6e1159e63045679ae57b8b379b39eae7798a6/demos/bubblewrap-shell.sh)
and aims to provide a more convenient interface to bubblewrap's rather raw
cli-options by offering high-level feature flags to ease common tasks necessary
to spawn sandboxed applications (like mounting relevant paths to give the
application access to your display server).

It uses an opt-in design and works by starting out with a restrictive configuration
that requires expansion on a per-application base; this is in contrast to
similar projects which use the opposite approach (see firejail).

## Usage

```
bubblejail [OPTIONS] [BWRAP_OPTIONS] COMMAND [ARGS] - run command in container

DESCRIPTION
	Run COMMAND [ARGS] in a sandbox by using the bubblewrap container setup
	utility (see: https://github.com/containers/bubblewrap/).

	The sandbox is configured to be most restrictive by default but allows for
	easy expansion on a per-application base.

	OPTIONS provide an easy way opt-in to common use-cases. They may optionally
	be followed by BWRAP_OPTIONS which will be appended as raw option to the
	actual bwrap call. Note that OPTIONS may not come after BWRAP_OPTIONS.

OPTIONS
  General options:

	--help
		Show this help

	--debug
		Show bwrap command line

  High-level options:

	--network
		Add network features. Currently equivalent with: --need-dns --need-nss
		--share-net

	--pulseaudio
		Make pulseaudio work

	--tor
		Torify the container (requires torsocks)

	--wayland
		Make Wayland work

	--x11
		Make X11 work

  Low-level options:

	--need-devfs         Mount new devtmpfs
	--need-procfs        Mount procfs

	--need-dns           Share /etc/resolv.conf with container
	--need-nss

	--ro <path>          bind <path> in the container (read-only)
	--rw <path>          bind <path> in the container

	--need-env-vars      see BUBBLEJAIL_ENV_WHITELIST below

	--share-all          Instead of creating all available namespaces, only
	                     create the mount namespace
	--share-ipc          Share the ipc namespace
	--share-net          Share the network namespace


ENVIRONMENT
  bubblejail respects the following environment variables

	BUBBLEJAIL_ENV_WHITELIST
		white-space separated list of variable names which are passed to the
		container

EXAMPLES
	bubblejail --x11 --uid 2222 sh -c 'id -u && xeyes'
	bubblejail --network --ro-bind $HOME/src /src ls /src
```

## Examples

sandbox an untrusted binary

	bubblejail ./ctf

sandbox graphical applications

	bubblejail --x11 xeyes
	bubblejail --x11 --network --need-proc --need-dev --need-env-vars "HOME" firefox

## Application Wrappers

_THIS IS WORK-IN-PROGRESS_

_please send patches_

Wrappers for applications with a minimal-working config are provided in the
[./wrappers](./wrappers) directory. They allow for easy customizations through environment
variables.

Here is an example:

	$ cat $HOME/.bubblejail
	#/bin/sh
	#bubblejail config - source this by the shell calling the bubblejail wrappers

	# global: honor locale and qt theme
	BUBBLEJAIL_ENV_WHITELIST="LANG LC_TIME QT_STYLE_OVERRIDE=gtk2"
	export BUBBLEJAIL_ENV_WHITELIST


	# firefox

	# honor gtk theme
	BUBBLEJAIL_WRAPPER_FIREFOX_EXTRA_ARGS="--ro $HOME/.config/gtk-3.0/settings.ini"
	# use personal profile
	BUBBLEJAIL_WRAPPER_FIREFOX_PROFILE_DIR="$HOME/.mozilla/firefox/deadbeef.default-133713371337"

	export BUBBLEJAIL_WRAPPER_FIREFOX_EXTRA_ARGS
	export BUBBLEJAIL_WRAPPER_FIREFOX_PROFILE_DIR

## Similar Projects

* [igo95862/bubblejail](https://github.com/igo95862/bubblejail)
