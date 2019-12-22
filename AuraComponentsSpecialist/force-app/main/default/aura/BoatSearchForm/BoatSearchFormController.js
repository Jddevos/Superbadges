({
	init : function(component, event, helper) {
		component.set("v.canCreate", $A.get("event.force:createRecord"));
		helper.fetchPickListVals(component, event, helper);
	},
	typeChange: function(component, event, helper) {
		// console.log('Value switched to ' +event.getSource().get("v.value"));
		component.set("v.selectedValue", (event.getSource().get("v.value")));
	},
	newBoat: function(component, event, helper) {
		var createRecords = $A.get("event.force:createRecord");
		var selectedType = component.get("v.selectedValue");
		// console.log('Selected: ' +selectedType);

		var params = {"entityApiName": "Boat__c"};

		if (selectedType != '') {
			params.defaultFieldValues = {"BoatType__c" : selectedType};
		}		
		
		createRecords.setParams(params);
		createRecords.fire();
	},
	onFormSubmit: function(component, event, helper) {
		// console.log('Beginning onFormSubmit');
		// console.log(component.get("v.selectedValue"));
		
		var formsubmit = component.getEvent("formsubmit");
		var params = { "formData" : { "boatTypeId" : component.get("v.selectedValue")}};
		formsubmit.setParams(params);
		
		// console.log('Firing formsubmit');
		// console.log(formsubmit.getParam("formData"));
		formsubmit.fire();
	}
})