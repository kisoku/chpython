CHPYTHON_VERSION="0.0.1"

PYTHONS=()
for dir in "$PREFIX/opt/pythons" "$HOME/.pythons"; do
	[[ -d "$dir" && -n "$(ls -A "$dir")" ]] && PYTHONS+=("$dir"/*)
done

function chpython_reset()
{
	[[ -z "$PYTHON_ROOT" ]] && return

	PATH=":$PATH:"; PATH="${PATH//:$PYTHON_ROOT\/bin:/:}"

	if (( $UID != 0 )); then
		[[ -n "$EGG_HOME" ]] && PATH="${PATH//:$EGG_HOME\/bin:/:}"
		[[ -n "$EGG_ROOT" ]] && PATH="${PATH//:$EGG_ROOT\/bin:/:}"

		EGG_PATH=":$EGG_PATH:"
		EGG_PATH="${EGG_PATH//:$EGG_HOME:/:}"
		EGG_PATH="${EGG_PATH//:$EGG_ROOT:/:}"
		EGG_PATH="${EGG_PATH#:}"; EGG_PATH="${EGG_PATH%:}"
		[[ -z "$EGG_PATH" ]] && unset EGG_PATH
		unset EGG_ROOT EGG_HOME
	fi

	PATH="${PATH#:}"; PATH="${PATH%:}"
	unset PYTHON_ROOT PYTHON_ENGINE PYTHON_VERSION PYTHONOPT
	hash -r
}

function chpython_use()
{
	if [[ ! -x "$1/bin/python" ]]; then
		echo "chpython: $1/bin/python not executable" >&2
		return 1
	fi

	[[ -n "$PYTHON_ROOT" ]] && chpython_reset

	export PYTHON_ROOT="$1"
	export PYTHONOPT="$2"
	export PATH="$PYTHON_ROOT/bin:$PATH"
}

function chpython()
{
	case "$1" in
		-h|--help)
			echo "usage: chpython [PYTHON|VERSION|system] [PYTHON_OPTS]"
			;;
		-V|--version)
			echo "chpython: $CHPYTHON_VERSION"
			;;
		"")
			local star

			for dir in "${PYTHONS[@]}"; do
				if [[ "$dir" == "$PYTHON_ROOT" ]]; then star="*"
				else                                  star=" "
				fi

				echo " $star ${dir##*/}"
			done
			;;
		system) chpython_reset ;;
		*)
			local match

			for dir in "${PYTHONS[@]}"; do
				[[ "${dir##*/}" == *"$1"* ]] && match="$dir"
			done

			if [[ -z "$match" ]]; then
				echo "chpython: unknown Python: $1" >&2
				return 1
			fi

			shift
			chpython_use "$match" "$*"
			;;
	esac
}
