define zenpatch ( ) {
        exec { $name:
                cwd => "/opt/zenoss/Products",
                command => "su - zenoss -c 'zenpatch ${name}'",
                logoutput => true,
		unless => "su - zenoss -c 'zenpatch --list|grep ${name}';test $? -eq 0",
                notify => Exec["zenoss-restart"],
        }
}
