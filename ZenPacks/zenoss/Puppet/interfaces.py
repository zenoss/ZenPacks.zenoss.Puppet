###########################################################################
#
# Copyright (C) 2012 Zenoss Inc.
#
###########################################################################

from Products.Zuul.form import schema
from Products.Zuul.utils import ZuulMessageFactory as _t
from Products.Zuul.infos.component import IComponentInfo
from Products.Zuul.interfaces import IFacade


class IPuppetClientInfo(IComponentInfo):

    signed = schema.Bool(title=_t(u'Is the client SSL signed?'), group='Details')
    managedDevice = schema.TextLine(title=_t(u'Zenoss Device'), group='Details')


class IPuppetFacade (IFacade):

    def exportDevices(deviceClass):
        """
        Export out devices in zenbatchload format.

        @parameter deviceClass: location to start exporting devices (default /)
        @type deviceClass: string
        @return: zenbatchload format file
        @rtype: string
        """

    def importDevices(data):
        """
        Import devices from zenbatchload format string.

        @parameter data: zenbatchload format file
        @type data: string
        @return: key/value pairs of import statistics
        @rtype: dictionary of category and statistic
        """

