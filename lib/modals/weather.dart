class WeatherData {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  int localtimeEpoch;
  String localtime;

  String lastUpdated;
  int lastUpdatedEpoch;
  double tempC;
  double tempF;
  double feelsLikeC;
  double feelsLikeF;
  
  String conditionText;
  String conditionIcon;
  int conditionCode;

  double windMph;
  double windKph;
  int windDegree;
  String windDir;
  double pressureMb;
  double pressureIn;
  double precipMm;  
  double precipIn;
  int humidity;
  int cloud;
  double visKm;
  double visMiles;
  int isDay;
  double uvIndex;
  double gustMph;
  double gustKph;

  WeatherData.fromJson(Map<String, dynamic> json){
  lat = json['location']['lat'];
  lon = json['location']['lon'];
  name = json['location']['name'];
  region = json['location']['region'];
  country = json['location']['country'];
  tzId = json['location']['tz_id'];
  localtimeEpoch = json['location']['localtime_epoch'];
  localtime = json['location']['localtime'];

  lastUpdatedEpoch = json['current']['last_updated_epoch'];
  lastUpdated = json['current']['last_updated'];
  tempC = json['current']['temp_c'];
  tempF = json['current']['temp_f'];
  isDay = json['current']['is_day'];

  conditionText = json['current']['condition']['text'];
  conditionIcon = json['current']['condition']['Icon'];
  conditionCode = json['current']['condition']['code'];

  windMph = json['current']['wind_mph'];
  windKph = json['current']['wind_kph'];
  windDegree = json['current']['wind_degree'];
  windDir = json['current']['wind_dir'];
  pressureMb = json['current']['pressure_mb'];
  pressureIn = json['current']['pressure_in'];
  precipMm = json['current']['precip_mm'];
  precipIn = json['current']['precip_in'];
  humidity = json['current']['humidity'];
  cloud = json['current']['cloud'];
  feelsLikeC = json['current']['feelslike_c'];
  feelsLikeF = json['current']['feelslike_f'];
  visKm = json['current']['vis_km'];
  visMiles = json['current']['vis_miles'];
  uvIndex = json['current']['uv'];
  gustMph = json['current']['gust_mph'];
  gustKph = json['current']['gust_kph'];
  }
}