/*
###########################################################################
#
# Copyright (C) 2012, Zenoss Inc.
#
###########################################################################
*/

(function(){

var ZC = Ext.ns('Zenoss.component');

ZC.registerName('PuppetClient', _t('PuppetClient'), _t('PuppetClients'));

ZC.PuppetClientPanel = Ext.extend(ZC.ComponentGridPanel, {
    constructor: function(config) {
        config = Ext.applyIf(config||{}, {
            autoExpandColumn: 'name',
            componentType: 'PuppetClient',
            fields: [
                    {name: 'uid'},
                    {name: 'name'},
                    {name: 'status'},
                    {name: 'severity'},
                    {name: 'managedDevice'},
                    {name: 'signed'},
                    {name: 'monitored'},
                    {name: 'locking'}
            ],
            columns: [{
                id: 'severity',
                dataIndex: 'severity',
                header: _t('Events'),
                renderer: Zenoss.render.severity,
                sortable: true,
                width: 50
            },{
                id: 'name',
                dataIndex: 'name',
                header: _t('Name'),
                sortable: true
            },{
                id: 'os_guest_instance',
                dataIndex: 'managedDevice',
                header: _t('Zenoss Device'),
//                renderer: Zenoss.render.link,
                sortable: true
            },{ 
                id: 'signed',
                dataIndex: 'signed',
                header: _t('Signed?'),
                sortable: true,
                width: 60
            },{
                id: 'monitored',
                dataIndex: 'monitored',
                header: _t('Monitored'),
                sortable: true,
                width: 60
            }]
        });
        ZC.PuppetClientPanel.superclass.constructor.call(this, config);
    }
});

Ext.reg('PuppetClientPanel', ZC.PuppetClientPanel);

})();

