# Helper Bash functions for ../run
#
# IMPORTANT: before using, set "_un" and "_pw" variables in "download_cookie"
# and "save_csv_to_db" to actual credentials.
#
# Daniel Weibel <danielmartin.weibel@polimi.it> Nov. 2015 - Dec. 2015
#------------------------------------------------------------------------------#

# Authenticate to Airwave in order to get a cookie that can be used for future
# connections. Writes the cookie string to stdout.
download_cookie() {
  local airwave_un=user-deib
  local airwave_pw=Loo5ou1m
  curl -s   \
       -c - \
       -d credential_0="$airwave_un" \
       -d credential_1="$airwave_pw" \
       -d login="Log In" \
       -d destination=/  \
       https://airwave.polimi.it/LOGIN |
  tail -1 | cut -f 7
}

# Download "connected devices" CSV file of a specific access point from Airwave.
# Writes the downloaded CSV file to stdout.
download_csv() {
  local ap_id=$1
  local cookie=$2
  curl -s \
       -H "Cookie: Mercury::Handler::AuthCookieHandler_AMPAuth=$cookie" \
       --compressed \
       "https://airwave.polimi.it/api/csv_export.csv?fv_id=6&ap_id=$ap_id&page_length=500&list=client_of_device"
}

# Slightly convert a "connected devices" CSV file (as downloaded from Airwave).
# This is needed to match the database schema, and is done by AWK scripts.
# Reads the intput CSV file from stdin and writes the output CSV file to stdout.
convert_csv() {
  local ap_id=$1
  local time=$2
  tail -n +2 |
  gawk -i aux/awk/func.awk -i aux/awk/util.awk -f aux/awk/main.awk \
       -v ap_id="$ap_id" -v time="$time"
}

# Load a CSV file (output of "convert_csv") into the database.
save_csv_to_db() {
  local csv=$1
  local mysql_un=antlab
  local mysql_pw=antlab
  local db=airwave
  local tbl=connected_devices
  local cmd="load data local infile '$csv' into table $tbl fields terminated by ',';"
  mysql -u "$mysql_un"   \
        -p"$mysql_pw"    \
        --local-infile=1 \
        -e "$cmd"        \
        "$db"
}
