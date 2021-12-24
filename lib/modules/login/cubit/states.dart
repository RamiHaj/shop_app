import 'package:shopapp/models/login/shop_login_model.dart';

abstract class ShopLoginState{}

class InitialShopLoginState extends ShopLoginState{}


class LoadingShopLoginState extends ShopLoginState{}
class SuccesShopLoginState extends ShopLoginState
{
  final ShopLoginModel loginModel;
  SuccesShopLoginState(this.loginModel);
}
class ErrorShopLoginState extends ShopLoginState{
  late final String Error;
  ErrorShopLoginState(this.Error);
}