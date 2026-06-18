import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/audio_manager.dart';
import 'game/game_provider.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AudioManager.instance.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: const KucukTuccarApp(),
    ),
  );
}

class KucukTuccarApp extends StatelessWidget {
  const KucukTuccarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Küçük Tüccar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'), Locale('en'), Locale('ar'), Locale('hy'),
        Locale('el'), Locale('fr'), Locale('es'), Locale('ru'),
        Locale('zh'), Locale('ko'), Locale('ja'),
      ],
      home: const SplashScreen(),
    );
  }
}
