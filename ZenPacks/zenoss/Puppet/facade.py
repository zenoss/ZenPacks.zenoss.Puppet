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
        dumper = BatchDeviceDumper()
        output = StringIO()

        # Set command-line options
        dumper.options.root = deviceClass[1:]
        dumper.options.allzprops = True
        self._setOptions(dumper, options)

        dumpedCount = dumper.listDeviceTree(output)
        output.seek(0)
        data = output.read()
        output.close()
        return data, dumpedCount

    def importDevices(self, data, options={}):
        loader = BatchDeviceLoader()
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

