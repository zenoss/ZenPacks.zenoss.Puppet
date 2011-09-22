define download(
	$site="",
	$cwd="",
	$username="",
	$password="") 
	{

        if !defined(Exec["mkdir-$cwd"]) {        
	       exec { "mkdir-$cwd":
		       command => "mkdir -p ${cwd}",
		       cwd => '/',
		       creates => "${cwd}",
	       }
        }
	
	if $site {
		if $username and $password {
			exec { "wget-$name":
				command => "wget --user='${username}' --password='${password}' -T 60 ${site}/${name} -O ${name}",
				cwd => $cwd,
				logoutput => true,
				require => Exec["mkdir-$cwd"],
				timeout => 3600,
				creates => "${cwd}/${name}",
			}
		} else {
			exec { "wget-$name":
				command => "wget -T 60 ${site}/${name} -O ${name}",
				cwd => $cwd,
				logoutput => true,
				require => Exec["mkdir-$cwd"],
				timeout => 3600,
				creates => "${cwd}/${name}",
			}
		}
	
	} else {
        	notice("No site defined skipping download.")
        	notify{"No site defined skipping download.": }
	}
}	
