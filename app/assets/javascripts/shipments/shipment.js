var Map = {};
Map.latitude = -34.8804869;
Map.longitude = -56.1341587;
Map.markers = [];
$(document).ready(function () {
    $('#shipment_receiver_email').on('keyup',function(e){
        $(this).css("background","#FFF url(/images/LoaderIcon.gif) no-repeat 165px");

        delay(function(){
            searchUser($('#shipment_receiver_email').val());
        }, 200);

    });
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

function searchUser(text){
    var myObject = new Object();
    myObject.receiverEmail = text;
    $.ajax({
            type: "POST", 
            url: "https://enviosya-aguspazos.c9users.io/users/search",
            async: false,
            contentType: "application/json",
             data: JSON.stringify(myObject),
            success: function (response) {
			    $("#suggesstion-box").empty();

			    $("#shipment_receiver_email").css("background","#FFF");
			    for(var i = 0;i<response.length;i++){
			        var user = response[i];
    			    if(user.email !== undefined){
        			    $("#suggesstion-box").show();
        			    $("#suggesstion-box").append("<div class='suggesstion'>" + user.email + "</div>");
    			        $('.suggesstion').on('click',function(e){
                            setMail($(this).html());
                        });
    			    }
			    }

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
