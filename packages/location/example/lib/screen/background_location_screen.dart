import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:location/location.dart';

class BackgroundSerivePage extends StatefulWidget {
  const BackgroundSerivePage({super.key});

  @override
  State<BackgroundSerivePage> createState() => _BackgroundSerivePageState();
}

class _BackgroundSerivePageState extends State<BackgroundSerivePage> {
  @override
  void initState() {
    super.initState();
    initializeBackgroundService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: FlutterBackgroundService().on('update'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Getting current location...'),
              );
            }

            final data = snapshot.data!;
            final dynamic lat = data['lat'];
            final dynamic lng = data['lng'];
            return Center(
              child: Text(
                "Current Location: ${lat ?? 'N/A'} ,  ${lng ?? 'N/A'}",
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onBackStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onBackStart,
      onBackground: iosOnBackground,
    ),
  );
  await service.startService();
  log('Service started!!');
}

@pragma('vm:entry-point')
Future<bool> iosOnBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
Future<void> onBackStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 20), (timer) async {
    LocationData? _location;

    if (service is AndroidServiceInstance) {
      await service.setAsForegroundService().then((value) {
        log('Foreground service');
      });
      await service.setAsBackgroundService().then(
        (value) {
          log('Background service here');
        },
      );

      _location = await getLocation(
        settings: LocationSettings(ignoreLastKnownPosition: true),
      );
    }
    service.invoke('update', <String, String>{
      'lat': _location!.latitude.toString(),
      'lng': _location.longitude.toString(),
    });
  });
}
