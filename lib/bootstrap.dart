import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_currency_app/logger.dart';
import 'package:world_currency_app/provider/currency_provider.dart';

import 'data/repositories/currency_repository.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    logger.e(details.summary, details.exceptionAsString(), details.stack);
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await Firebase.initializeApp();

      await FirebaseAnalytics.instance.logAppOpen();

      await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      await OneSignal.shared.setAppId("6a936547-eff1-4148-9cc7-f048831de664");

      OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
        logger.i("Accepted permission: $accepted");
      });

      OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) async {
        event.complete(event.notification);
        await FirebaseAnalytics.instance.logEvent(name: 'foreground_notification_received');
      });

      OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
        logger.i(result.notification.title);
        await FirebaseAnalytics.instance.logEvent(name: 'notification_opened', parameters: {'notification_title': result.notification.title});
      });

      OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) async {
        logger.i(action.clickName);
        await FirebaseAnalytics.instance.logEvent(name: 'in-app-message-clicked');
      });

      runApp(
        ChangeNotifierProvider(
          create: (context) => CurrencyProvider(currencyRepository: CurrencyRepository(), prefs: prefs),
          child: await builder(),
        ),
      );
    },
    (error, stackTrace) {
      logger.e('Exception', error, stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
