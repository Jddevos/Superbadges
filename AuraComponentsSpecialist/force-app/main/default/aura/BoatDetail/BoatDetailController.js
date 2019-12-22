({
	init : function(component, event, helper) {
		component.set("v.canEdit", $A.get("event.force:navigateToSObject"));
	},
    onFullDetails : function(component, event, helper) {
        var boat = component.get("v.boat");
		var pageRef = {
			type : 'standard__recordPage',
			attributes : {
				objectApiName: 'Boat__c',
				Id : boat.Id
			}
		};

		component.find("navService").navigate(pageRef);
    }
})