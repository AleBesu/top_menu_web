import 'package:menu_web/models/public_menu.dart';

abstract class PublicMenuRepository {
  Future<PublicMenu> fetchMenu();
}
