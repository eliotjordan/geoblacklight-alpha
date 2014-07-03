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

  
  var basemap = L.tileLayer('http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
    maxZoom: 18
  }).addTo(map);
}

//Setup map on doc ready
$(document).ready(function(){
    'use strict';
  setupMap();
  map.fitBounds(mapBbox);
});