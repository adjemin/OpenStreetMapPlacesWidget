class CountryModel{
  final String name;
  final String country_code;
  final String capital;
  final List<double> latlng;

  final List<String> timezones;

  const CountryModel(this.name, this.country_code, this.capital, this.latlng,
      this.timezones);

  static CountryModel fromJson(Map map){
    return new CountryModel(
        map['name'] as String,
        map['country_code'] as String,
        map['capital'] as String,
        (map['latlng'] as List) == null ? []: (map['latlng'] as List).map((e) => double.parse(e.toString())).toList(),
        (map['timezones'] as List) == null ? []: (map['timezones'] as List).map((e) => e as String).toList()
     );
  }




}