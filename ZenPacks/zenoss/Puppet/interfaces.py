###########################################################################
#
# Copyright (C) 2012 Zenoss Inc.
#
###########################################################################

from Products.Zuul.form import schema
from Products.Zuul.utils import ZuulMessageFactory as _t
from Products.Zuul.infos.component import IComponentInfo


class IPuppetClientInfo(IComponentInfo):

    signed = schema.Bool(title=_t(u'Is the client SSL signed?'), group='Details')
    managedDevice = schema.TextLine(title=_t(u'Zenoss Device'), group='Details')

