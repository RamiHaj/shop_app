import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/layot/shop_layot/shoplayot.dart';
import 'package:shopapp/modules/register/cubit/cubit.dart';
import 'package:shopapp/modules/register/cubit/states.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/network/local/chache_helper.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Shop_Register_Screen extends StatefulWidget {
  Shop_Register_Screen({Key? key}) : super(key: key);

  @override
  State<Shop_Register_Screen> createState() => _Shop_Register_ScreenState();
}

class _Shop_Register_ScreenState extends State<Shop_Register_Screen> {
  var emailController = TextEditingController();

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
     return BlocProvider(
       create: (context) => RegisterShopCubit(),
       child: BlocConsumer<RegisterShopCubit,ShopRegisterState>(
         listener: (context,state)async
         {
           if(state is SuccesShopRegisterState)
           {
             if(state.RegisterModel.status!)
             {
               Fluttertoast.showToast(
                   msg: state.RegisterModel.message!,
                   toastLength: Toast.LENGTH_LONG,
                   gravity: ToastGravity.BOTTOM,
                   timeInSecForIosWeb: 1,
                   backgroundColor: Colors.green,
                   textColor: Colors.white,
                   fontSize: 16.0
               );
               await Chache_Helper.setData(key: 'token', value: state.RegisterModel.data!.token);
               token = state.RegisterModel.data!.token;
               Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) => Shop_Layot()),
                       (route) => false);
             }else
             {
               Fluttertoast.showToast(
                   msg:state.RegisterModel.message!,
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
         builder: (context,state)
         {
           return SafeArea(
             child: Scaffold(
               body: Form(
                 key: formKey,
                 child: SingleChildScrollView(
                   padding: const EdgeInsets.all(8.0),
                   physics: const BouncingScrollPhysics(),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Image.asset('assets/images/register.jpg'),
                       const Text(
                           'Register',
                           style: TextStyle(
                             fontSize: 25,
                             fontWeight: FontWeight.w900
                           )
                       ),
                       const SizedBox(
                         height: 10,
                       ),
                       Text(
                           'register now to browse our hot offers',
                           style: Theme.of(context).textTheme.bodyText1!.copyWith(
                               color: Colors.grey
                           )
                       ),
                       const SizedBox(
                         height: 30,
                       ),
                       TextFormField(
                         controller: nameController,
                         keyboardType: TextInputType.name,
                         textInputAction: TextInputAction.next,
                         validator: (String? value)
                         {
                           if(value!.isEmpty)
                           {
                             return 'name must not empty';
                           }
                           return null;
                         },
                         decoration: InputDecoration(
                             prefixIcon: const Icon(Icons.person),
                             labelText: 'User Name',
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20),
                             )
                         ),
                       ),
                       const SizedBox(
                         height: 10,
                       ),
                       TextFormField(
                         controller: phoneController,
                         keyboardType: TextInputType.phone,
                         textInputAction: TextInputAction.next,
                         validator: (String? value)
                         {
                           if(value!.isEmpty)
                           {
                             return 'phone must not empty';
                           }
                           return null;
                         },
                         decoration: InputDecoration(
                             prefixIcon: const Icon(Icons.phone),
                             labelText: 'Phone',
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(20),
                             )
                         ),
                       ),
                       const SizedBox(
                         height: 10,
                       ),
                       TextFormField(
                         controller: emailController,
                         keyboardType: TextInputType.emailAddress,
                         textInputAction: TextInputAction.next,
                         validator: (String? value)
                         {
                           if(value!.isEmpty)
                           {
                             return 'email addrees must not empty';
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
                         controller: passwordController,
                         keyboardType: TextInputType.visiblePassword,
                         obscureText: isVisible,
                         textInputAction: TextInputAction.next,
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
                                   isVisible = false;
                                 });
                               },
                               icon: Icon(
                                   isVisible
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
                         condition: state is !LoadingShopRegisterState,
                         builder: (BuildContext context)
                         { return Center(
                           child: ElevatedButton(
                               onPressed: (){
                                 if(formKey.currentState!.validate())
                                 {
                                   RegisterShopCubit.get(context).UserRegister(
                                       email: emailController.text,
                                       password: passwordController.text,
                                       name: nameController.text,
                                       phone: phoneController.text
                                   );
                                 }
                               },
                               style: ElevatedButton.styleFrom(
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(20)
                                   )
                               ),
                               child: const Text(
                                   'REGISTER'
                               )),
                         );},
                         fallback: (BuildContext context) {
                           return const Center(child: CircularProgressIndicator(color: MainColor,));
                         },
                       ),
                       const SizedBox(
                         height: 10,
                       ),
                     ],
                   ),
                 ),
               ),
             ),
           );
         } ,
       ),
     );
  }
}
