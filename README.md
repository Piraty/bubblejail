# Bubblejail

Run commands in linux containers (a.k.a. sandbox).

Bubblejail is a wrapper around [bubblewrap](https://github.com/containers/bubblewrap/).
It extends on on bubblewrap's
[bubblewrap-shell example](https://github.com/containers/bubblewrap/blob/b8e6e1159e63045679ae57b8b379b39eae7798a6/demos/bubblewrap-shell.sh)
and aims to provide a more convenient interface to bubblewrap's rather raw
cli-options by offering high-level feature flags to ease common tasks necessary
to spawn sandboxed applications (like mounting relevant paths to give the
application access to your x-server).

It uses an opt-in design and works by starting out with a restrictive configuration
that requires expansion on a per-application base; this is in contrast to
similar projects which use the opposite approach (see firejail).

## Usage

```
bubblejail [OPTIONS] [BWRAP_OPTIONS] COMMAND [ARGS] - run command in linux container

DESCRIPTION
  Run COMMAND [ARGS] in a sandbox by using the bubblewrap container setup
  utility (see: https://github.com/containers/bubblewrap/).

  The sandbox is configured to be most restrictive by default but allows for
  easy expansion on a per-application base.

  BWRAP_OPTIONS it will be appended to the actual bwrap call and have to be
  provided as a single string each.
	  Example: bubblejail --network "--hostname mysandbox" bash

OPTIONS
  --help               Show this help
  --debug              Show bwrap command line

  --network            Add network features (dns,netns,nss)
  --x11                Make X11 work

  --need-dev           Mount new devtmpfs
  --need-dns           Share resolvers with container
  --need-netns         Retain the network namespace
  --need-nss
  --need-proc          Mount procfs
  --need-env-vars      see BUBBLEJAIL_ENV_WHITELIST below
  --ro <path>          bind <path> in the container (read-only)
  --rw <path>          bind <path> in the container

ENV
  bubblejail respects the following environment variables

  BUBBLEJAIL_ENV_WHITELIST    white-space separated list of variable names which
                              are passed to the container
```

## Examples

sandbox an untrusted binary
```
bubblejail ./ctf
```

sandbox graphical applications
```
bubblejail --x11 xeyes

bubblejail --x11 --network --need-proc --need-dev --need-env-vars "HOME" firefox
```

## Application Wrappers

_THIS IS WORK-IN-PROGRESS_
_please send patches_

Wrappers for applications with a minimal-working config are provided in the
`./wrappers` directory. They allow for easy customizations through environment
variables.

Here is an example:

```
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
```
