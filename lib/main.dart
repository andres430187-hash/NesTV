import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'services/xtream_api_service.dart';
import 'theme/nesh_theme.dart';

void main() => runApp(const NeshApp());

class NeshApp extends StatelessWidget {
  const NeshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<XtreamApiService>(
      create: (_) => XtreamApiService(),
      dispose: (_, api) => api.dispose(),
      child: MaterialApp(
        title: 'Nesh',
        debugShowCheckedModeBanner: false,
        theme: NeshTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
