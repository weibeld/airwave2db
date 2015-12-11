# General utility AWK functions, used by main.awk and func.awk
#
# Daniel Weibel <danielmartin.weibel@polimi.it> Nov. 2015 - Dec. 2015
#------------------------------------------------------------------------------#

# Test if argument is numeric (in any form). Return 1 (true) or 0 (false)
function is_num(input) {
  return (input == input+0)
}

# Return regex that defines a CSV field (assign to FPAT). A field is either:
#   - Anything that is not a comma:                               ([^,]*)
#   - A ", followed by anything that is not a ", followed by a ": (\"[^\"]*\")
# https://www.gnu.org/software/gawk/manual/html_node/Splitting-By-Content.html
function get_csv_fpat() {
  return "([^,]*)|(\"[^\"]*\")"
}

# Test if a variable is non-empty
function is_set(var) {
  return (var != "")
}

# Print an error message to stderr and exit
function abort(msg) {
  print msg > "/dev/stderr"
  exit 1
}

# Print all elements of ARGV
function print_args(pretty,   i) {
  for (i = 0; i < ARGC; i++) {
    if (pretty) printf "ARGV[%d] = ", i
    print ARGV[i]
  }
}
