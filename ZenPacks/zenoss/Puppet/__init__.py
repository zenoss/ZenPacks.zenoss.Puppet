######################################################################
#
# Copyright 2012 Zenoss, Inc.  All Rights Reserved.
#
######################################################################


import Globals

from Products.ZenModel.ZenPack import ZenPack as ZenPackBase
from Products.ZenRelations.RelSchema import ToOne, ToManyCont
from Products.ZenModel.Device import Device

from Products.ZenUtils.Utils import unused
unused(Globals)

# Hack the relations at startup and install time
Device._relations += (
   ('puppetClients', ToManyCont(ToOne,
    'ZenPacks.zenoss.Puppet.PuppetClient.PuppetClient', 'puppetMaster')),
)


class ZenPack(ZenPackBase):

    def remove(self, app, leaveObjects=False):
        Device._relations = tuple(
            [x for x in Device._relations if x[0] != 'puppetClients' ])

        self.rebuildRelations(app.zport.dmd)
        super(ZenPack, self).remove(app, leaveObjects)

    def upgrade(self, app):
        ZenPackBase.upgrade(self, app)
        self.rebuildRelations(app.zport.dmd)

    def rebuildRelations(self, dmd):
        for d in dmd.Devices.getSubDevices():
            d.buildRelations()

