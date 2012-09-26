###########################################################################
#
# Copyright (C) 2012, Zenoss Inc.
#
###########################################################################

__doc__ = """Puppet
Determine the list of Puppet clients on a Puppet master.

/usr/bin/puppet cert list --all
"""

from Products.DataCollector.plugins.CollectorPlugin import CommandPlugin


class Puppet(CommandPlugin):
    relname = "puppetClients"
    modname = 'ZenPacks.zenoss.Puppet.PuppetClient'

    command = "/usr/bin/puppet cert list --all"

    def process(self, device, results, log):
        log.info('Collecting %s for device %s', self.name(), device.id)

        rm = self.relMap()

        for clientEntry in results.split('\n'):
            if not clientEntry: # Blank line
                continue

            om = self.objectMap()
            if clientEntry.startswith('+'):
                om.signed = True
                name = clientEntry[2:].strip()

            elif clientEntry.startswith(' '):
                name = clientEntry.strip()

            else:
                # Puppet is probably emitting error message -- ignore
                continue

            om.title = name
            om.id = self.prepId(name)
            rm.append(om)

        return rm

