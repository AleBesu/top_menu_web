import 'package:menu_web/core/models/public_menu.dart';

abstract class PublicMenuRepository {
  Future<PublicMenu> fetchMenu();
}
