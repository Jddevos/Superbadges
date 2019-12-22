({
	onFormSubmit : function(component, event, helper) {
		// console.log('Beginning handleFormSubmit');
		// console.log(event);
		var data = event.getParam("formData");
		// console.log(data);
		var resultsComponent = component.find("BoatSearchResults");
		resultsComponent.search(data.boatTypeId);
	}
})