import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/layot/shop_layot/shoplayot.dart';
import 'package:shopapp/modules/register/shop_register_screen.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/network/local/chache_helper.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class Shop_Login_Screen extends StatefulWidget {
  const Shop_Login_Screen({Key? key}) : super(key: key);

  @override
  State<Shop_Login_Screen> createState() => _Shop_Login_ScreenState();
}

class _Shop_Login_ScreenState extends State<Shop_Login_Screen> {
  var EmailController = TextEditingController();

  var PasswordController = TextEditingController();

  var FORMKEY = GlobalKey<FormState>();

  bool isvisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginShopCubit(),
      child: BlocConsumer<LoginShopCubit,ShopLoginState>(
        listener: (context , state)async
        {
          if(state is SuccesShopLoginState)
          {
           if(state.loginModel.status!)
           {
             Fluttertoast.showToast(
                 msg: state.loginModel.message!,
                 toastLength: Toast.LENGTH_LONG,
                 gravity: ToastGravity.BOTTOM,
                 timeInSecForIosWeb: 1,
                 backgroundColor: Colors.green,
                 textColor: Colors.white,
                 fontSize: 16.0
             );
               await Chache_Helper.setData(key: 'token', value: state.loginModel.data!.token);
               token = state.loginModel.data!.token;
               Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) => Shop_Layot()),
                   (route) => false);
           }else
             {
               Fluttertoast.showToast(
                   msg:state.loginModel.message!,
                   toastLength: Toast.LENGTH_LONG,
                   gravity: ToastGravity.BOTTOM,
                   timeInSecForIosWeb: 1,
                   backgroundColor: Colors.red,
                   textColor: Colors.white,
                   fontSize: 16.0
               );
             }
          }
        },
        builder: (context , states)
        {
          var LoginCubit = LoginShopCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: FORMKEY,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/login.jpg'),
                      const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25
                          )
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          'login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey
                          )
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: EmailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (String? value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'email must not empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            labelText: 'Email Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: PasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isvisible,
                        onFieldSubmitted: (value)
                        {
                          if(FORMKEY.currentState!.validate())
                          {
                            LoginCubit.UserLogin(
                                email: EmailController.text,
                                password: PasswordController.text);
                          }
                        },
                        validator: (String? value)
                        {
                          if(value!.isEmpty)
                          {
                            return 'password must not empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: ()
                              {
                                setState(() {
                                  isvisible = false;
                                });
                              },
                              icon: Icon(
                                  isvisible
                                      ?Icons.visibility_off
                                      :Icons.visibility
                              ),
                            ),
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ConditionalBuilder(
                        condition: states is !LoadingShopLoginState,
                        builder: (BuildContext context)
                        { return Center(
                          child: ElevatedButton(
                              onPressed: (){
                                if(FORMKEY.currentState!.validate())
                                {
                                  LoginCubit.UserLogin(
                                      email: EmailController.text,
                                      password: PasswordController.text);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  )
                              ),
                              child: const Text(
                                  'LOGIN'
                              )),
                        );},
                        fallback: (BuildContext context) {
                          return const Center(child: CircularProgressIndicator(color: MainColor,));
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'Don\'t have an account?'
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Shop_Register_Screen())
                                );
                              },
                              child: const Text('REGISTER'))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
