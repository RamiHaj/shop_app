import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/categoriesdetails/categories_details.dart';
import 'package:shopapp/modules/productsdetails/products_details.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Categories_Details_Screen extends StatelessWidget {
  final int? id;
  const Categories_Details_Screen({required this.id});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)..getCategoriesDetails(id: id),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            body: cubit.categoryDetailsModel == null || state is ShopLoadingCategoriesDetailsState
            ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: LinearProgressIndicator(color: MainColor,)),
            )
            :Container(
              color: Colors.grey[300],
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(
                    cubit.categoryDetailsModel!.data!.data.length,
                    (index) => productView(cubit.categoryDetailsModel,index,context)),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget productView(CategoryDetailsModel? model , index , context) => GestureDetector(
    onTap:(){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Products_Details(model!.data!.data[index].id))
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.5,vertical: 0.5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              // Expanded(child: Image.network(model!.data!.data[index].image)),
              Expanded(
                child: CachedNetworkImage(
                    imageUrl: model!.data!.data[index].image,
                    placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
                ),
              ),
              Text(
                  model.data!.data[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      model.data!.data[index].price.toString(),
                      style: const TextStyle(color: MainColor),),
                  ),
                  if(model.data!.data[index].discount !=0)
                    Text(model.data!.data[index].oldPrice.toString(),
                      style: TextStyle(
                          color: Colors.grey[400],
                          decoration: TextDecoration.lineThrough
                      ),
                    )
                ],
              ),
              SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    ),
  );
}
