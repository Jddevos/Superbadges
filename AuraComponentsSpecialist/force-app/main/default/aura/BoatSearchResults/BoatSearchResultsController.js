({
	init : function(component, event, helper) {
		helper.onSearch(component, event, helper);
	},
	doSearch : function(component, event, helper) {
		// console.log('Beginning doSearch');
		
		var params = event.getParam("arguments");
		// console.log(params);

		if (params) {
			component.set("v.boatTypeId", params.boatTypeId);
			// console.log(component.get("v.boatTypeId"))
			helper.onSearch(component, event, helper);
		}
	},
	onBoatSelect : function(component, event, helper) {
		component.set("v.selectedBoatId", event.getParam("boatId"));
		// console.log(component.get("v.selectedBoatId"));
		// helper.onSearch(component, event, helper);
	},
})