###########################################################################
#
# Copyright 2012 Zenoss, Inc.  All Rights Reserved.
#
###########################################################################

import logging
log = logging.getLogger('zen.puppet.router')
import Globals

from Products import Zuul
from Products.ZenUtils.Ext import DirectResponse, DirectRouter


class PuppetRouter(DirectRouter):
    """
    Provide a file interface that Puppet configuration can be compared
    against and then imported into Zenoss.  For large groups of devices,
    doing each device separately consumes too much resources.
    """

    def _getFacade(self):
        return Zuul.getFacade('puppet', self.context)

    def exportDevices(self, deviceClass='/', options={}):
        """
        Create zenbatchload format file starting from the device class.

        For Puppet, the templates zproperty is expanded to get everything
        from the subclass.
        """
        facade = self._getFacade()
        data, dumpedCount = facade.exportDevices(deviceClass=deviceClass,
                                    options=options)
        return DirectResponse.succeed(data=data, deviceCount=dumpedCount)

    def importDevices(self, data, options={}):
        """
        Create zenbatchload format file starting from the device class.
        """
        facade = self._getFacade()
        try:
            stats = facade.importDevices(data=data, options=options)
        except Exception:
            log.exception("Unable to import devices: %s", data)
            msg = "Failed -- see $ZENHOME/logs/event.log for details."
            return DirectResponse.fail(msg=msg)
        return DirectResponse.succeed(data=data, stats=stats)

