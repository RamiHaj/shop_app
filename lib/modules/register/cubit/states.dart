import 'package:shopapp/models/login/shop_login_model.dart';

abstract class ShopRegisterState{}

class InitialShopRegisterState extends ShopRegisterState{}


class LoadingShopRegisterState extends ShopRegisterState{}
class SuccesShopRegisterState extends ShopRegisterState
{
  final ShopLoginModel RegisterModel;
  SuccesShopRegisterState(this.RegisterModel);
}
class ErrorShopRegisterState extends ShopRegisterState{
  late final String Error;
  ErrorShopRegisterState(this.Error);
}