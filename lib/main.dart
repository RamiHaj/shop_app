import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/shoplayot.dart';
import 'package:shopapp/modules/login/shop_login_screen.dart';
import 'package:shopapp/modules/onboarding/onborading.dart';
import 'package:shopapp/shared/network/local/chache_helper.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';
import 'package:shopapp/shared/style/theme/dark_theme.dart';
import 'package:shopapp/shared/style/theme/light_theme.dart';
import 'layot/darkmode/cubitdark.dart';
import 'layot/darkmode/statusdark.dart';
import 'modules/login/cubit/bloc_observer.dart';
import 'shared/constants.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Chache_Helper.init();
  await DioHelper.init();
  dynamic onBoardingFinish = false;
  onBoardingFinish =Chache_Helper.getData(key: 'onBoarding');
  Bloc.observer = MyBlocObserver();
  token = Chache_Helper.getData(key: 'token');
  print(token);
  late Widget start;
  if(onBoardingFinish != null){
    if(token == null)
      {
        start = Shop_Login_Screen();
      }else
        {
          start = Shop_Layot();
        }
  }else
    {
      start = OnBorading();
    }

  runApp(MyApp(start));
}

class MyApp extends StatelessWidget {
  Widget startApp;
  MyApp(this.startApp);
  bool? isdark= Chache_Helper.getData(key: "isdark");
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:
        [
          BlocProvider(create: (context) => NewsCubitDark()..changemode(FromShared: isdark)),
          BlocProvider(create: (context) => ShopCubit()),
        ],
        child: BlocConsumer<NewsCubitDark,NewsDarkStatus>
          (
          listener: (context,state){},
          builder: (context,state)
          {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme:  light_theme,
              darkTheme: dark_theme,
              themeMode: NewsCubitDark.get(context).isdark ? ThemeMode.light : ThemeMode.light,
              home:startApp,
            );
          },
        )
    );
  }
}

