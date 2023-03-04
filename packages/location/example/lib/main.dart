import 'package:flutter/material.dart';
import 'package:location_example/change_notification.dart';
import 'package:location_example/change_settings.dart';
import 'package:location_example/get_location.dart';
import 'package:location_example/listen_location.dart';
import 'package:location_example/permission_status.dart';
import 'package:location_example/service_enabled.dart';

import 'screen/background_location_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'Flutter Location Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const PermissionStatusWidget(),
            const Divider(height: 32),
            const ServiceEnabledWidget(),
            const Divider(height: 32),
            const GetLocationWidget(),
            const Divider(height: 32),
            const ListenLocationWidget(),
            const Divider(height: 32),
            const ChangeSettings(),
            const Divider(height: 32),
            const ChangeNotificationWidget(),
            const Divider(height: 32),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const BackgroundSerivePage(),
                      ),
                    ),
                child: const Text('Background location Screen'))
          ],
        ),
      ),
    );
  }
}
