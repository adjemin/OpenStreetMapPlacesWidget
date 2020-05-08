import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_street_map_widget/util/country_picker/country.dart';
import 'package:rxdart/rxdart.dart';
import 'package:open_street_map_widget/openstreetmap_places/NominatimApiClient.dart';
import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';
import 'package:open_street_map_widget/openstreetmap_places/model/PlacesResponse.dart';

class OpenStreetMapPlacesAutoCompleteWidget extends StatefulWidget {

  Country _currentCountry;


  OpenStreetMapPlacesAutoCompleteWidget(this._currentCountry);

  @override
  _OpenStreetMapPlacesAutoCompleteWidgetState createState() => _OpenStreetMapPlacesAutoCompleteWidgetState();
}

class _OpenStreetMapPlacesAutoCompleteWidgetState extends State<OpenStreetMapPlacesAutoCompleteWidget> {


  TextEditingController _queryTextController = new TextEditingController();

  bool _searching;
  bool hasError;

  List<Place> locationResults = [];

  final _queryBehavior = BehaviorSubject<String>();

  String countryCode = 'ci';

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController(text: "");

    countryCode = widget._currentCountry.isoCode.toLowerCase();

    _searching = false;

    _queryTextController.addListener(_onQueryChange);

    _queryBehavior.stream
        .debounceTime( const Duration(milliseconds: 300))
        .listen(search);
  }

  void _onQueryChange() {


    _queryBehavior.add(_queryTextController.text);


  }

  @override
  void dispose() {
    super.dispose();
    _queryBehavior.close();
    _queryTextController.removeListener(_onQueryChange);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar:new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: new Text("Rechercher un lieu", style: new TextStyle(color: Colors.white),),
          centerTitle: false,
        ) ,
        body: new Column(
          children: <Widget>[
            new Container(
              height: 50.0,
              child: new TextField(
                autofocus: true,
                controller: _queryTextController,

                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Sasisir un lieu ici',
                    hintStyle: new TextStyle(color: Colors.grey,),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.add_location, color: Theme.of(context).accentColor,),
                    suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: (){
                      _queryTextController.clear();

                    })
                ),

                style: new TextStyle(color: Colors.black, fontSize: 18.0),
                keyboardType:  TextInputType.text,
              ),
            ),
            new Container(
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 20.0 ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0))

              ),
            ),

            new SizedBox(height: 10.0,),
            new Expanded(
              child: _searching ? progressView(): new ListView(
                children: locationResults == null? <Widget>[]:locationResults.map((Place p){
                  return ListTile(
                    title: new Text(p.title, style: new TextStyle(color: Colors.black,  fontSize: 18.0)),
                    subtitle: new Text(p.subtitle, style: new TextStyle(color: Colors.grey, fontSize: 16.0)),
                    trailing: new Icon(Icons.keyboard_arrow_right,size: 18.0, color: Colors.black),
                    onTap: (){

                      Navigator.pop(context, p);

                    },
                  );
                }).toList(),
              ),
            ),


          ],
        ),

    );
  }

  Widget progressView(){
    return new Stack(
      children: [
        new Container(
          color: Colors.white,
        ),
        new Container(
          color: Colors.white,
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
  }

  search(String query){

    if (mounted && query.isNotEmpty) {

      setState(() {
        _searching = true;
      });


      NominatimApiClient.searchPlaces(query, countryCode)
          .then((value){

        if(value != null && value is Response){
          hasError = true;
        }

        if(value != null && value is PlacesResponse){

          if(mounted){
            setState(() {
              locationResults = value.data;
              _searching = false;
            });
          }
        }

      }).catchError((error){

        print('Error $error');



        if(mounted){

          setState(() {
            hasError = true;
            locationResults = null;
            _searching = false;


          });
        }


      });
    }

  }

}
