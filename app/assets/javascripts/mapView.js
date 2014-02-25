"use strict";

var map, wmsLayer, spinner, mapBbox, alert;

var serialiseObject = function (obj) {
    var pairs = [];
    for (var prop in obj) {
        if (!obj.hasOwnProperty(prop)) {
            continue;
        }
        pairs.push(prop + '=' + obj[prop]);
    }
    return pairs.join('&');
}



function setupMap(){
	map = L.map('map');
	console.log(doc)
	var location = JSON.parse(doc.Location);
	if (doc.MinY){
		var layerBbox = [[doc.MinY, doc.MinX], [doc.MaxY, doc.MinX], [doc.MaxY, doc.MaxX], [doc.MinY,doc.MaxX]];
		map.fitBounds([[doc.MinY, doc.MinX], [doc.MaxY, doc.MaxX]]);
	}

	var wmsServer, wfsServer;

	if (location.wms && location.wms[0].length < 2){
			wmsServer = location.wms;
	}else{
		if (location.wms){
			wmsServer = location.wms[0];
		}
	}

	var basemap = L.tileLayer('https://a.tiles.mapbox.com/v3/examples.map-vyofok3q/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
    maxZoom: 18
	}).addTo(map);
	
	map.on('click', function(e){
		spinner = "<span id='attribute-table' class=''><i class='fa fa-spinner fa-spin fa-3x fa-align-center'></i></span>"
		$("#attribute-table").replaceWith(spinner);
		// console.log(e)
		mapBbox = map.getBounds()
		var wmsoptions = {
			"URL": wmsServer,
			"SERVICE": "WMS",
			"VERSION": "1.1.1",
			"REQUEST": "GetFeatureInfo",
			"LAYERS": doc.WorkspaceName + ":" + doc.Name,
			"STYLES": "",
			"SRS": "EPSG:4326",
			"BBOX": mapBbox._southWest.lng + "," + mapBbox._southWest.lat + "," + mapBbox._northEast.lng + "," + mapBbox._northEast.lat,
			"WIDTH": $("#map").width(),
			"HEIGHT": "400",
			"QUERY_LAYERS": doc.WorkspaceName + ":" + doc.Name,
			"X": Math.round(e.containerPoint.x),
			"Y": Math.round(e.containerPoint.y),
			"EXCEPTIONS": "application/json",
			"info_format": "application/json"
		}
		console.log(e);

		// if (doc.Institution == "Stanford"){
		// 	options["URL"] = "http://kurma-pod1-prod.stanford.edu/geoserver/wms"
		// }
		// if (location.wms[0].length < 2){
		// 	options["URL"] = location.wms
		// }

		$.ajax({
			type: 'POST',
			url: '/wms/handle',
			data: wmsoptions,
			success: function(data){
				if ('gis_service' in data){
					console.log(data);
					return;
				}
				var t = $("<table id='attribute-table' class='table table-hover table-condensed table-responsive table-striped table-bordered'><thead><tr class=''><th>Attribute</th><th>Value</th></tr></thead><tbody>")
				$.each(data.values, function(i,val){
					t.append("<tr><td>" + val[0] + "</td><td>" + val[1] + "</tr>")
				});
				$('#attribute-table').replaceWith(t);
			},
			fail: function(){
				console.log(error)
			}
		});
	})
	// map.setZoom(map.getZoom()-1);
	if (doc.MinY){
		// L.polygon(layerBbox).addTo(map);	
	}else{
		map.fitWorld();
	}

	// if (doc.Institution == "Stanford"){
	// 		location.wms[0] = "http://kurma-pod1-prod.stanford.edu/geoserver/wms";
	// }
	var crs = "EPSG:3857"
	if (doc.Institution === 'Tufts'){
		crs = "EPSG:900913"
	}
	if (doc.DataType !== 'LibraryRecord' && (doc.Access == 'Public' || doc.Institution == 'Stanford')){
		wmsLayer = L.tileLayer.wms(wmsServer, {
	    layers: doc.WorkspaceName + ":" + doc.Name,
	    format: 'image/png',
	    transparent: true,  //so this seems to work for Stanford and Harvard
	    CRS: crs
		}).addTo(map);
	}else{
		L.polygon(layerBbox).addTo(map);
		$("#control").hide();
	}

}

//MapBox Opacity Control
var handle = document.getElementById('handle'),
  start = false,
  startTop;

document.onmousemove = function(e) {
  if (!start) return;
  // Adjust control
  handle.style.top = Math.max(-5, Math.min(195, startTop + parseInt(e.clientY, 10) - start)) + 'px';
  // Adjust opacity
  wmsLayer.setOpacity(1 - (handle.offsetTop / 200));
};

handle.onmousedown = function(e) {
  // Record initial positions
  start = parseInt(e.clientY, 10);
  startTop = handle.offsetTop - 5;
  return false;
};

document.onmouseup = function(e) {
  start = null;
};

//Setup map on doc ready
$(document).ready(function(){
	setupMap();

	//See full abstract
	$('#more-abstract').on('click', function(){
		$('#abstract-trunc').toggle();
		$('#abstract-full').removeClass('hidden');
	})

	//Fire download shapefile REQUEST
	$('#download-shapefile').on('click', function(){
		$('#download-shapefile').addClass('disabled');
		$('#icon-shapefile').removeClass('fa-download');
		$('#icon-shapefile').addClass('fa-spinner fa-spin');
		$.ajax({
			type: 'POST',
			url: '/download/shapefile',
			data: doc,
		}).done(function(data){
				$('#download-shapefile').removeClass('disabled');
				$('#icon-shapefile').removeClass('fa-spinner fa-spin');
				$('#icon-shapefile').addClass('fa-download');
				console.log(data)
				if ('error' in data){
					console.log('something bad');
					alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
				}else{
					alert = "<div class='alert alert-success fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Good to go!</strong> Your file is <a href='/download/file?q=" + data.data + "'>ready to download.</a></div>";
				}
				$("#main-flashes").append(alert);
		}).fail(function(data){
			alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
			$("#main-flashes").append(alert);
			$('#icon-shapefile').removeClass('fa-spinner fa-spin');
			$('#icon-shapefile').addClass('fa-download');

		})
	})

	$('#download-kml').on('click', function(){
		$('#download-kml').addClass('disabled');
		$('#icon-kml').removeClass('fa-download');
		$('#icon-kml').addClass('fa-spinner fa-spin');
		$.ajax({
			type: 'POST',
			url: '/download/kml',
			data: doc,
		}).done(function(data){
				$('#download-kml').removeClass('disabled');
				$('#icon-kml').removeClass('fa-spinner fa-spin');
				$('#icon-kml').addClass('fa-download');
				console.log(data);
				if ('error' in data){
					console.log('something bad');
					alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
				}else{
					alert = "<div class='alert alert-success fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Good to go!</strong> Your file is <a href='/download/file?q=" + data.data + "'>ready to download.</a></div>";
				}
				$("#main-flashes").append(alert);
		}).fail(function(data){
			alert = "<div class='alert alert-danger fade in'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button><strong>Holy guacamole!</strong> Something went wrong with the download :(</div>";
			$("#main-flashes").append(alert);
			$('#icon-kml').removeClass('fa-spinner fa-spin');
			$('#icon-kml').addClass('fa-download');
		})
	})
})

