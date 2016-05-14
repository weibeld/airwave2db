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

- gawk >= 4.1.0 (must support `-i` option)
    - Try:
        - `sudo apt-get install gawk`
    - If this installs an earlier version, download and install manually:
        - <http://ftp.gnu.org/gnu/gawk/>
        - `./configure; make; sudo make install`
- curl
    - `sudo apt-get install curl`
- MySQL
    - `sudo apt-get install mysql-server`
- MySQL database `airwave` with table `connected_devices`
    - See Section [Database Setup](#database-setup)

### Installation

1. `git clone https://github.com/weibeld/aw2db.git`
2. In `crontab` adapt path to the location of `aw2db` directory
3. In `aux/func.sh`, adapt `*_un` and `*_pw` variables in functions
`get_cookie` and `save_csv_to_db` to credentials of Airwave and database,
respectively.
5. Install crontab: `crontab ./crontab`


Database Setup
--------------

Below are the MySQL statements to create the database `airwave` and the table
`connected_devices` with the required columns.

### Create database

~~~sql
create database airwave;
~~~

### Create table

~~~sql
create table connected_devices (
ap_id                 int,
device_mac            char,
timestamp             timestamp,
sig_quality           int,
ssid                  varchar(255),
vlan                  int,
interface             varchar(255),
conn_mode             varchar(255),
chipset               varchar(255),
cipher                varchar(255),
auth                  varchar(255),
goodput               float,
speed                 float,
association_timestamp timestamp,
duration              int,
user_name             varchar(255),
bw_usage              float
);
~~~
