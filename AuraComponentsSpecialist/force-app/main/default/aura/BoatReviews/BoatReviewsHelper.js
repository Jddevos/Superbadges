({
	onInit : function(component, event, helper) {
		var boat = component.get('v.boat');
		
		var action = component.get('c.getAll');
		action.setParams({boatId : boat.Id});
		action.setCallback(this, function(response) {
			if (response.getState() === 'SUCCESS' || saveResult === "DRAFT") {
				// console.log('Success return state');
				// console.log(response.getReturnValue());
				var boatReviews = response.getReturnValue();

				// console.log('Setting attributes');
				// console.log(boatReviews);
				component.set('v.boatReviews', boatReviews);

				// console.log('Attribute values');
				// console.log(component.get('v.boatReviews'));
			} else if (saveResult.state === "INCOMPLETE") {
				console.log("User is offline, device doesn't support drafts.")
			} else if (saveResult.state === "ERROR") {
				console.log('Problem saving review, error: ' +JSON.stringify(saveResult.error));
			} else {
				console.log('Unknown problem, state: ' +saveResult.state+ ', error: ' +JSON.stringify(saveResult.error));
			}
		});
		$A.enqueueAction(action);
	},
})