#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

package require Expect
package require EncryptPassword

set version {1.0}

proc lshift {listVar} {
    upvar 1 $listVar cdr
    set car [lindex $cdr 0]
    set cdr [lreplace $cdr [set cdr 0] 0]
    return $car
}

proc usage {} {
    global argv0
    puts stderr "Usage:"
    puts stderr "[file tail $argv0] ?Options...? EncryptedPassword Command ?args...?"
    puts stderr "Description:"
    puts stderr "Automaticaly execute command that prompt for password."
    puts stderr "Options:"
    puts stderr "-h                 print this messages, and exit."
    puts stderr "-v                 print version, and exit."
    puts stderr "-i                 Enter interactive mode."
    puts stderr "--                 End of options."
    puts stderr "EncryptedPassword  Encrypted password using mkpassword.tcl"
    puts stderr "Command            Command that prompt for password."
    puts stderr "args...            Options for command."
    puts stderr "Example:"
    puts stderr "[file tail $argv0] EncryptedPassword mysqldump -u root -p DATABASE > DUMPFILE.sql"
}

set interact false
while {[llength $argv]} {
    set opt [lshift argv]
    switch -exact -- $opt {
        -v {
            puts stderr "[file tail $argv0] version: $version"
            exit 0
        }
        -h {
            usage
            exit 0
        }
        -i {
            set interact ture
        }
        -- {
            set opt [lshift argv]
            break
        }
        default {
            break
        }
    }
}

set password [EncryptPassword::DecryptPassword $opt]
eval spawn -noecho $argv
log_user 0
expect "assword:"
log_user 1
send -- "$password\r"
if $interact {
    interact
} else {
    expect eof
}


