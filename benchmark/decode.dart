// ignore_for_file: avoid_dynamic_calls, argument_type_not_assignable

import 'dart:convert' show jsonDecode;
import 'dart:io' as io;

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:jsonut/jsonut.dart';

import '_data.dart' as data;
import '_model.dart' as model;

final class CastDartDecode extends BenchmarkBase {
  CastDartDecode() : super('CastDartDecode');

  late Map<String, Object?> object;
  late model.Blob blob;

  @override
  void setup() {
    object = jsonDecode(data.json) as Map<String, Object?>;
  }

  @override
  void run() {
    final metadata = object['metadata'] as Map<String, Object?>;
    final location = metadata['location'] as Map<String, Object?>;
    final sensorData = object['sensor_data'] as Map<String, Object?>;
    final temparature = sensorData['temperature'] as Map<String, Object?>;
    final acceleration = sensorData['acceleration'] as Map<String, Object?>;

    blob = model.Blob(
      metadata: model.Metadata(
        timestamp: DateTime.parse(metadata['timestamp'] as String),
        version: metadata['version'] as String,
        source: metadata['source'] as String,
        location: model.Location(
          latitude: location['latitude'] as double,
          longitude: location['longitude'] as double,
          altitude: location['altitude'] as double,
        ),
      ),
      sensorData: model.SensorData(
        temperature: model.Temperature(
          celcius: temparature['celsius'] as double,
          fahrenheit: temparature['fahrenheit'] as double,
        ),
        humidity: sensorData['humidity'] as double,
        pressure: sensorData['pressure'] as double,
        lightIntensity: sensorData['light_intensity'] as int,
        acceleration: model.Acceleration(
          x: acceleration['x'] as double,
          y: acceleration['y'] as double,
          z: acceleration['z'] as double,
        ),
      ),
    );
  }

  @override
  void teardown() {
    _preventOpt(blob);
  }
}

final class DynamicDartDecode extends BenchmarkBase {
  DynamicDartDecode() : super('DynamicDartDecode');

  late dynamic object;
  late model.Blob blob;

  @override
  void setup() {
    object = jsonDecode(data.json);
  }

  @override
  void run() {
    final metadata = object['metadata'];
    final location = metadata['location'];
    final sensorData = object['sensor_data'];
    final temparature = sensorData['temperature'];
    final acceleration = sensorData['acceleration'];

    blob = model.Blob(
      metadata: model.Metadata(
        timestamp: DateTime.parse(metadata['timestamp']),
        version: metadata['version'],
        source: metadata['source'],
        location: model.Location(
          latitude: location['latitude'],
          longitude: location['longitude'],
          altitude: location['altitude'],
        ),
      ),
      sensorData: model.SensorData(
        temperature: model.Temperature(
          celcius: temparature['celsius'],
          fahrenheit: temparature['fahrenheit'],
        ),
        humidity: sensorData['humidity'],
        pressure: sensorData['pressure'],
        lightIntensity: sensorData['light_intensity'],
        acceleration: model.Acceleration(
          x: acceleration['x'],
          y: acceleration['y'],
          z: acceleration['z'],
        ),
      ),
    );
  }

  @override
  void teardown() {
    _preventOpt(blob);
  }
}

void _preventOpt(model.Blob blob) {
  final dir = io.Directory.systemTemp.createTempSync();
  final file = io.File('${dir.path}${io.Platform.pathSeparator}blob.txt');
  file.writeAsStringSync(
    [
      blob.metadata.timestamp,
      blob.metadata.version,
      blob.metadata.source,
      blob.metadata.location.latitude,
      blob.metadata.location.longitude,
      blob.metadata.location.altitude,
      blob.sensorData.temperature.celcius,
      blob.sensorData.temperature.fahrenheit,
      blob.sensorData.humidity,
      blob.sensorData.pressure,
      blob.sensorData.lightIntensity,
      blob.sensorData.acceleration.x,
      blob.sensorData.acceleration.y,
      blob.sensorData.acceleration.z,
    ].join(),
  );
  file.deleteSync();
  dir.deleteSync(recursive: true);
}

final class JsonutDecode extends BenchmarkBase {
  JsonutDecode() : super('JsonutDecode');

  late JsonObject object;
  late model.Blob blob;

  @override
  void setup() {
    object = JsonObject.parse(data.json);
  }

  @override
  void run() {
    blob = object.convert((b) {
      return model.Blob(
        metadata: b['metadata'].object().convert((b) {
          return model.Metadata(
            timestamp: DateTime.parse(b['timestamp'].string()),
            version: b['version'].as(),
            source: b['source'].as(),
            location: b['location'].object().convert((b) {
              return model.Location(
                latitude: b['latitude'].as(),
                longitude: b['longitude'].as(),
                altitude: b['altitude'].as(),
              );
            }),
          );
        }),
        sensorData: b['sensor_data'].object().convert((b) {
          return model.SensorData(
            temperature: b['temperature'].object().convert((b) {
              return model.Temperature(
                celcius: b['celsius'].as(),
                fahrenheit: b['fahrenheit'].as(),
              );
            }),
            humidity: b['humidity'].as(),
            pressure: b['pressure'].as(),
            lightIntensity: b['light_intensity'].as(),
            acceleration: b['acceleration'].object().convert((b) {
              return model.Acceleration(
                x: b['x'].as(),
                y: b['y'].as(),
                z: b['z'].as(),
              );
            }),
          );
        }),
      );
    });
  }

  @override
  void teardown() {
    _preventOpt(blob);
  }
}

void main() {
  CastDartDecode().report();
  DynamicDartDecode().report();
  JsonutDecode().report();
}
