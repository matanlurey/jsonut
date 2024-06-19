final class Blob {
  Blob({
    required this.metadata,
    required this.sensorData,
  });

  final Metadata metadata;
  final SensorData sensorData;
}

final class Metadata {
  Metadata({
    required this.timestamp,
    required this.version,
    required this.source,
    required this.location,
  });

  final DateTime timestamp;
  final String version;
  final String source;
  final Location location;
}

final class Location {
  Location({
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  final double latitude;
  final double longitude;
  final double altitude;
}

final class SensorData {
  SensorData({
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.lightIntensity,
    required this.acceleration,
  });

  final Temperature temperature;
  final double humidity;
  final double pressure;
  final int lightIntensity;
  final Acceleration acceleration;
}

final class Temperature {
  Temperature({
    required this.celcius,
    required this.fahrenheit,
  });

  final double celcius;
  final double fahrenheit;
}

final class Acceleration {
  Acceleration({
    required this.x,
    required this.y,
    required this.z,
  });

  final double x;
  final double y;
  final double z;
}
