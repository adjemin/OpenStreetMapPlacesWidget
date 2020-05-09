
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:open_street_map_widget/openstreetmap_places/CountryData.dart';
import 'package:open_street_map_widget/openstreetmap_places/CountryModel.dart';
import 'package:open_street_map_widget/openstreetmap_places/NominatimApiClient.dart';
import 'package:open_street_map_widget/openstreetmap_places/OpenStreetMapPlacesAutoCompleteWidget.dart';
import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';

import '../util/country_picker/flutter_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../util/country_picker/flutter_country_picker.dart';

class OpenStreetMapPlacesWidget extends StatefulWidget {

  @override
  _OpenStreetMapPlacesWidgetState createState() => _OpenStreetMapPlacesWidgetState();


}

class _OpenStreetMapPlacesWidgetState extends State<OpenStreetMapPlacesWidget> {

  Country _currentCountry;
  LatLng _latLng;

  Place _currentPlace;

  ProgressDialog pr;

  MapController  _mapController =  new MapController();

  @override
  void initState() {
    super.initState();

    _currentCountry = Country.CI;

    _latLng  = new LatLng(5.3637543, -3.9028943);

    pr = new ProgressDialog(context);

    pr.style(
        message: 'Chargement...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
    );

    Timer.run(()async {

      loadCountryLocation(true);

    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new FlutterMap(
            mapController: _mapController,
            options: new MapOptions(
              center:  _latLng,
              onPositionChanged: (MapPosition mapPosition, bool value){

              },
              onLongPress: (LatLng position){

                print('onLongPress >>> $position');

                if(position != null && mounted){
                  setState(() {

                    _latLng = position;
                    print('Upadate maker $_latLng');
                    _mapController.move(_latLng, 17.0);

                    findPlaceByLocation(_latLng);

                  });
                }

              },

              zoom: 14.0,
            ),
            layers: [
              new TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _latLng,
                    builder: (ctx) =>
                    new Container(
                      child: new Icon(Icons.location_on, size: 80, color: Theme.of(context).primaryColorDark,),
                    ),
                  ),
                ],
              ),
            ],
          ),
          new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.all(50.0),
                child: new InkWell(
                  onTap: ()async{

                    final Country picked = await showCountryPicker(
                      context: context,
                      defaultCountry: _currentCountry,
                    );

                    if(picked != null && mounted){
                      setState(() {
                        _currentCountry = picked;
                      });

                      loadCountryLocation(false);
                    }


                  },
                  child:new Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    padding: EdgeInsets.all(10.0),
                    child:  new Row(
                      children: <Widget>[

                        Image.asset(
                          _currentCountry.asset,
                          height: 25.0,
                          fit: BoxFit.fitWidth,
                        ),
                        new SizedBox(width: 10.0),
                        new Expanded(child: new Text(_currentCountry.name,  overflow: TextOverflow.ellipsis)),
                        new SizedBox(width: 10.0),
                        new Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.grey.shade700
                                : Colors.white70),

                      ],
                    ),
                  ),
                ),
              ),
              new Expanded(child: new Container()),
              new Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(20.0),

                child: new InkWell(
                  onTap: (){

                    findCurrentLocation();

                  },
                  child: new Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    child: Icon(Icons.my_location, color: Colors.black,size: 36.0,),
                  ),
                ),
              ),
              new Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3))
                      ),
                      child: InkWell(
                        onTap: ()async{
                          Place place  = await Navigator.push(context, new MaterialPageRoute(builder: (context)=> new OpenStreetMapPlacesAutoCompleteWidget(_currentCountry)));
                          if(place != null && mounted){
                            setState(() {
                              _currentPlace = place;

                              _latLng= new LatLng(double.parse(place.lat), double.parse(place.lon));
                              print('Upadate maker $_latLng');
                              _mapController.move(_latLng, 17.0);

                            });
                          }
                        },
                        child: new Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            new SizedBox(width: 10.0,),
                            Expanded(child: new Text(_currentPlace == null? "Rechercher un lieu" : _currentPlace.title, style: TextStyle(fontSize: 18.0, ),))
                          ],
                        ),
                      ),
                    ),
                    new SizedBox(height: 20.0,),
                    new Container(
                      width: double.infinity,
                      child: new RaisedButton(onPressed: (){

                        Navigator.pop(context, _currentPlace);

                      },
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: new Text("Terminer",style: new TextStyle(fontSize: 18.0), ),
                          ),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0),side: BorderSide(color: Theme.of(context).accentColor))


                      ),
                    )

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void findCurrentLocation()async {

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if(_locationData != null && mounted){
      setState(() {

        _latLng= new LatLng(_locationData.latitude, _locationData.longitude);
        print('Upadate maker $_latLng');
        _mapController.move(_latLng, 14.0);

        findPlaceByLocation(_latLng);

      });
    }

  }

  void showProgressDialog()async{
    await pr.show();
  }

  void hideProgressDialog()async{
    await pr.hide();
  }
  void findPlaceByLocation(LatLng latLng){

    showProgressDialog();

    NominatimApiClient.findPlacesByLocation(latLng.latitude.toString(), latLng.longitude.toString())
        .then((Place value){

          hideProgressDialog();

          if(mounted){
            setState(() {
              _currentPlace = value;
              _currentCountry = Country.findByIsoCode((value.address['country_code'] as String).toUpperCase());
            });
          }

    }).catchError((error){

      print('Error $error');

      hideProgressDialog();



    });

  }

  void loadCountryLocation(bool isInit) async{

    if(isInit){


      findCurrentLocation();

    }else{

      CountryModel countryModel = await CountryData.findByCode(context, _currentCountry.isoCode);

      if(countryModel != null){
        List<double> list = countryModel.latlng;
        _latLng  = new LatLng(list.first, list.last);

        _mapController.move(_latLng, 17.0);

        findPlaceByLocation(_latLng);
      }

    }



  }


}
