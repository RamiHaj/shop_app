import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/cartmodel/cart_model.dart';
import 'package:shopapp/models/getcartmodel/get_cart_model.dart';
import 'package:shopapp/models/prodectsdetails/products_details.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Products_Details extends StatelessWidget {
  final id;
  const Products_Details(this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)..getProductsDetails(id.toString()),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state)
        {
          if(state is ShopSuccesCartState)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.model.messege.toString()),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.green,
                  ));
            }
        },
        builder: (context,state)
        {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            body: state is ShopLoadingProductsDetailsState
            ? const Padding(
              padding: EdgeInsets.all(50.0),
              child: Center(child: LinearProgressIndicator(color: MainColor,)),
            )
            : buildView(
              cubit.productsDetailsModel,
              context,
              id,
              ShopCubit.get(context).cartModel
            ),
          );
        },
      ),
    );
  }
  Widget buildView(ProductDetailsModel? model,context,id,CartModel? cartModel)
  {
    List<Widget> images =[];
    for (var element in model!.data.images) {
      images.add(Container(
        child: CachedNetworkImage(
          imageUrl: element,
          fit: BoxFit.cover,
          placeholder: (context , url) => const Center(child: CircularProgressIndicator(color:  MainColor,)),
        ),
      ));
    }
    return ShopCubit.get(context).productsDetailsModel == null
      ? const Center(child: CircularProgressIndicator())
      : SafeArea(
        child: Container(
              child: ListView(
                padding: const EdgeInsets.only(right: 18.0 , left: 18.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    model.data.name,
                    style: const TextStyle(
                      fontSize: 18
                    ),
                  ),
                  CarouselSlider(
                      items: images,
                      options: CarouselOptions(
                        height: 300,
                        onPageChanged: (x,reason)
                        {
                          ShopCubit.get(context).changeVal(x);
                        }
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: AnimatedSmoothIndicator(
                          activeIndex: ShopCubit.get(context).value,
                          count: images.length,
                          effect: const ExpandingDotsEffect(
                              activeDotColor: MainColor,
                              dotColor: Colors.grey,
                              dotHeight: 10,
                              dotWidth: 10,
                              spacing: 5,
                              expansionFactor: 4,
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      Text(
                        model.data.price.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: MainColor
                        ),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        child: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: ()
                          {
                            ShopCubit.get(context).addCart(id: model.data.id);
                          },
                        ),
                        backgroundColor: (ShopCubit.get(context).isCart[id])??true ? MainColor: Colors.grey[200],
                        maxRadius: 26,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15,),
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(model.data.description),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Divider(
                        height: 2,
                        color: MainColor,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                  ),
                ],
              ),
        ),
      );
  }
}
