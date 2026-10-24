import 'package:menu_web/core/models/menu_config.dart';
import 'package:menu_web/core/models/public_menu.dart';

abstract class PublicMenuRepository {
  Future<MenuConfig> fetchMenu();
}
