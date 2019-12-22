({
    jsLoaded : function(component) {
        component.set("v.jsLoaded", true);
    },
    onPlotMapMarker : function(component, event, helper) {
		console.log('plotting');
		var loc = {
			sObjectId : event.getParam("sObjectId"),
			lat : event.getParam("lat"),
			long : event.getParam("long"),
			label : event.getParam("label"),
		}
		component.set("v.location", loc);
	}
})