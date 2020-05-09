class Place{

  final int place_id;
  final int osm_id;
  final String osm_type;
  final String licence;
  final String lat;
  final String lon;
  final String display_name;
  final String class_entity;
  final String type; //college, university, pharmacy, residential, city_gate
  final double importance;
  final String icon;
  /**
   *
   *"address": {
      "college": "Ecole Supérieure Polytechnique",
      "road": "rue FN-32",
      "suburb": "Fann Hock",
      "city": "Dakar",
      "region": "Dakar",
      "postcode": "B.P. 5085 DAKAR-FANN",
      "country": "Sénégal",
      "country_code": "sn",
      "neighbourhood": "Akoué Santé",
      "hamlet": "Abatta",
      "village": "Mobio",
      "town": "Bingerville",
      }
   *
   *
   */
  final  Map address;

  final List<String> boundingbox;


  const Place(this.place_id, this.osm_id, this.osm_type, this.licence, this.lat,
      this.lon, this.display_name, this.class_entity, this.type,
      this.importance, this.icon, this.address, this.boundingbox);

  static Place fromJson(Map map){
    return new Place(
        map['place_id'] as int,
        map['osm_id'] as int,
        map['osm_type'] as String,
        map['licence'] as String,
        map['lat'] as String,
        map['lon'] as String,
        map['display_name'] as String,
        map['class'] as String,
        map['type'] as String,
        map['importance'] as double,
        map['icon'] as String,
        map['address'] as Map,
        (map['boundingbox'] as List) !=null ? (map['boundingbox'] as List).map((e) => e as String).toList() : []
    );
  }

  String get title {

    if(display_name == null){
      return "";
    }

    if(display_name.isEmpty){
      return "";
    }

    String element = display_name.split(',').first;
    return element;
  }

  String get subtitle {

    if(display_name == null){
      return "";
    }

    if(display_name.isEmpty){
      return "";
    }

    //String first_element = display_name.split(',').last;
    int firstCommaIndex = display_name.indexOf(',')+1;

    String element = display_name.substring(firstCommaIndex, display_name.length);
    if(element != null){
      return element.trim();
    }else{
      return "";
    }
  }






}