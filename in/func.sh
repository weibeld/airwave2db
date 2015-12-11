# Bash helper functions for the main 'run' script of 'aw2db'.
#
# Daniel Weibel <danielmartin.weibel@polimi.it> Nov. 2015 - Dec. 2015
#------------------------------------------------------------------------------#

# Authenticate to Airwave in order to get a cookie that can be used for future
# connections. Writes the cookie to stdout.
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

# Adapts a "connected devices" CSV file of a single access point (as downloaded
# from Airwave) so that it can be loaded into the database. Reads the input
# CSV file from stdin, and writes the output CSV file to stdout.
# Note: assumes current working directory to be application root ('aw2db')
convert_csv() {
  local ap_id=$1
  local time=$2
  tail -n +2 |
  gawk -i in/awk/func.awk -i in/awk/util.awk -f in/awk/main.awk \
       -v ap_id="$ap_id" -v time="$time"
}

# Load an adapted "connected devices" CSV file (as produced by convert_csv())
# into the database.
save_csv_to_db() {
  local csv=$1
  local mysql_un=common
  local mysql_pw=common
  local db=airwave
  local tbl=connected_devices
  local cmd="load data local infile '$csv' into table $tbl fields terminated by ',';"
  mysql -u "$mysql_un"   \
        -p"$mysql_pw"    \
        --local-infile=1 \
        -e "$cmd"        \
        "$db"
}
