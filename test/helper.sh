[[ -z "$SHUNIT2"     ]] && SHUNIT2=/usr/share/shunit2/shunit2
[[ -n "$ZSH_VERSION" ]] && setopt shwordsplit

export PREFIX="$PWD/test"
export HOME="$PREFIX/home"
export PATH="$PWD/bin:$PATH"

. ./share/chpython/chpython.sh
chpython_reset

test_python_engine="python"
test_python_version="2.7.5"
test_python_root="$PWD/test/opt/rubies/$test_python_engine-$test_python_version"

test_path="$PATH"
test_project_dir="$PWD/test/project"

setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }
