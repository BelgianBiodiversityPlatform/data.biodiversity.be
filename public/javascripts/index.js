var Cdp = {
    search: {
        filters: new Object,
        type: 'occurrences',
        results_configuration: {
            map_on_page: true,
            page: 1,
            sort: 'occurrences.key'
        }
    }
    
};

// Some objects/layers must be global because accessed by events
var map;

var markers = new OpenLayers.Layer.Markers("Results", {displayInLayerSwitcher: false});
var precis = new OpenLayers.Layer.Vector("Results precision", {
    styleMap: styleMap_precision,
    displayInLayerSwitcher: false
});
var vectors = new OpenLayers.Layer.Vector('Selection', {displayInLayerSwitcher: false});

var georef_create_link = true; // constant on page, but IE doesn't like const

function showlayer(name) {
    l = map.getLayersByName(name);
    l[0].setVisibility(true);
}

function initialize_spinner(element_id) {
	Ajax.Responders.register({
		onCreate: function(){ Element.show(element_id)},
		onComplete: function(){Element.hide(element_id)}
	});
}

function init_index() {
	
	initialize_spinner('spinner');
	
    var options = $H(common_map_options).merge({
        eventListeners: {
            // When zooming, we have to change the radius of the selection circle
            // because this radius is specified in meter
            "zoomend": function() {
                // Each time map is zoomed (including the first one on page init), the circle
                // radius is recalculated to get a constant size in pixel (because radius is expressed in
                // map units, meters in this case
                //console.log('---zoomed---');
                var rad = map.getResolution()*20;
                //console.log('res: ' + map.getResolution() + 'rad: ' + rad + 'm');
                circleControl.handler.setOptions({
                    radius: rad
                });
            }
        }
    }).toObject();
       

    map = new OpenLayers.Map('map', options);

    var polygonControl = new OpenLayers.Control.DrawFeature(vectors,
        OpenLayers.Handler.Polygon, {
          featureAdded: drawn_polygon,
          displayClass: 'olControlDrawFeaturePolygon',
          handlerOptions: {
            createFeature: function() {
              this.control.layer.destroyFeatures();
              OpenLayers.Handler.Polygon.prototype.createFeature.apply(this, arguments);
            }
          }
        });

      var circleControl = new OpenLayers.Control.DrawFeature(vectors,
        OpenLayers.Handler.RegularPolygon ,
        {
            featureAdded: drawn_polygon,
            displayClass: 'olControlDrawFeaturePoint',
            handlerOptions: {
                sides: 20,
                createGeometry: function() {
                    this.control.layer.destroyFeatures();
                    OpenLayers.Handler.RegularPolygon.prototype.createGeometry.apply(this, arguments);
                }

            }
        })


    var panelControls = [
    new OpenLayers.Control.Navigation(),
    polygonControl,
    //rectangleControl,
    circleControl
    ];
    var toolbar = new OpenLayers.Control.Panel({
        displayClass: 'olControlEditingToolbar',
        defaultControl: panelControls[0],
		'div': OpenLayers.Util.getElement('map_toolbar')
    });

    toolbar.addControls(panelControls);
    map.addControl(toolbar);

    map.addLayers(map_backgrounds.concat([vectors, precis, markers]));

    map.setBaseLayer(map_backgrounds[0]);
    map.zoomToExtent(country_bounds.transform(new OpenLayers.Projection("EPSG:4326"), map.projection));
    
}

// Called when requested scientific name (by click on search button or click on a proposal)
function updateSn(text) {
    resetSr(Cdp.search);

    // Clear markers and selection on map to show it's map search OR sn search
    markers.clearMarkers();
    vectors.destroyFeatures();
    precis.destroyFeatures();

    //filter.type = 'by_sn';
    //filter.prm = obj;
    //loadResults(search_type);
    Cdp.search.filters = new Object(); // Reset global object to remove previous filters
    Cdp.search.filters.sn = text;
    loadMyResults(Cdp.search);
}


// Callback when a new polygon has been added by user on map (index page)
function drawn_polygon(feature) {
    // We can get WKT with obj.geometry.toString()
    // This polygon is in Google projection.

    precis.destroyFeatures();
    resetSr(Cdp.search);
    // We clear the scientific name field to show it's map search OR sn search
    $("sn").value = '';
    // We clear the previous markers
    markers.clearMarkers();
    
    Cdp.search.filters = new Object(); // Reset global object to remove previous filters
    Cdp.search.filters.polygon = feature.geometry.toString();
    loadMyResults(Cdp.search);
    
}

// Precision is in map units
function showPointOnMap(lat, lon, precision, zoom_on_point_after) {
    var mypoint = new OpenLayers.LonLat(lon, lat).transform(map.displayProjection, map.projection);
    markers.addMarker(new OpenLayers.Marker(mypoint,getOlIcon()));
    
    // if we have a precision value, draw it on the precision layer
    if (precision && precision != 0) {
        var pt = new OpenLayers.Geometry.Point(mypoint.lon, mypoint.lat);

        var pol = OpenLayers.Geometry.Polygon.createRegularPolygon(pt,precision, 30, 0);
        
        feat = new OpenLayers.Feature.Vector(pol);
        precis.addFeatures([feat]);
    }

    if (zoom_on_point_after) {
        map.setCenter(mypoint);
    }
}


