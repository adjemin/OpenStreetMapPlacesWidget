# OpenStreetMapWidget

OpenStreetMapWidget allows you to add location picker and place autocompletion on your Flutter projet (Android and IOS).

![alt text](https://i.imgur.com/o9KKNv5l.jpg)
![alt text](https://i.imgur.com/wihYshZl.jpg)
![alt text](https://i.imgur.com/RYVuNFKl.jpg)


## Getting Started

### Step 1

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

## Example
```
      void displayOpenStreetMapPlacesUI() async{
        Place place = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
            new OpenStreetMapPlacesWidget()) );

        if(place != null){

            var address = place.title;

            var lastLocation = new LatLng(double.parse(place.lat), double.parse(place.lon));

        }
      }
```