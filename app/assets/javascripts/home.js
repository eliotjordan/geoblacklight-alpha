'use strict';

var map;

function setupMap() {
  map = L.map('map');
  var basemap = L.tileLayer('https://a.tiles.mapbox.com/v3/examples.map-vyofok3q/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
    maxZoom: 18
  }).addTo(map);
  map.setZoom(1)
  map.setView([0,0])
}

//Setup map on doc ready
$(document).ready(function(){
  setupMap();
});