import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/categories/categories_model.dart';
import 'package:shopapp/models/home/home_model.dart';
import 'package:shopapp/modules/categoriesdetails/categories_details_screen.dart';
import 'package:shopapp/modules/productsdetails/products_details.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';


class Home_Screen extends StatelessWidget {
  const Home_Screen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)
        ..getHomeData()..getCategories(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if(state is ShopSuccesChangeIconFavoritesState)
          {
            if(state.model.status == false)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.model.message),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.red,
              ));
            }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.model.message),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.green,
                ));
              }
          }
        },
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.homeModel != null &&
                  cubit.categoriesModel != null,
              builder: (context) => productsBuilder(
                  cubit.homeModel, cubit.categoriesModel, context , favorites),
              fallback: (context) =>
              const Center(child: CircularProgressIndicator(color: MainColor,))
          );
        },
      ),
    );
  }

  Widget productsBuilder(HomeModel? modelhome, CategoriesModel? modelCat, context ,Map<int,bool> fav) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: CarouselSlider(
                options: CarouselOptions
                  (
                    autoPlay: true,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayInterval: const Duration(seconds: 3),
                    enableInfiniteScroll: true,
                    height: 250.0,
                    initialPage: 0,
                    viewportFraction: 0.95,
                    reverse: false,
                    scrollDirection: Axis.horizontal
                ),
                items: modelhome!.data!.banners.map((e) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl: (e.image),
                            placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                ).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Categries',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            GestureDetector(
                                child: buildCategories(modelCat, index),
                                onTap: ()
                                {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => 
                                          Categories_Details_Screen(id: modelCat!.data!.data[index].id))
                                  );
                                },
                            ),
                        separatorBuilder: (context, index) =>
                        const SizedBox(width: 10,),
                        itemCount: modelCat!.data!.data.length),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Products',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                childAspectRatio: 1 / 1.5,
                children: List.generate(
                    modelhome.data!.products.length,
                        (index) =>
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      Products_Details(
                                          modelhome.data!.products[index].id))
                              );
                            },
                            child: buildGridView(modelhome, index , context , fav))
                ),
              ),
            )
          ],
        ),
      );
  }


  Widget buildGridView(HomeModel? model, index ,context, Map<int,bool> fav)
  {
    var cubit = ShopCubit.get(context);
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                  imageUrl: model!.data!.products[index].image,
                  placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
                  height: 175.0,
                  width: double.infinity,
              ),
              if(model.data!.products[index].discount != 0)
                Container(
                  color: Colors.red,
                  padding: const EdgeInsetsDirectional.all(2.0),
                  child: const Text(
                    'Discount',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.data!.products[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        height: 1.1,
                        color: MainColor
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${model.data!.products[index].price.round()}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            height: 1.1,
                            color: MainColor
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if(model.data!.products[index].discount != 0)
                        Text(
                          '${model.data!.products[index].old_price.round()}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            height: 1.1,
                            color: Colors.black,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: fav[model.data!.products[index].id]?? false ? MainColor : Colors.grey[300],
                        child: IconButton(
                          onPressed: () {
                            cubit.changeFavorites(model.data!.products[index].id);
                          },
                          icon: const Icon(Icons.favorite_border_outlined),
                          iconSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildCategories(CategoriesModel? modelCat, index) => Row(
        children: [
          Container(
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CachedNetworkImage(
                    imageUrl: modelCat!.data!.data[index].image.toString(),
                    placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
                    fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8,bottom: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                      gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          stops: const [.3,.9],
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(.3)
                          ]
                      )
                  ),
                  child: Text(
                    '${modelCat.data!.data[index].name}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,

                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );

}