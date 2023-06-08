# Encrypt_password.tcl -
# Copyright (c) 2023 Takeshi Taguchi
#
# A Tcl implementation of encrypt/decrypt password function.
# 
# This is a Tcl version of
#   https://qiita.com/kazuhidet/items/122c9986ca0edd5284ff
#
package require Tcl 8.0

namespace eval ::EncryptPassword {
    namespace export EncryptPassword
    set version 1.0
    proc getUUID {} {
        global tcl_platform
        switch $tcl_platform(os) {
            {Darwin} {
                regexp {Hardware UUID: ([0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{8})} [exec system_profiler SPHardwareDataType] dummy uuid
            }
            {FreeBSD} {
                set uuid [exec kenv -q smbios.system.uuid]
            }
            {Linux} {
                set uuid [exec sudo /usr/sbin/dmidecode -s system-uuid]
            }
            default {
                puts stderr {Unsupported System.}
                exit 1
            }
        }
        return $uuid
    }
    proc EncryptPassword {plain_password} {
        set uuid [getUUID]
        set encrypted_password [exec echo $plain_password | openssl enc -e -des -base64 -k $uuid]
        return $encrypted_password        
    }
    proc DecryptPassword {encrypt_password} {
        set uuid [getUUID]
        set decrypted_password [exec echo $encrypt_password | openssl enc -d -des -base64 -k $uuid]
        return $decrypted_password
    }
}

package provide EncryptPassword 1.0

# -------------------------------------------------------------------------
# Local variables:
# mode: tcl
# indent-tabs-mode: nil
# End: