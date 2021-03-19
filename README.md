# Bubblejail

Bubblejail is a wrapper around [bubblewrap](https://github.com/containers/bubblewrap/)

Extending on bubblewrap's
[bubblewrap-shell example](https://github.com/containers/bubblewrap/blob/b8e6e1159e63045679ae57b8b379b39eae7798a6/demos/bubblewrap-shell.sh),
Bubblejail aims to provide a convenient interface to bubblewrap's rather raw
cli-options by offering high-level feature flags to ease common tasks necessary
to spawn containerized applications (like mounting relevant mountpoints to give
the application access to you x-server).

## Usage

```
bubblewrap [OPTIONS] [BWRAP_OPTIONS] COMMAND [ARGS] - run command in linux container

DESCRIPTION
  bubblejail executes commands in linux containers by using the bubblewrap container
  setup utility (see: https://github.com/containers/bubblewrap/).

  bubblejail provides a convenient interface to the rather basic and simple bwrap, to
  provide a way to ease common tasks like mounting relevant mountpoints for
  graphical applications.  It uses an opt-in design and works by starting with
  a minimal bubblewrap config that needs to be extended on-demand and on
  per-application use case, rather than the opposite way around (see firejail).

  bubblejail comes with a set of predefined wrappers for a few commonly used
  applications.

OPTIONS
  --help               Show this help
  --debug              Show bwrap command line

  --network            Add network features (nss,dns,netns)

  --need-dev           Mount new devtmpfs
  --need-dns           Share resolvers with container
  --need-netns         Retain the network namespace
  --need-nss
  --need-proc          Mount procfs
  --need-x             Make X work
  --need-env-vars      see BUBBLEJAIL_ENV_WHITELIST below

ENV
  bubblejail respects the following environment variables

  BUBBLEJAIL_ENV_WHITELIST    white-space separated list of variable names which
                              are passed to the container
```

## Application Wrappers

Wrappers for applications with a minimal-working config are privided in the
`./wrappers` directory, which are designed to allow for easy customizations
through environment variables.

Here is an example:

```
$ cat $HOME/.bubblejail
#/bin/sh
#bubblejail config - source this by the shell calling the bubblejail wrappers

BUBBLEJAIL_ENV_WHITELIST="LANG LC_TIME QT_STYLE_OVERRIDE=gtk2"
export BUBBLEJAIL_ENV_WHITELIST

# honor gtk theme
BUBBLEJAIL_WRAPPER_FIREFOX_EXTRA_ARGS=" --ro-bind $HOME/.config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini"
export BUBBLEJAIL_WRAPPER_FIREFOX_EXTRA_ARGS
```
