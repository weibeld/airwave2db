# AWK helper functions for main.awk
#
# Daniel Weibel <danielmartin.weibel@polimi.it> Nov. 2015 - Dec. 2015
#------------------------------------------------------------------------------#

# Check if value is numeric, if not, return an empty string
function sanitize_num(input) {
  if (is_num(input)) return input
  else return ""
}

# Convert a date string in the following way:
#   > Input format:  MM/DD/YY, HH:MM [AM|PM]
#   < Output format: YYYY-MM-DD HH:MM:SS
# Idea: outsource conversion to the 'date' shell command
function convert_date(input) {
  sub(",", "", input)  # Remove comma (not supported by 'date')
  cmd = "date -d '"input"' '+%Y-%m-%d %H:%M:%S'"  # date -d <in> <out_format>
  cmd | getline output
  return output
}

# Convert string of form "<X> bps|Kbps|Mbps|Gbps" or "-" to a number in Kbps
function convert_usage(input,    a) {
  split(input, a, " ")
  switch (a[2]) {
    case "bps":  return a[1]/1024
    case "Kbps": return a[1]
    case "Mbps": return a[1]*1024
    case "Gbps": return a[1]*1024*1024
    default:     return ""
  }
}

# Convert string of the form "<X> unit [<Y> unit]", where unit is either:
#   ora|ore|minuto|minuti|secondo|secondi OR
#   hour|hours|minute|minutes|second|seconds
# to a number in minutes
function convert_duration(input,    n, a, i, total) {
  n = split(input, a, " ")  # E.g. a[1]=2, a[2]="ore", a[3]=30, a[4]="minuti"
  # Loop through all the "<X> unit" pairs
  for (i = 1; i < n; i += 2) {
    switch (a[i+1]) {
      case /or|hour/:
        total += a[i] * 60
        break
      case /minut/:
        total += a[i]
        break
      case /second/:
        total += a[i]/60
        break
      default:
        return ""
    }
  }
  # Note: int() always rounds *down* (e.g. 3.9 -> 3)
  return int(total)
}
