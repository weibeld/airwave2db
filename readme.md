Airwave2DB
==========

This tool periodically downloads the *connected devices* data of each access
point from Airwave and appends it to table `connected_devices` in local MySQL
database `airwave`


Organisation
------------

~~~
aw2db
|
|__run      # Main script, executed periodically by a cron task
|
|__aux/     # Contains helper code files used by 'run'
|
|__out/     # Created by 'run', contains all output files
|
|__bin/     # Contains several user tools
|
|__crontab  # Example of crontab file for executing 'run' every 5 minutes
~~~


Installation
------------

### Prerequisites

- gawk
    - `sudo apt-get install gawk`
- MySQL
    - `sudo apt-get install mysql-server`
- MySQL database `airwave` with table `connected_devices`


### Installation

1. `git clone https://github.com/weibeld/aw2db.git`
2. In `crontab` adapt path to the location of `aw2db` directory
3. In `aux/func.sh`, adapt `*_un` and `*_pw` variables in functions
`get_cookie` and `save_csv_to_db` to credentials of Airwave and database,
respectively.
5. Install crontab: `crontab ./crontab`
