######################################################################
#
# Copyright 2012 Zenoss, Inc.  All Rights Reserved.
#
######################################################################

import logging
log = logging.getLogger('zen.puppet.facade')
from StringIO import StringIO

from zope.interface import implements

from Products.Zuul.facades import ZuulFacade

# Ugh.  Need the trunk versions.  Switch back to ZenModel when
# Zenoss catches up 
#from Products.ZenModel.BatchDeviceDumper import BatchDeviceDumper
#from Products.ZenModel.BatchDeviceLoader import BatchDeviceLoader
from ZenPacks.zenoss.Puppet.BatchDeviceDumper import BatchDeviceDumper
from ZenPacks.zenoss.Puppet.BatchDeviceLoader import BatchDeviceLoader

from ZenPacks.zenoss.Puppet.interfaces import IPuppetFacade


class PuppetFacade(ZuulFacade):
    implements(IPuppetFacade)

    def exportDevices(self, deviceClass='/', options={}):
        dumper = BatchDeviceDumper(noopts=True)
        output = StringIO()

        # Set command-line options
        dumper.options.root = deviceClass[1:]
        dumper.options.allzprops = True
        dumper.options.noorganizers = True
        # Hidden 'option' in BatchDeviceDump
        dumper.options.pruneLSGO = True
        self._setOptions(dumper, options)

        # Export out custom list of properties
        def isPropExportable(propdict):
            id = propdict['id']
            if id == 'zDeviceTemplate':
                return True
            return propdict['islocal']
        dumper.isPropExportable = isPropExportable

        # Don't import out all getter/setter pairs either
        dumper.ignoreSetters += (
            'setLastChange', 'setHWProductKey', 'setHWSerialNumber',
            'setOSProductKey', 'setPriority',
        )

        dumpedCount = dumper.listDeviceTree(output)
        output.seek(0)
        data = output.readlines()
        output.close()

        # Dump the results in sorted order to make file
        # comparisons easier.
        data = '\n'.join(sorted(data))
        return data, dumpedCount

    def importDevices(self, data, options={}):
        loader = BatchDeviceLoader(noopts=True)
        if isinstance(data, str):
            data = data.split('\n')

        # Set command-line options
        loader.options.nomodel = True
        self._setOptions(loader, options)

        devices = loader.parseDevices(data)
        stats = loader.processDevices(devices)
        return stats

    def _setOptions(self, obj, options):
        """
        Apply options to the dumper or loader.
        """
        for name, value in options.items():
            option = getattr(obj.options, name, None)
            if option is not None:
                setattr(obj.options, name, value)

