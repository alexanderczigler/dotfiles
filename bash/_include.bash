#
#
#
###
## My own additions to .bashrc [https://github.com/alexanderczigler/linux]
#

# Figure out the absolute path to this file
SCRIPT_PATH=${BASH_SOURCE[0]}

# Figure out the absolute path to this directory
BASH_ADDITIONS_DIR=${SCRIPT_PATH//"_include.bash"/""}

# Source all different parts
. $BASH_ADDITIONS_DIR/aliases.bash
. $BASH_ADDITIONS_DIR/environment.bash
. $BASH_ADDITIONS_DIR/completions.bash
. $BASH_ADDITIONS_DIR/functions.bash
. $BASH_ADDITIONS_DIR/prompt.bash
. $BASH_ADDITIONS_DIR/overrides.bash