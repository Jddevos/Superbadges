({
	onSearch : function(component, event, helper) {
		// console.log('In the function');
		var boatList = [];
		var boatTypeId = component.get('v.boatTypeId');
		
		var action=component.get('c.getBoats');
		action.setParams({boatTypeId : boatTypeId});
		action.setCallback(this, function(response) {
			if (response.getState() === 'SUCCESS') {
				// console.log('Success return state');
				// console.log(response.getReturnValue());
				var boatList = response.getReturnValue();

				// console.log('Setting attributes');
				// console.log(boatList);
				component.set('v.boats', boatList);
			} else if (saveResult.state === "INCOMPLETE") {
				console.log("User is offline, device doesn't support drafts.")
			} else if (saveResult.state === "ERROR") {
				console.log('Problem saving review, error: ' +JSON.stringify(saveResult.error));
			} else {
				console.log('Unknown problem, state: ' +saveResult.state+ ', error: ' +JSON.stringify(saveResult.error));
			}
		});
		$A.enqueueAction(action);
	}
})