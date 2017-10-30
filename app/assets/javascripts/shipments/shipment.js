var Map = {};
Map.latitude = -34.8804869;
Map.longitude = -56.1341587;
Map.origin_marker;
Map.destiny_marker;
Map.origin_polygon;
Map.destiny_polygon;
Map.pointsSelected = false;
Map.markers_count = 0;
Map.zone_price = 0;
Map.price_per_kilo = 0;
Map.price_per_zone_real = false;

$(document).ready(function () {
    $('#shipment_receiver_email').on('keyup',function(e){
        $(this).css("background","#FFF url(/images/LoaderIcon.gif) no-repeat 165px");

        delay(function(){
            searchUser($('#shipment_receiver_email').val());
        }, 200);

    });
    
    Map.request_cost();

    var mapCanvas = document.getElementById('map');
    var mapOptions = {
        draggable: true,
        scrollwheel: false,
        center: new google.maps.LatLng(Map.latitude, Map.longitude),
        zoom: 13
    };
    var map = new google.maps.Map(mapCanvas, mapOptions);
    Map.map = map;
    
    google.maps.event.addListener(map, 'click', function (event) {
        if (Map.markers_count<2){
            var is_origin = Map.markers_count == 0 ;
            var name = is_origin ? 'Origin' : 'Destiny';
            var marker = new google.maps.Marker({
                position: event.latLng,
                title: name
            });
            marker.setMap(Map.map);
            if (is_origin) {
                Map.origin_marker = marker;
                Map.markers_count++;
                $('#origin_lat').val(marker.position.lat);
                $('#origin_lng').val(marker.position.lng);
            } else {
                Map.destiny_marker = marker;
                Map.markers_count++;
                $('#destiny_lat').val(marker.position.lat);
                $('#destiny_lng').val(marker.position.lng);
                Map.calculate_price(Map.origin_marker.position, marker.position);
            } 
            google.maps.event.addListener(marker , 'click', function(){
                var infowindow = new google.maps.InfoWindow({
                    content:marker.title,
                    position: marker.position,
                });
                infowindow.open(Map.map);  
            });
        }
    });
    
    $("#submit_button").on({
        "click" : function(){
            if ($.trim($('#shipment_receiver_email').val()) != '') {
                if ($("#shipment_receiver_pays").is(":checked") || $("#shipment_sender_pays").is(":checked")) {
                    if (Map.markers_count==2) {
                        if ($.trim($('#weight').val() != '')) {
                            var is_final_price = Map.price_per_zone_real;
                            var weight = Number($('#weight').val());
                            var price = (Map.price_per_kilo * weight) + Map.zone_price;
                            var final_price = is_final_price? price : 0;
                            $('#price').val(price);
                            $('#final_price').val(final_price);
                            $("form").submit();         
                        } else {
                            Map.alert("Complete package weight");
                        }
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
    
    $('#request_cost').on({
        "click" : function(){
            Map.request_cost();
        }
    });
    
    $('#remove_markers').on({
        "click" : function(){
            Map.remove_markers();
            Map.remove_polygons();
            Map.markers_count = 0;
        }
    });
});

Map.request_cost = function(){
    $.ajax({
        type: "POST", 
        url: "https://enviosyaarqsoftpr2017s2.mybluemix.net/shipments/get_cost",
        success: function (response) {
            if (response.status == 'ok') {
                $('.loader').css('display','none');
                if (response.estimated == 'true') {
                    $('#price_per_kilo').text('Price per kilo estimated: $'+response.cost);
                    Map.price_per_kilo = response.cost;
                } else {
                    $('#price_per_kilo').text('Price per kilo: $'+response.cost);
                    Map.price_per_kilo = response.cost;
                }
            } else {
                Map.price_per_kilo = 30;
                alert('Something went wrong');
            }
        }, 
        error: function(){
            Map.price_per_kilo = 30;
        }
    });  
};

Map.remove_markers = function(){
    if (Map.origin_marker) {
        Map.origin_marker.setMap(null);
        Map.destiny_marker.setMap(null);
    }
    if (Map.destiny_marker) {
        Map.origin_marker = null;
        Map.destiny_marker = null;
    }
};

Map.remove_polygons = function(){
    if (Map.origin_polygon) {
        Map.origin_polygon.setMap(null);
        Map.origin_polygon = null;
    }
    if (Map.destiny_polygon) {
        Map.destiny_polygon.setMap(null);
        Map.destiny_polygon = null;    
    }
};

Map.calculate_price = function(origin, destiny){
    $.ajax({
        type: "POST", 
        url: "https://enviosyaarqsoftpr2017s2.mybluemix.net/shipments/calculate_price",
        data: {'origin_lat': (origin.lat), 'origin_lng': (origin.lng), 'destiny_lat': (destiny.lat), 'destiny_lng': (destiny.lng)},
        success: function (response) {
            if (response.status == 'ok') {
                if (response.origin_area.length > 0 && response.destiny_area.length > 0) {
                    var origin_area = new google.maps.Polygon({
                      paths: response.origin_area,
                      strokeColor: '#FF0000',
                      strokeOpacity: 0.8,
                      strokeWeight: 3,
                      fillColor: '#FF0000',
                      fillOpacity: 0.35
                    });
                    var destiny_area = new google.maps.Polygon({
                      paths: response.destiny_area,
                      strokeColor: '#FF0000',
                      strokeOpacity: 0.8,
                      strokeWeight: 3,
                      fillColor: '#FF0000',
                      fillOpacity: 0.35
                    });
                    origin_area.setMap(Map.map);
                    destiny_area.setMap(Map.map);
                    Map.origin_polygon = origin_area;
                    Map.destiny_polygon = destiny_area;
                    $('#price_zone_label').text('Zone Price: $'+(response.price? response.price : 0));
                    Map.zone_price = response.price;
                    Map.price_per_zone_real = true;
                } else {
                    $('#price_zone_label').text('Zone Price Estimated: $30');    
                    Map.price_per_zone_real = false;
                }
                
            } else {
                Map.price_per_zone_real = false;
            }
        }, 
        error: function(){
            console.log('error request zone');
            Map.price_per_zone_real = false;
        }
    });
};

function searchUser(text){
    var myObject = new Object();
    myObject.receiverEmail = text;
    $( "#shipment_receiver_email" ).autocomplete()
    $.ajax({
            type: "POST", 
            url: "https://enviosyaarqsoftpr2017s2.mybluemix.net/users/search",
            async: false,
            contentType: "application/json",
            data: JSON.stringify(myObject),
            success: function (response) {
			    $("#suggesstion-box").empty();

			    $("#shipment_receiver_email").css("background","#FFF");
			    var options = [];
			    for(var i = 0;i<response.length;i++){
			        var user = response[i];
    			    if(user.email !== undefined){
    			        options.push(user.email);
    			    }
			    }
			    $( "#shipment_receiver_email" ).autocomplete({
			        source: options,
			        scroll: true,
			           messages: {
                        noResults: '',
                        results: function() {}
                    }

                 });

            }
    });
};

var setMail = function(text){
    $("#shipment_receiver_email").val(text);
    $("#suggesstion-box").hide();

    
};
var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

Map.alert = function(errorMessage){
    $('#error_message').css("display","block");
    $('#error_message').text(errorMessage);
};

