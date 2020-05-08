import 'package:http/http.dart' as http;
import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';
import 'dart:convert';

import 'package:open_street_map_widget/openstreetmap_places/model/PlacesResponse.dart';

class NominatimApiClient{


  static final String BASE_API_URL = "https://nominatim.openstreetmap.org";

  static Future searchPlaces(String query, String countrycodes, [int limit = 100] )async{

    String q = query == null ? "" : query.toLowerCase();
    String countryCode = countrycodes.toLowerCase();

    String url = "$BASE_API_URL/search?q=$q&countrycodes=$countryCode&format=json&addressdetails=1&limit=${limit >0 ?limit: 100 }";

    var response = await http.get(
        url
    );

    if(response.statusCode == 200){
      String jsonString  = response.body;

      print("RESULT >> $jsonString");

      return PlacesResponse.fromJson(jsonString);
    }else{
      return response;
    }

  }

  static Future findPlacesByLocation(String latitude, String longitude, [String zoom = "18"] )async{

    String url = "$BASE_API_URL/reverse?format=json&lat=$latitude&lon=$longitude&zoom=$zoom&addressdetails=1";

    var response = await http.get(
        url
    );

    if(response.statusCode == 200){
      String jsonString  = response.body;
      Map jsonMap = jsonDecode(jsonString);
      if(jsonMap.containsKey('error')){
        return response;
      }else if(jsonMap.containsKey('place_id')){
        return Place.fromJson(jsonMap);
      }else{
        return response;
      }
    }else{
      return response;
    }

  }

}