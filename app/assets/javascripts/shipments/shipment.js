var Map = {};
Map.latitude = -34.8804869;
Map.longitude = -56.1341587;
Map.markers = [];
Map.pointsSelected = false;
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
            
            if (Map.markers.length<2) {
                if (Map.markers.length==0) {
                    $('#origin_lat').val(marker.position.lat);
                    $('#origin_lng').val(marker.position.lng);
                } else {
                    $('#destiny_lat').val(marker.position.lat);
                    $('#destiny_lng').val(marker.position.lng);
                    
                    var a =Map.markers[0].position.lat;
                    var b  = Map.markers[0].position.lng;
                    new google.maps.Polyline({
                        path: [
                            new google.maps.LatLng(Map.markers[0].position.lat, Map.markers[0].position.lng), 
                            new google.maps.LatLng(marker.position.lat, marker.position.lng)
                        ],
                        strokeColor: "#FF0000",
                        strokeOpacity: 1.0,
                        strokeWeight: 10,
                        map: map
                    });
                }
                Map.markers.push(marker);
            }        
        }
    });
    
    $("#submit_button").on({
        "click" : function(){
            if ($.trim($('#shipment_receiver_email').val()) != '') {
                if ($("#shipment_receiver_pays").is(":checked") || $("#shipment_sender_pays").is(":checked")) {
                    if (Map.markers.length==2) {
                        $("form").submit();     
                    } else {
                        Map.alert("Select origin and destiny points")
                    }
                } else {
                    Map.alert('Someone has to pay');
                }
            } else {
                Map.alert("Complete receiver email");
            }
                 
        }
    });
    
});

Map.alert = function(errorMessage){
    $('#error_message').css("display","block");
    $('#error_message').text(errorMessage);
};
