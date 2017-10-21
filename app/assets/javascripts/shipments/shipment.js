var Map = {};
Map.latitude = -34.8804869;
Map.longitude = -56.1341587;
Map.markers = [];
$(document).ready(function () {
    var mapCanvas = document.getElementById('map');
    var mapOptions = {
        draggable: true,
        scrollwheel: false,
        center: new google.maps.LatLng(Map.latitude, Map.longitude),
        zoom: 13
    };
    var map = new google.maps.Map(mapCanvas, mapOptions);

    google.maps.event.addListener(map, 'click', function (event) {
        if (Map.markers.length<2){
            var name = Map.markers.length == 0 ? 'Origin' : 'Destiny';
            var marker = new google.maps.Marker({
                position: event.latLng,
                map: map,
                title: name
            });
            
            google.maps.event.addListener(marker , 'click', function(){
              var infowindow = new google.maps.InfoWindow({
                content:marker.title,
                position: marker.position,
              });
            infowindow.open(map);  
            });
            
            Map.markers.push(marker);
        }
    });
    
    

});
