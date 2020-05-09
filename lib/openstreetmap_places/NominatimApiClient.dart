import 'package:http/http.dart' as http;
import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';
import 'dart:convert';

import 'package:open_street_map_widget/openstreetmap_places/model/PlacesResponse.dart';

class NominatimApiClient{


  static final String BASE_API_URL = "https://nominatim.openstreetmap.org";

  static Future<PlacesResponse> searchPlaces(String query, String countrycodes, [int limit = 100] )async{

    final String q = query == null ? "" : query.toLowerCase();
    final String countryCode = countrycodes.toLowerCase();

    final String url = "$BASE_API_URL/search?q=$q&countrycodes=$countryCode&format=json&addressdetails=1&limit=$limit";

    final http.Response response = await http.get(url);

    if(response.statusCode == 200){
      final String jsonString  = response.body;

      print("RESULT >> $jsonString");

      return PlacesResponse.fromJson(jsonString);
    }else{
      throw response;
    }

  }

  static Future<Place> findPlacesByLocation(String latitude, String longitude, [String zoom = "18"] )async{

    final String url = "$BASE_API_URL/reverse?format=json&lat=$latitude&lon=$longitude&zoom=$zoom&addressdetails=1";

    final http.Response response = await http.get(
        url
    );

    if(response.statusCode == 200){

      final Map jsonMap = jsonDecode(response.body);
      if(jsonMap.containsKey('error')){
        throw response;
      }else if(jsonMap.containsKey('place_id')){
        return Place.fromJson(jsonMap);
      }else{
        throw response;
      }
    }else{
      throw response;
    }

  }

}