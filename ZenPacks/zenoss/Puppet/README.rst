===============================================================================
ZenPacks.zenoss.Puppet
===============================================================================

.. contents::

About
-------------------------------------------------------------------------------
This ZenPack provides a mechanism to gather information from the Puppet
master about Puppet clients.
Information about the Puppet system can be found at http://docs.puppetlabs.com/

Features
===============================================================================
The ``Puppet`` modeling plugin provides components that represent the Puppet
clients.

The ``Processes`` list is also updated with information about the Puppet
(master and client) processes.

Prerequisites
===============================================================================

==================  =========================================================
Prerequisite        Restriction
==================  =========================================================
Product             Zenoss 4.1.1 or higher
Required ZenPacks   ``ZenPacks.zenoss.Puppet``
Other dependencies  None
==================  =========================================================

Usage
===============================================================================

Modeling Puppet Masters
----------------------------------
Once a Puppet master has been identificed, follow this procedure:

#. Navigate to a device.
#. Click on the ``Modeler Plugins`` link.
#. Ensure that the modeler plugin ``zenoss.cmd.Puppet`` is selected.
#. Click on the ``Save`` button.

Installing
-----------
Install the ZenPack via the command line and restart Zenoss:

::

 zenpack --install ZenPacks.zenoss.Puppet-1.0.0-py2.7.egg
 zenoss restart``

Removing
---------
To remove the ZenPack, use the following commands:

::

 zenpack --erase ZenPacks.zenoss.Puppet
 zenoss restart

