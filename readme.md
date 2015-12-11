Airwave2DB
==========

This tool periodically (every 5 minutes) downloads the *connected devices* data
of each access point (AP) from Airwave, and inserts it in the local MySQL database
`airwave` (table `connected_devices`).

Each row of the downloaded data corresponds to a *connected device* of a
specific AP.


Organisation
------------

~~~
aw2db
|
|__run      # Main script: download Airwave data and insert it into database
|           # This script is run every 5 minutes by a cron task
|
|__in       # Helper code files, accessed by 'run'
|  |_ ...
|
|__out      # Location of all output files of 'run'
|  |__...
|
|__tools    # Miscellaneous user tools (e.g. for analysing 'out/log.csv')
|  |__...
|
|__crontab  # Copy of crontab file that launches 'run' every 5 minutes
~~~


Installation
------------

### Prerequisites

- Latest gawk version installed
    - http://ftp.gnu.org/gnu/gawk/
    - `./configure; make; make install`
- MySQL database `airwave` with table `conncted_devices` set up


### Installation

1. `git clone https://github.com/weibeld/aw2db.git` from within `$HOME` (this
   location is important)
2. In `run`, adapt path in first code line to your `$HOME/aw2db`
3. In `in/func.sh`, verify Airwave credentials (function `get_cookie()`)
4. In `in/func.sh`, verify database credentials (function `save_csv_to_db()`)
5. Install crontab: `crontab ./crontab`
