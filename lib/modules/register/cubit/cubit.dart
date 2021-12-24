import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/login/shop_login_model.dart';
import 'package:shopapp/modules/register/cubit/states.dart';
import 'package:shopapp/shared/network/end_points.dart';

import 'package:shopapp/shared/network/remote/dio_helper.dart';

class RegisterShopCubit extends Cubit<ShopRegisterState>
{
  RegisterShopCubit() : super(InitialShopRegisterState());

  static RegisterShopCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? RegisterModel;

  void UserRegister (
      {required String email,
        required String password,
        required String name,
        required String phone,
      })
  async{
    emit(LoadingShopRegisterState());
    try
    {
      var value = await DioHelper.postdata(
          url: Register,
          data:
          {
            'email':email,
            'password':password,
            'name':name,
            'phone':phone,
          });
      RegisterModel = ShopLoginModel.fromjson(value.data);
      emit(SuccesShopRegisterState(RegisterModel!));
    }catch(error)
    {
     print(error.toString());
     emit(ErrorShopRegisterState(error.toString()));
    }
  }
}