function occurrenceMap(latitude, longitude, precision) {
    var occ_map = new OpenLayers.Map('map', common_map_options)
    occ_map.addLayers(map_backgrounds);

    var occ_markers = new OpenLayers.Layer.Markers("Markers", {displayInLayerSwitcher: false});
    var precis = new OpenLayers.Layer.Vector("Results precision", {styleMap: styleMap_precision, displayInLayerSwitcher: false});

    icon = getOlIcon();
    mypoint = new OpenLayers.LonLat(longitude, latitude).transform(occ_map.displayProjection, occ_map.projection);
    occ_markers.addMarker(new OpenLayers.Marker(mypoint,icon));

    occ_map.addLayers([precis,occ_markers]);
    
    occ_map.setBaseLayer(map_backgrounds[1]);

    if (precision && precision != 0) {
        var pt = new OpenLayers.Geometry.Point(mypoint.lon, mypoint.lat);

        var pol = OpenLayers.Geometry.Polygon.createRegularPolygon(pt,precision, 30, 0);

        feat = new OpenLayers.Feature.Vector(pol);
        precis.addFeatures([feat]);
    }

    occ_map.setCenter(mypoint, 7);
    
}


