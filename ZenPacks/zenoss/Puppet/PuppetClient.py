###########################################################################
#
# Copyright (C) 2012, Zenoss Inc.
#
###########################################################################

from Products.ZenRelations.RelSchema import ToManyCont, ToOne
from Products.ZenModel.DeviceComponent import DeviceComponent
from Products.ZenModel.ManagedEntity import ManagedEntity
from Products.ZenModel.ZenossSecurity import ZEN_CHANGE_DEVICE


class PuppetClient(DeviceComponent, ManagedEntity):
    meta_type = portal_type = "PuppetClient"

    signed = False

    _properties = ManagedEntity._properties + (
        {'id': 'signed', 'type': 'boolean', 'mode': 'w'},
    )

    _relations = ManagedEntity._relations + (
        ('puppetMaster', ToOne(ToManyCont,
            'Products.ZenModel.Device.Device',
            'puppetClients')
            ),
        )

    # This makes the "Templates" component display available.
    factory_type_information = ({
        'actions': ({
            'id': 'perfConf',
            'name': 'Template',
            'action': 'objTemplates',
            'permissions': (ZEN_CHANGE_DEVICE,),
            },),
        },)

    def device(self):
        return self.puppetMaster()

    def getManagedDevice(self):
        name = self.titleOrId()
        device = self.findDevice(name)
        if device is not None:
            return device

        ip = self.getDmdRoot("Networks").findIp(name)
        if ip is not None:
            return ip.device()
