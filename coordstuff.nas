# Coord stuff
# code inspired from f16 

var coordsetup = func(lat,lon,alt) {
    var coord = geo.Coord.new();
    var gndelev = alt*FT2M;
  
    print("coord: lat:" ~ lat);
    print("coord: lon:" ~ lon);
    print("coord: alt:" ~ alt);
  
    if (gndelev <= 0) {
        gndelev = geo.elevation(lat, lon);
       if (gndelev != nil){
            print("gndelev: " ~ gndelev);
        }
       if (gndelev == nil){
            # oh no
            gndelev = 0;
        }
    }
    coord.set_latlon(lat, lon, gndelev);
    return coord;
}

# Sender

var send = func(coord=nil){ # Unless given, coord is nil
    if (coord != nil){
        datalink.send_data({"point": coord});
    } else{
    var lat = getprop("position/latitude-deg");
    var lon = getprop("position/longitude-deg");
    var alt = getprop("position/altitude-ft");
    var data = geo.Coord.new;
    data.set_latlon(lat, lon, alt);
    datalink.send_data({"point": data});
    }
}   



# send(coordsetup());
# send();
# send();


# data link loop

var is_sending = nil;
var data = nil;
var dlink_loop = func {
    if (getprop("instrumentation/datalink/data") != 0) {
        return;
    }
    data = datalink.get_data(callsign);
    if (data != nil and data.on_link()){
        var coord = data.point();
        if (coord != nil) {
            sending = nil;
            var reclat = data.lat();
            var reclon = data.lon();
            var recalt = data.alt()*M2FT;
            # Data recived. now we do somthing with it here...



        }
    }
}

var timer = maketimer(3.5, dlink_loop);
timer.start();
