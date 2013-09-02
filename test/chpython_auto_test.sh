. ./share/chpython/auto.sh
. ./test/helper.sh

function setUp()
{
	chpython_reset
	unset PYTHON_AUTO_VERSION
}

function test_chpython_auto_loaded_in_zsh()
{
	[[ -n "$ZSH_VERSION" ]] || return

	assertEquals "did not add chpython_auto to preexec_functions" \
		     "chpython_auto" \
		     "$preexec_functions"
}

function test_chpython_auto_loaded_in_bash()
{
	[[ -n "$BASH_VERSION" ]] || return

	local command=". $PWD/share/chpython/auto.sh && trap -p DEBUG"
	local output="$("$SHELL" -c "$command")"

	assertTrue "did not add a trap hook for chpython_auto" \
		   '[[ "$output" == *chpython_auto* ]]'
}

function test_chpython_auto_loaded_twice_in_zsh()
{
	[[ -n "$ZSH_VERSION" ]] || return

	. ./share/chpython/auto.sh

	assertNotEquals "should not add chpython_auto twice" \
		        "$preexec_functions" \
			"chpython_auto chpython_auto"
}

function test_chpython_auto_loaded_twice()
{
	PYTHON_AUTO_VERSION="dirty"
	PROMPT_COMMAND="chpython_auto"

	. ./share/chpython/auto.sh

	assertNull "PYTHON_AUTO_VERSION was not unset" "$PYTHON_AUTO_VERSION"
}

function test_chpython_auto_enter_project_dir()
{
	cd "$test_project_dir" && chpython_auto

	assertEquals "did not switch Ruby when entering a versioned directory" \
		     "$test_python_root" "$PYTHON_ROOT"
}

function test_chpython_auto_enter_subdir_directly()
{
	cd "$test_project_dir/sub_dir" && chpython_auto

	assertEquals "did not switch Ruby when directly entering a sub-directory of a versioned directory" \
		     "$test_python_root" "$PYTHON_ROOT"
}

function test_chpython_auto_enter_subdir()
{
	cd "$test_project_dir" && chpython_auto
	cd sub_dir             && chpython_auto

	assertEquals "did not keep the current Ruby when entering a sub-dir" \
		     "$test_python_root" "$PYTHON_ROOT"
}

function test_chpython_auto_enter_subdir_with_python_version()
{
	cd "$test_project_dir"    && chpython_auto
	cd sub_versioned/         && chpython_auto

	assertNull "did not switch the Ruby when leaving a sub-versioned directory" \
		   "$PYTHON_ROOT"
}

function test_chpython_auto_modified_python_version()
{
	cd "$test_project_dir/modified_version" && chpython_auto
	echo "1.9.3" > .python-version            && chpython_auto

	assertEquals "did not detect the modified .python-version file" \
		     "$test_python_root" "$PYTHON_ROOT"
}

function test_chpython_auto_overriding_python_version()
{
	cd "$test_project_dir" && chpython_auto
	chpython system          && chpython_auto

	assertNull "did not override the Ruby set in .python-version" "$PYTHON_ROOT"
}

function test_chpython_auto_leave_project_dir()
{
	cd "$test_project_dir"    && chpython_auto
	cd "$test_project_dir/.." && chpython_auto

	assertNull "did not reset the Ruby when leaving a versioned directory" \
		   "$PYTHON_ROOT"
}

function test_chpython_auto_invalid_python_version()
{
	local expected_auto_version="$(cat $test_project_dir/bad/.python-version)"

	cd "$test_project_dir" && chpython_auto
	cd bad/                && chpython_auto 2>/dev/null

	assertEquals "did not keep the current Ruby when loading an unknown version" \
		     "$test_python_root" "$PYTHON_ROOT"
	assertEquals "did not set PYTHON_AUTO_VERSION" \
		     "$expected_auto_version" "$PYTHON_AUTO_VERSION"
}

function tearDown()
{
	cd "$PWD"
}

SHUNIT_PARENT=$0 . $SHUNIT2
