import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/modules/getcarts/get_carts.dart';
import 'package:shopapp/modules/login/shop_login_screen.dart';
import 'package:shopapp/modules/search/searchscreen.dart';
import 'package:shopapp/shared/network/local/chache_helper.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Shop_Layot extends StatelessWidget {
  const Shop_Layot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Salla'),
            actions: [
              IconButton(
                  onPressed: ()async
                  {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Search_Screen())
                    );
                    ShopCubit.get(context).getFavorite();
                  },
                  icon: const Icon(Icons.search)
              ),
              IconButton(
                  onPressed: ()async
                  {
                    var value = await Chache_Helper.removeData(key: 'token');
                    if (value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Shop_Login_Screen()),
                              (route) => false);
                    }
                  },
                  icon: const Icon(Icons.logout)
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const getCarts())
              );
            },
            child: const Icon(Icons.shopping_cart,),
            backgroundColor: MainColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            onTap: (int index) {
              cubit.changeindex(index);
            },
            activeIndex: cubit.currentIndex,
            icons:const [
              Icons.home,
              Icons.category_outlined,
              Icons.favorite_border_outlined,
              Icons.settings
            ],
            activeColor: MainColor,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
          ),
        );
      },
    );
  }
}
