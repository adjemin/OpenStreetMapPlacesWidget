# OpenStreetMapWidget

OpenStreetMapWidget allows you to add location picker and place autocompletion on your Flutter projet (Android and IOS).
It is based on [Nominatim Restful API](https://nominatim.openstreetmap.org)

![alt text](https://i.imgur.com/o9KKNv5l.jpg)
![alt text](https://i.imgur.com/wihYshZl.jpg)
![alt text](https://i.imgur.com/RYVuNFKl.jpg)


## Getting Started

Add the package into pubspec.yaml

```
dependencies:
   http: ^0.12.0+1
   diacritic: ^0.1.0
   flutter_map: ^0.9.0
   rxdart: ^0.23.1
   location: ^3.0.2
   progress_dialog: ^1.2.2
   json_annotation: ^3.0.0

dev_dependencies:
  build_runner: ^1.0.0
  json_serializable: ^3.0.0

flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/countries.json
    - assets/flags/

```
Don't forget to add this file **assets/countries.json** and this folder **assets/flags/** to your project.
Please Copy this packages **openstreetmap_places** and **util** to your lib folder.

Android
--------------------------------
And to use it in Android, you have to add this permission in android/app/src/main/AndroidManifest.xmlInfo.plist :
```
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

iOS
--------------------------------
And to use it in iOS, you have to add this permission in Info.plist :
```
NSLocationWhenInUseUsageDescription
NSLocationAlwaysUsageDescription
```



## Example
```
import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:open_street_map_widget/openstreetmap_places/OpenStreetMapPlacesWidget.dart';
import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';
import 'package:open_street_map_widget/util/country_picker/country.dart';



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController locationController = new TextEditingController();


  String address = "";

  // Location lastLocation;
  LatLng lastLocation;

  Country _currentCountry;

  @override
  void initState() {

    super.initState();

    _currentCountry = Country.CI;


  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text('OpenStreetMapWidget'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          padding: EdgeInsets.all(18.0),
          child: new Column(
            children: <Widget>[

              new InkWell(
                  onTap: (){

                    displayOpenStreetMapPlacesUI();
                    // displayGooglePlacesAutocompleteUI();

                  },
                  child: new Container(
                    padding: EdgeInsets.only(left:10.0, top:18.0, right: 10.0, bottom:18.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.location_on,color: Colors.pinkAccent ),
                        SizedBox(width: 10.0,),
                        (lastLocation == null)?
                        new Text("Emplacement", style: new TextStyle(color: Colors.black38, fontSize: 18.0),):
                        new Container(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: new Text(address, style: new TextStyle(color: Colors.black, fontSize: 18.0),),
                        )

                      ],
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  void displayOpenStreetMapPlacesUI() async{
    Place place = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
        new OpenStreetMapPlacesWidget()) );

    if(place != null){
      setState(() {
        address = place.title;

        lastLocation = new LatLng(double.parse(place.lat), double.parse(place.lon));
      });
    }
  }


}

```

Licences
--------
    Copyright 2020 Adjemin LTD.

    hello@adjemin.com

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.