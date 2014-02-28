var map, wmsLayer;

var serialiseObject = function(obj) {
    var pairs = [];
    for (var prop in obj) {
        if (!obj.hasOwnProperty(prop)) {
            continue;
        }
        pairs.push(prop + '=' + obj[prop]);
    }
    return pairs.join('&');
};



function setupMap(){
	map = L.map('map').setView([0,0],1);
	

	var wmsServer;

	
	var basemap = L.tileLayer('https://a.tiles.mapbox.com/v3/examples.map-vyofok3q/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
    maxZoom: 18
	}).addTo(map);
}

// function WktBboxToJson(doc){
// 	return [[doc.layer_sw_latlon_0_f, doc.layer_sw_latlon_1_f], [doc.layer_ne_latlon_0_f, doc.layer_sw_latlon_1_f], [doc.layer_ne_latlon_0_f, doc.layer_ne_latlon_1_f], [doc.layer_sw_latlon_0_f, doc.layer_ne_latlon_1_f]];
// }


//Setup map on doc ready
$(document).ready(function(){
	setupMap();
	map.fitBounds(mapBbox);
});

