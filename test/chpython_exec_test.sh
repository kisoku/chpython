. ./test/helper.sh

function test_chpython_exec_no_arguments()
{
	chpython-exec 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chpython_exec_no_command()
{
	chpython-exec "$test_python_version" 2>/dev/null

	assertEquals "did not exit with 1" 1 $?
}

function test_chpython_exec()
{
	local command="python -e 'print RUBY_VERSION'"
	local python_version=$(chpython-exec "$test_python_version" -- $command)

	assertEquals "did change the python" "$test_python_version" "$ruby_version"
}

SHUNIT_PARENT=$0 . $SHUNIT2
