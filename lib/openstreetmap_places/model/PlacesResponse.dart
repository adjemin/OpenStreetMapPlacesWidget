import 'dart:convert';

import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';

class PlacesResponse{

  final List<Place> data;

  const PlacesResponse(this.data);

  static PlacesResponse fromJson(String json){

    List list =  jsonDecode(json);

    if(list == null){

     list = [];

    }

    return new PlacesResponse(list.map((e) => Place.fromJson(e as Map)).toList());

  }


}