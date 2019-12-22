({
    onBoatSelected : function(component, event, helper) {
		// console.log('onBoatSelected');
		var boat = event.getParam("boat");
		component.set("v.id", boat.Id);
		// console.log(component.get("v.id"));

		component.find("service").reloadRecord();
	},
	onRecordUpdated : function(component, event, helper) {
		var reviews = component.find("reviews");
		if (reviews) {
			reviews.refresh();
		}
	},
	onBoatReviewAdded : function(component, event, helper) {
		component.find("detailtabs").set("v.selectedTabId", "boatreviewtab");
		
		var reviews = component.find("reviews");
		if (reviews) {
			reviews.refresh();
		}
	},
})