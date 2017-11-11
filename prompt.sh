
# function _update_ps1() {
# 	# Will break if there is a space in the path to powerline shell
# 	PS1="$(${HOME}/powerline-shell.py $? 2> /dev/null)"
# }

# if [ "$TERM" != "linux" ]; then
#     PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# fi

###
# Color Helper functions
###

# Coloring is rgb based on...
# https://gist.github.com/XVilka/8346728
__clr() {
		local r=$1; shift
		local g=$1; shift
		local b=$1; shift
    echo -e "\033[38;2;${r};${g};${b}m$@\033[0m"
}

__clr_b() {
		local r=$1; shift
		local g=$1; shift
		local b=$1; shift
    echo -e "\033[48;2;${r};${g};${b}m$@\033[0m"
}

###
# Icon Functions
###

__get_battery_icon() {
	# local battery_icon_array=( "" "" "" "" "" "")
	local percent=$(printf '%d' $(echo $1 | tr -d %) 2>/dev/null)
	if [[ $percent < 20 ]]; then
		echo 
	elif [[ $percent < 40 ]]; then
		echo 
	elif [[ $percent < 60 ]]; then
		echo 
	elif [[ $percent < 80 ]]; then
		echo 
	elif [[ $percent < 100 ]]; then
		echo 
	else
		echo 
	fi
}

__icons() {
	case "$1" in
		arrow)
			echo 
			;;
		source)
			echo 
			;;
		x)
			echo 
			;;
		check)
			echo 
			;;
		triangle)
			echo 
			;;
		chevron)
			echo 
			;;
		battery)
			echo $(__get_battery_icon $2)
			;;
		charging)
			echo 
			;;
		lock)
			echo 
			;;
		up)
			echo ⬆
			;;
	esac
}

###
# Git Helepr Functions
###

get_unpushed_git_commits() {
	$(git log --branches --not --remotes | grep "^commit" | wc -l)
}

git_has_unpushed_commits() {
	[[ get_unpushed_git_commits != 0 ]]
}

is_git_repo() {
	[[ 'true' == $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]
}

get_git_branch() {
	local branch=$(git symbolic-ref --short -q HEAD)
	[[ -z $branch ]] && echo ' DETACHED ' || echo " $branch "
}

is_git_dirty() {
	[[ -z $(git status --porcelain 2>/dev/null) ]]
}

###
# Date / Time Helper Functions
###

get_time() {
	date +"%T"
}

###
# Path Helper Functions
###

is_home() {
	[[ $PWD == $HOME ]] && true || false
}

is_in_home() {
	[[ "$PWD" == "$HOME"* ]]
}

###
# Misc Helper Functions
###

__trim() {
	echo "$(sed -e 's/[[:space:]]*$//' <<<$@)"
}

###
# Battery Helper Functions
###

__print_battery_info() {
	# grab battery / charging information with pmset
	# http://osxdaily.com/2015/12/10/get-mac-battery-life-info-command-line-os-x/
	local str=$(pmset -g batt|grep InternalBattery)
	local percent=$(echo $str | egrep "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';')
	local remaining=$(echo $str | egrep "([0-9]+\%).*" -o --colour=auto | cut -f3 -d';' | cut -f2 -d' ')
	local icon=$([[ "$str" != *"discharging"* ]] && __icons charging || __icons battery $percent)
	echo " ${percent} ${icon} (${remaining})"
}

###
# Functions to print out a "part" of the prompt
###
function __clr_username() {
	if [[ is_in_home ]]; then
		echo $(__clr 140 140 140 $(__clr_b 40 40 40 " $(id -un) "))$(__clr 40 40 40 $(__clr_b 12 122 155 ""))
	else
		echo $(__clr 140 140 140 $(__clr_b 40 40 40 " $(id -un) "))$(__clr 40 40 40 "")
	fi
}

function __print_path_info() {
	local DIR=""
	if is_home; then
		echo $(__clr_b 12 122 155 "🏠")
	elif is_in_home; then
		DIR="${PWD#$HOME/}"
		echo $(__clr_b 12 122 155 "🏠")$(__clr 12 122 155 $(__clr_b 60 60 60 ""))$(__clr 197 197 197 $(__clr_b 60 60 60 " ${DIR//\//  } "))
	else
		DIR=$PWD
		echo $(__clr 197 197 197 $(__clr_b 60 60 60 " ${DIR//\//  } "))
	fi
}

function __print_git_info() {
	local str=""
	if [[ is_home ]]; then
		str=$(__clr 60 60 60 "")
	else
		str=$(__clr 60 60 60 "")
	fi

	if [[ is_git_repo ]]; then
		if [[ is_git_dirty ]]; then
			# str="$(__clr_b 155 0 0 "${str} $(get_git_branch)")"
			str="$(__clr_b 155 0 0 ${str} )$(__clr_b 155 0 0 $(get_git_branch) )"
		else
			str="$(__clr_b 0 155 0 ${str} )$(__clr_b 0 155 0 $(get_git_branch) )"
		fi
	else
		echo "NOT REPO"
	fi

	echo $str
}

function run_with_sudo() {
	[[ $(id -u) -eq 0 ]]
}

function __print_end_with_error_code() {
	if [[ $1 == "0" ]]; then
		echo " $ "
	else
		echo
}


function ___prompt() {
	echo $(__clr_username)$(prepare_path)
}

function __get_end() {
	rbw_position_write_end_of_line "$(__clr 40 40 40 ◢)$(__clr 240 240 240 $(__clr_b 40 40 40 " $(get_time) $(__print_battery_info)"))"
}

function __write_prompt() {
	local error_code=$?
	echo $error_code

	echo $(__clr_username)$(__print_path_info)$(__print_git_info) $(__get_end)
}

rbw_position_get_cursor_position(){
    # based on a script from http://invisible-island.net/xterm/xterm.faq.html
    exec < /dev/tty
    local oldstty=$(stty -g)
    stty raw -echo min 0
    # on my system, the following line can be replaced by the line below it
    echo -en "\033[6n" > /dev/tty
    # tput u7 > /dev/tty    # when TERM=xterm (and relatives)
    IFS=';' read -r -d R -a pos
    stty $oldstty
    # change from one-based to zero based so they work with: tput cup $row $col
    # rbw_position_row=$((${pos[0]:2} - 1))    # strip off the esc-[
    # rbw_position_col=$((${pos[1]} - 1))
    echo "$((${pos[0]:2} - 1))|$((${pos[1]} - 1))"
}

rbw_position_write_end_of_line(){
    local end_of_line fixed_str
    local pos=$(rbw_position_get_cursor_position)
    local row=$(echo $pos| cut -d'|' -f1)
    local col=$(echo $pos| cut -d'|' -f2)
    # echo $row $col

    # delete scape characters for count
    fixed_str=$(echo -en $1 | sed 's/\[[0-9\;]*m//g')

    end_of_line=$((`tput cols`-${#fixed_str}))
    tput sc                   #Save the cursor position&attributes
    tput cup $row $end_of_line
    echo -en $1
    tput rc
}
