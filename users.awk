#!/usr/bin/awk -f

BEGIN {
  drop="yes"
} 
drop == "no" { print $0 }
$0 == "# Known hosts:" { drop="no" }
