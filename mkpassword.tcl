#!/bin/sh
# -*- tcl -*-
# The next line is executed by /bin/sh, but not tcl \
exec tclsh "$0" ${1+"$@"}

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
    puts stderr "[file tail $argv0] ?Options? PlainPassword"
    puts stderr "Description:"
    puts stderr "Encrypt given Plain Password."
    puts stderr "Options:"
    puts stderr "-v  print version, and exit."
    puts stderr "-h  print this message, and exit."
    puts stderr "--" end of options"
    puts stderr "PlainPassword will be encrypted."
}

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
        -- {
            set opt [lshift argv]
            break
        }
        default {
            break
        }
    }
}

if {[string equal "" $opt]} {
    puts stderr "Error: No Plain Password."
    usage
    exit 1
}

puts stdout [EncryptPassword::EncryptPassword $opt]