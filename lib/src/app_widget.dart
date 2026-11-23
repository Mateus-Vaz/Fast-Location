import 'package:flutter/material.dart';

import 'http/app_http_client.dart';
import 'modules/history/controller/history_controller.dart';
import 'modules/history/page/history_page.dart';
import 'modules/home/controller/home_controller.dart';
import 'modules/home/page/home_page.dart';
import 'modules/home/repositories/address_local_repository.dart';
import 'modules/home/repositories/via_cep_repository.dart';
import 'modules/home/service/address_service.dart';
import 'modules/home/service/route_service.dart';
import 'modules/initial/page/initial_page.dart';
import 'routes/app_routes.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_controller.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});

  final _localRepository = AddressLocalRepository();
  final _routeService = RouteService();
  final _themeController = ThemeController();
  late final _addressService = AddressService(
    ViaCepRepository(AppHttpClient.create()),
    _localRepository,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, themeMode, _) => _buildApp(themeMode),
    );
  }

  Widget _buildApp(ThemeMode themeMode) {
    return MaterialApp(
      title: 'FastLocation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: AppRoutes.initial,
      routes: {
        AppRoutes.initial: (_) => const InitialPage(),
        AppRoutes.home: (_) => HomePage(
          controller: HomeController(_addressService, _routeService),
          themeController: _themeController,
        ),
        AppRoutes.history: (_) =>
            HistoryPage(controller: HistoryController(_localRepository)),
      },
    );
  }
}
