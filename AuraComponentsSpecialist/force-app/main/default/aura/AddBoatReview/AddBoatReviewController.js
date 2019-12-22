({
	doInit : function(component, event, helper) {
		helper.onInit(component, event, helper);
	},
	onRecordUpdated : function(component, event, helper) {
		// TODO: This probably shouldn't fire when the AddReview tab is first selected
		var toastEvent = $A.get("event.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": "Updated",
                "message": "The record was updated."
            });
            toastEvent.fire();
        } else {
            alert("The record was updated.");
        }
	},
	onSave : function(component, event, helper) {
		component.set("v.boatReview.Boat__c",component.get("v.boat.Id"));

		var service = component.find("service");
		service.saveRecord(function(saveResult) {
			if (saveResult.state === "SUCCESS" || saveResult === "DRAFT") {
				var toastEvent = $A.get("e.force:showToast")
				if (toastEvent) {
					toastEvent.setParams({
						"title": "Saved",
						"message": "The record was saved."
					});
					toastEvent.fire();
				} else {
					alert("Review submitted!");
				}

				component.getEvent("boatReviewAdded").fire();	
				// TODO: This should refresh the Add Review tab without causing component error
				helper.onInit(component, event, helper);
			} else if (saveResult.state === "INCOMPLETE") {
				console.log("User is offline, device doesn't support drafts.")
			} else if (saveResult.state === "ERROR") {
				console.log('Problem saving review, error: ' +JSON.stringify(saveResult.error));
			} else {
				console.log('Unknown problem, state: ' +saveResult.state+ ', error: ' +JSON.stringify(saveResult.error));
			}
		});
	},
})