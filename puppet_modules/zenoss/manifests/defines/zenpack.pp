define zenpack ( $site="" ) {
        download { $name:
                site => $site,
                username => "zenoss",
                password => "z3n0$$",
                cwd => "/tmp",
                creates => "/tmp/$name",
        }
        exec { $name:
                cwd => "/tmp",
                command => "su - zenoss -c 'zenpack --install /tmp/${name}'",
                timeout => "3600",
                logoutput => true,
                creates => "/opt/zenoss/ZenPacks/${name}",
                require => Service["zenoss"],
                notify => Exec["zenoss-restart"],
        }
}
