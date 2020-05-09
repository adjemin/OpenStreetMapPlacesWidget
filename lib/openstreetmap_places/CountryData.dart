import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:open_street_map_widget/openstreetmap_places/CountryModel.dart';

class CountryData{

  static Future<List<CountryModel>> load(BuildContext context)async{

    String json = await DefaultAssetBundle.of(context).loadString("assets/countries.json");

    return (jsonDecode(json) as List).map((e) => CountryModel.fromJson(e as Map)).toList();

  }

  static Future<CountryModel> findByCode(BuildContext context, String isoCode)async{

    List<CountryModel> result = await load(context);

    return result.singleWhere((element) => element.country_code == isoCode.toUpperCase());

  }

}