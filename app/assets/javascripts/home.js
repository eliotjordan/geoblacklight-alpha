'use strict';

var map;

function setupMap() {
  map = L.map('map');
  var basemap = L.tileLayer('http://otile1.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, Tiles Courtesy of <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png">',
    maxZoom: 18
  }).addTo(map);
  map.setZoom(1)
  map.setView([0,0])
}

//Setup map on doc ready
$(document).ready(function(){
  setupMap();
});