({
	onBoatClick : function(component, event, helper) {
		var boat = component.get("v.boat");
		if (boat && boat.Id) {
			// console.logL"boat.Id: " +boat.Id);
			// console.log(boat);

			var selectboat = component.getEvent("boatselect");
			var selectboatparams = { "boatId" : boat.Id };
			selectboat.setParams(selectboatparams);
			selectboat.fire();

			var selectedboat = $A.get("event.c:BoatSelected");
			var selectedboatparams = { "boat" : boat };
			selectedboat.setParams(selectedboatparams);
			selectedboat.fire();

			var plotMapMarker = $A.get("e.c:plotMapMarker");
			var plotmapmarkerparams = {
				"sObjectId" : boat.Id,
				"lat" : boat.Geolocation__Latitude__s,
				"long" : boat.Geolocation__Longitude__s,
				"label" : boat.Name,
			};

			// console.log(plotmapmarkerparams);
			plotMapMarker.setParams(plotmapmarkerparams);
			plotMapMarker.fire();
		}
	}
})