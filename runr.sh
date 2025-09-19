#!/bin/bash
#made by github.com/bipknit

debug=0
measure_time=0
ver=2.0
ext=""
file=""
files=()
dbuginfo="the program ended running"

declare -A runmap=(
  [py]="python3"
  [c]="gcc"
  [cpp]="g++"
  [java]="javac"
  [d]="dmd"
  [go]="go run"
  [js]="node"
  [ts]="ts-node"
  [rb]="ruby"
  [rs]="rustc"
  [kt]="kotlinc"
  [swift]="swift"
  [php]="php"
  [sh]="bash"
  [pl]="perl"
  [lua]="lua"
)


show_help() {
    cat << EOF
Usage: r [options] [file]

Options:
  -d       Enable debug mode
  -t       Measure runtime of the program
  -v       Shows the version number of the program
  -h       Show this help message

Examples:
  r main.c          # run main.c
  r -d main.c       # run with debug output
  r -t main.c       # run and measure execution time
  r -d -t main.c    # debug + measure time
  r                 # auto-select a single source file in the current directory
EOF
}


show_version() {
    echo "Version: ${ver}"
}


fexists() {
    case "$1" in
        class|out) return ;;  #  runmap excl.
    esac

    if [ -z "$1" ] || [ -z "${runmap[$1]+_}" ]; then
        echo "Unknown or missing file extension: $1"
        exit 1
    fi
}


auto_select_file() {
    #if file is already set skip
    if [[ -n "$file" ]]; then
        return
    fi

    shopt -s nullglob
    local candidates=()

    for ext in "${!runmap[@]}"; do
        local files=( *."$ext" )
        if [[ ${#files[@]} -eq 1 ]]; then
            candidates+=("${files[0]}")
        elif [[ ${#files[@]} -gt 1 ]]; then
            echo "Multiple .$ext files found. Please specify which one to run."
            exit 1
        fi
    done

    if [[ ${#candidates[@]} -eq 1 ]]; then
        file="${candidates[0]}"
        echo "Auto-selecting $file"
    else
        echo "No unique file found to run"
        exit 1
    fi
}


for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
        # loop over each character after the dash
        for (( i=1; i<${#arg}; i++ )); do
            flag="${arg:i:1}"
            case "$flag" in
                d|--debug) debug=1 ;;
                t|--measureTime) measure_time=1 ;;
                h|--help) show_help; exit 0 ;;
                v|--version) show_version; exit 0;;
                *) echo "Unknown option: -$flag"; exit 1 ;;
            esac
        done
    else
        # first non-flag is the file
        if [[ -z "$file" ]]; then
            file="$arg"
        fi
    fi
done

# auto select if passed no file
auto_select_file

# determine extension
ext="${file##*.}"

fexists "$ext"
cmd="${runmap[$ext]} $file"


if [[ "$debug" -eq 1 ]]; then
    echo "debug header start"
    echo "debug=$debug"
    echo "file=$file"
    echo "extension=$ext"
    echo "default command=$cmd"
    echo "measuring time=$measure_time"
    echo "debug header ended"
fi


#case logic
case "$ext" in
    c|cpp)
        if [[ -x a.out && a.out -nt "$file" ]]; then
            ((measure_time)) && time ./a.out || ./a.out
        else
            gcc "$file" -o a.out
            ((measure_time)) && time ./a.out || ./a.out
        fi
    ;;
    d)
        bin="${file%.d}"
        if [[ -x "$bin" && "$bin" -nt "$file" ]]; then
            ((measure_time)) && time ./"$bin" || ./"$bin"
        else
            dmd "$file"
            ((measure_time)) && time ./"$bin" || ./"$bin"
        fi
    ;;
    java)
        classname="${file%.java}"
        if [[ -f "$classname.class" && "$classname.class" -nt "$file" ]]; then
            ((measure_time)) && time java "$classname" || java "$classname"
        else
            javac "$file"
            ((measure_time)) && time java "$classname" || java "$classname"
        fi
    ;;
    class) # <-- FIXUP1
        java "${file%.class}"
    ;;
    out)   # <-- FIXUP1
        "./$file"
    ;;
    *)
        ((measure_time)) && time eval "$cmd" || eval "$cmd"
    ;;
esac

if [[ "$debug" -eq 1 ]]; then
    echo "$dbuginfo"
fi
