#!/usr/bin/awk -f
#
# See also:
# https://developer.ibm.com/tutorials/l-awk1/
# https://www.grymoire.com/Unix/Awk.html
# https://www.gnu.org/software/gawk/manual/gawk.html

BEGIN {
  drop="yes"
}
drop == "no" && $3 == "##" {
  $1=""; $3=""
  host=$2; $2=""; n=split($0, users, " ")
  for (i in users) {
    uri=users[i] "@" host
    system("echo spawning ssh " uri "...")
    system("{ ssh '" uri "' '" run "'; echo ... " uri " returns $?; } &")
  }
}
$0 == "# Known hosts (the known users follow ##):" { drop="no" }
