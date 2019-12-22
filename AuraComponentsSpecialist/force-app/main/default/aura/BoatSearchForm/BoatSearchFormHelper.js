({
	fetchPickListVals : function(component, event, helper) {
		// console.log('In the function');
		var action = component.get('c.getBoatTypes');
		var types = [];
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
				// console.log('Success return state');
				var allValues = response.getReturnValue();
				// console.log(allValues);

				types.push({label: 'All Types', value: '', selected: 'true'});

				if (allValues != undefined && allValues.length > 0) {
					for (var i=0; i<allValues.length; i++) {
						types.push({label: allValues[i].Name, value: allValues[i].Id});
					}
				}

				// console.log('Setting attributes');
				// console.log(types);
				component.set("v.options", types);
				component.set("v.selectedValue", types[0].value);
			}
		});
		$A.enqueueAction(action);
	}
})