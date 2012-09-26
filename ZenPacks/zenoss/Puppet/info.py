###########################################################################
#
# Copyright (C) 2012 Zenoss Inc.
#
###########################################################################

from zope.component import adapts
from zope.interface import implements

from Products.Zuul.infos import ProxyProperty
from Products.Zuul.infos.component import ComponentInfo

from ZenPacks.zenoss.Puppet.PuppetClient import PuppetClient
from ZenPacks.zenoss.Puppet.interfaces import IPuppetClientInfo


class PuppetClientInfo(ComponentInfo):
    implements(IPuppetClientInfo)
    adapts(PuppetClient)

    signed = ProxyProperty("signed")

    @property
    def managedDevice(self):
        guest = self._object.getManagedDevice()
        if guest is not None:
            href = guest.getPrimaryUrlPath()
            return '<a href=%s>%s</a>' % (href, guest.titleOrId())

