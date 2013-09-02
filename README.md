# chpython

Changes the current Python

This is a translation of [postmodern]'s [chruby] Ruby manager for use with Python.

## Features

* Updates `$PATH`.
* Optionally sets `$PYTHONOPT` if second argument is given.
* Calls `hash -r` to clear the command-lookup hash-table.
* Fuzzy matching of Pythons by name.
* Defaults to the system Python.
* Optionally supports auto-switching and the `.python-version` file.
* Supports [bash] and [zsh].
* Small (~90 LOC).
* Has tests.

## Anti-Features

* Does not hook `cd`.
* Does not install executable shims.
* Does not require Rubies be installed into your home directory.
* Does not automatically switch Rubies by default.
* Does not require write-access to the Python directory in order to install gems.

## Install

    wget -O chpython-0.0.1.tar.gz https://github.com/kisoku/chpython/archive/v0.0.1.tar.gz
    tar -xzvf chpython-0.0.1.tar.gz
    cd chpython-0.0.1
    sudo make install

### Rubies

#### Manually

Chpython does not currently provids detailed instructions for installing additional Pythons:

However, as chpython is derived from Chpython you may refer to the Chpython documentation to
get an idea of what is required.

* [Python](https://github.com/postmodern/chpython/wiki/Ruby)
* [JPython](https://github.com/postmodern/chpython/wiki/JRuby)
* [Rubinius](https://github.com/postmodern/chpython/wiki/Rubinius)
* [MagLev](https://github.com/postmodern/chpython/wiki/MagLev)

#### python-install

You can also use [python-install] to install additional Pythons:

Installing to `/opt/pythons` or `~/.pythons`:

    python-install python 2.7.5
    python install python 3.3.2

## Configuration

Add the following to the `/etc/profile.d/chpython.sh`, `~/.bashrc` or
`~/.zshrc` file:

    source /usr/local/share/chpython/chpython.sh

By default chpython will search for Pythons installed into `/opt/pythons/` or
`~/.pythons/`. For non-standard installation locations, simply set the
`PYTHONS` variable:

    PYTHONS=(
      /opt/python-3.3.2
      $HOME/src/python-2.7.5
    )

### Migrating

If you are migrating from another Python manager, set `PYTHONS` accordingly:

* [pyenv]: `PYTHONS=(~/.pyenv/versions/*)`


### System Wide

If you wish to enable chpython system-wide, add the following to
`/etc/profile.d/chpython.sh`:

    [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || return

    source /usr/local/share/chpython/chpython.sh

### Auto-Switching

If you want chpython to auto-switch the current version of Python when you `cd`
between your different projects, simply load `auto.sh` in `~/.bashrc` or
`~/.zshrc`:

    source /usr/local/share/chpython/auto.sh

chpython will check the current and parent directories for a [.python-version]
file. Other Python switchers also understand this file


