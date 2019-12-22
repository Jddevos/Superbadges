({
    onInit : function(component, event, helper) {
		var service = component.find("service");
        service.getNewRecord(
            "BoatReview__c",
            null,
            false,
            $A.getCallback(function() {
				var record = component.get("v.boatReview");
				console.log(record);
				var error = component.get("v.recordError");
                if(error || (record === null)) {
                    console.log("Error initializing record template: " +error);
                    return;
				}
                record.Boat__c == component.get("v.boat").Id;
                component.set("v.boatReview", record);
            })
		);
    }
})