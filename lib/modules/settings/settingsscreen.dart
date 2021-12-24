import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/modules/login/shop_login_screen.dart';
import 'package:shopapp/shared/network/local/chache_helper.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Settings_Screen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>() ;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)..getUserData(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state) {
          if(state is ShopSuccesUserDataState)
            {
              nameController.text = ShopCubit.get(context).profileModel!.data.name;
              phoneController.text = ShopCubit.get(context).profileModel!.data.phone;
              emailController.text = ShopCubit.get(context).profileModel!.data.email;
            }

          if(state is ShopSuccesUpdateState)
          {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.model.message.toString()),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.green,
                ));
          }
        },
        builder: (context,state) {
          return ConditionalBuilder(
            condition: state is !ShopLoadingUserDataState,
            builder: (BuildContext context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is ShopLoadingUpdateState)
                        LinearProgressIndicator(color: MainColor,),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
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
                        height: 15,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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
                            labelText: 'email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
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
                            labelText: 'phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: ()
                        {
                          ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text
                          );
                        },
                        child: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (BuildContext context)  =>const Center(child: CircularProgressIndicator(color: MainColor,)),

          );
        },
      ),
    );
  }
}
