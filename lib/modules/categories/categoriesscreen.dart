import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/categories/categories_model.dart';
import 'package:shopapp/modules/categoriesdetails/categories_details_screen.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Categories_Screen extends StatelessWidget {
  const Categories_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)..getCategories(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit = ShopCubit.get(context);
          return ShopCubit.get(context).categoriesModel ==null
            ? const Center(child: CircularProgressIndicator(color: MainColor,))
            : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context , index) => buildCategories(cubit.categoriesModel , context , index),
              separatorBuilder: (context , index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
              itemCount: cubit.categoriesModel!.data!.data.length);
        },
      ),
    );
  }

  Widget buildCategories(CategoriesModel? dataModel , context , index) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: GestureDetector(
      onTap: ()
      {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Categories_Details_Screen(id: dataModel!.data!.data[index].id) )
        );
      },
      child: Row(
        children: [
          CachedNetworkImage(
              imageUrl: dataModel!.data!.data[index].image.toString(),
              placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
              '${dataModel.data!.data[index].name}'
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Categories_Details_Screen(id: dataModel.data!.data[index].id) )
              );
            },
            icon: const Icon(Icons.arrow_forward_ios,color: MainColor,),
          )
        ],
      ),
    ),
  );
}
