import "defines/*.pp"

class zenoss-base {
	$ze_packages = [ "net-snmp",
			 "net-snmp-utils",
			 "gmp",
			 "libgomp",
			 "libgcj",
			 "liberation-fonts",
			]
	package{$ze_packages: ensure => installed }

        exec { zenoss-restart:
                command => "/etc/init.d/zenoss restart",
                timeout => "600",
                logoutput => true,
                refreshonly => true,
        }
}
	
#class zenoss-enterprise-302 {
#	$ze_version = "3.0.2"
#	zenoss-enterprise { $ze_version: 
#				release => "839", 
#				site => "http://support.zenoss.com/download/files/el${lsbmajdistrelease}-${ze_version}", }
#	enterprise-zenpack{ "ZenPacks.zenoss.MultiRealmIP-2.0.1-py2.6.egg":
#			site => "http://support.zenoss.com/download/files/zenpacks-3.0.2" }
#}

#class zenoss-enterprise-252 {
#	$ze_version = "2.5.2"
#	zenoss-enterprise { $ze_version: 
#			       release => "590",
#			       site => "http://support.zenoss.com/download/files/older/enterprise-${ze_version}/el${lsbmajdistrelease}/" }
#
#	enterprise-zenpack { "ZenPacks.zenoss.MultiRealmIP-2.0.1-py2.4.egg":
#			site => "http://support.zenoss.com/download/files/older/enterprise-${ze_version}/zenpacks/" }
#
#}

