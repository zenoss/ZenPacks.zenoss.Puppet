define zenoss ( $enterprise="",$release="", $site="http://downloads.sourceforge.net/zenoss/" ) {
	include zenoss-base
	$working_dir = "/zenoss-repo"
        if $enterprise {
	    if $ze_download_user and $ze_download_pass {
		download { [
			   "zenoss-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm",
			   "zenoss-core-zenpacks-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm",
			   "zenoss-enterprise-zenpacks-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm",
			]:
			site => $site,
			username => $ze_download_user,
			password => $ze_download_pass,
			cwd => $working_dir,
			notify => Exec["zenoss-create-repo"],
		   }
		} else {
			notice("Zenoss Download Username and passwords are not set.  Skipping Zenoss Enterprise ${name} download.")
			notify{"Zenoss Download Username and passwords are not set.  Skipping Zenoss Enterprise ${name} download.": }
		}
        } else {
		download { [
			   "zenoss-${name}.el${lsbmajdistrelease}.${architecture}.rpm",
			   "zenoss-core-zenpacks-${name}.el${lsbmajdistrelease}.${architecture}.rpm",
			]:
			site => $site,
			username => $ze_download_user,
			password => $ze_download_pass,
			cwd => $working_dir,
			notify => Exec["zenoss-create-repo"],
	        }
        }

        if defined(Package["createrepo"]) {
            realize(Package["createrepo"])
        } else {
          @package { "createrepo":
		ensure => installed,
          } 
          realize(Package["createrepo"])
        }

        if $enterprise {
		exec { "zenoss-create-repo":
			cwd => $working_dir,
			command => "createrepo -d .",
			logoutput => true,
			refreshonly => true,
			require => [ Package["createrepo"], 
				     Exec["wget-zenoss-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm"],
				     Exec["wget-zenoss-core-zenpacks-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm"],
				     Exec["wget-zenoss-enterprise-zenpacks-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm"],
				   ]
		}        
        } else {	
		exec { "zenoss-create-repo":
			cwd => $working_dir,
			command => "createrepo -d .",
			logoutput => true,
			refreshonly => true,
			require => [ Package["createrepo"], 
				     Exec["wget-zenoss-${name}.el${lsbmajdistrelease}.${architecture}.rpm"],
				     Exec["wget-zenoss-core-zenpacks-${name}.el${lsbmajdistrelease}.${architecture}.rpm"],
				   ]
		}        
        }	
        yumrepo { "zenoss-repo":
      		baseurl => "file:$working_dir",
      		descr => "Zenoss Packages Repository",
      		enabled => 1,
		require => Exec[zenoss-create-repo],
      		gpgcheck => 0
		
   	}

	
        if $enterprise {
		package { "zenoss":
			  ensure => "${name}-${release}.el${lsbmajdistrelease}",
			  require => [ Exec["wget-zenoss-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm"],
				       Exec["zenoss-create-repo"],
				       Yumrepo["zenoss-repo"], ],
			  notify => Exec["restart-zenoss"],	
		}
        } else {
		package { "zenoss":
			  ensure => latest,
			  require => [ Exec["wget-zenoss-${name}.el${lsbmajdistrelease}.${architecture}.rpm"],
				       Exec["zenoss-create-repo"],
				       Yumrepo["zenoss-repo"], ],
			  notify => Exec["restart-zenoss"],	
		}
        }
        
	exec { "restart-zenoss":
                cwd => $working_dir,
                command => "service zenoss stop;service zenoss start",
                timeout => "3600",
		refreshonly => true, 
                logoutput => true,
        }
        
        if $enterprise {
	    package { "zenoss-enterprise-zenpacks":
                   ensure => "${name}-${release}",
		   require => [ Service["zenoss"],
                   		Exec["wget-zenoss-core-zenpacks-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm"],
                   		Exec["wget-zenoss-enterprise-zenpacks-${name}-${release}.el${lsbmajdistrelease}.${architecture}.rpm"] ]
            }
        } else {
	    package { "zenoss-core-zenpacks":
                   ensure => latest,
		   require => [ Service["zenoss"],
                   		Exec["wget-zenoss-core-zenpacks-${name}.el${lsbmajdistrelease}.${architecture}.rpm"] ]
            }
        }

	service { "zenoss":
		  pattern => "zeoctl",
		  ensure => running,
		  enable => true,
		  hasstatus => false,
		  require => Package["zenoss"],
	}
}
