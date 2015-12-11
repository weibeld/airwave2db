# Adapt a "connected devices" CSV file of a single access point (as downloaded
# from Airwave) so that it matches the database format. Write the adapted CSV
# file to stdout.
#
# Note: the input CSV file must not have a header
#
# Usage: gawk -v ap_id=<AP_ID>              \
#             -v time=<YYYY-MM-DD HH:MM:SS> \
#             -i <func.awk>                 \
#             -i <util.awk>                 \
#             -f <main.awk>                 \
#             <input_file>
#
# Daniel Weibel <danielmartin.weibel@polimi.it> Nov. 2015 - Dec. 2015
#------------------------------------------------------------------------------#

BEGIN {
  FPAT = get_csv_fpat()
  OFS  = ","
  if (!is_set(ap_id) || !is_set(time))
    abort("gawk: variable(s) missing (pass with -v option).")
}

{
  # Check that the line has 19 fields
  if (NF != 19) abort("gawk: line "FNR" has" NF "columns instead of 19.")

  # Remove quotes from quoted fields (output CSV has no quoted fields)
  for (i = 1; i <= NF; i++) {
    if (substr($i, 1, 1) == "\"") $i = substr($i, 2, length($i)-2) 
  }

  # Read fields of INPUT file into variables
  i_nome_utente             = $1
  i_indirizzo_mac           = $2
  i_qual_segn               = $3
  i_ssid                    = $4
  i_vlan                    = $5
  i_interfaccia             = $6
  i_modalita_di_connessione = $7
  i_chipset_di_rete         = $8
  i_modalita_di_inoltro     = $9   # Not used in output
  i_durata                  = $10  # Format: 'x [secondi|minuti|ore]'
  i_tipo_autentic           = $11
  i_cifratura               = $12
  i_ora_data_autentic       = $13  # Not used in output (time since last auth.)
  i_utilizzo                = $14  # Format: 'x [bps|Kbps|Mbps|Gbps]'
  i_goodput                 = $15
  i_velocita                = $16
  i_indirizzi_ip_lan        = $17  # Not used in output
  i_nomi_host_lan           = $18  # Not used in output
  i_ora_associazione        = $19

  # Create variables for fields of OUTPUT file (in comments, data types of
  # corresponding columns in the MySQL table).
  o_ap_id                   = ap_id                            # int
  o_device_mac              = i_indirizzo_mac                  # char
  o_timestamp               = time                             # timestamp
  o_sig_quality             = sanitize_num(i_qual_segn)        # int
  o_ssid                    = i_ssid                           # varchar
  o_vlan                    = sanitize_num(i_vlan)             # int
  o_interface               = i_interfaccia                    # varchar
  o_conn_mode               = i_modalita_di_connessione        # varchar
  o_chipset                 = i_chipset_di_rete                # varchar
  o_cipher                  = i_cifratura                      # varchar
  o_auth                    = i_tipo_autentic                  # varchar
  o_goodput                 = sanitize_num(i_goodput)          # float
  o_speed                   = sanitize_num(i_velocita)         # float
  o_association_timestamp   = convert_date(i_ora_associazione) # timestamp
  o_duration                = convert_duration(i_durata)       # int
  o_user_name               = i_nome_utente                    # varchar
  o_bw_usage                = convert_usage(i_utilizzo)        # float

  # Write line of output file
  print o_ap_id,
        o_device_mac,
        o_timestamp,
        o_sig_quality,
        o_ssid,
        o_vlan,
        o_interface,
        o_conn_mode,
        o_chipset,
        o_cipher,
        o_auth,
        o_goodput,
        o_speed,
        o_association_timestamp,
        o_duration,
        o_user_name,
        o_bw_usage
}
