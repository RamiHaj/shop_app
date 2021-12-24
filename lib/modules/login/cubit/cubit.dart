import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/login/shop_login_model.dart';
import 'package:shopapp/modules/login/cubit/states.dart';
import 'package:shopapp/shared/network/end_points.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class LoginShopCubit extends Cubit<ShopLoginState>
{
  LoginShopCubit() : super(InitialShopLoginState());

  static LoginShopCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void UserLogin (
      {required String email,
        required String password
      })
  async{
    emit(LoadingShopLoginState());
    try
    {
      var value = await DioHelper.postdata(
          url: Login,
          data:
          {
            'email':email,
            'password':password,
          });
      loginModel = ShopLoginModel.fromjson(value.data);
      emit(SuccesShopLoginState(loginModel!));
    }catch(error)
    {
     print(error.toString());
     emit(ErrorShopLoginState(error.toString()));
    }
  }
}