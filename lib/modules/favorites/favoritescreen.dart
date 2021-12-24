import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/favoritesmodel/favorites_model.dart';
import 'package:shopapp/modules/productsdetails/products_details.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class Favorite_Screen extends StatelessWidget {
  const Favorite_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<ShopCubit>(context)..getFavorite(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state)
        {
          if(state is ShopSuccesChangeIconFavoritesState)
            {
              ShopCubit.get(context).getFavorite();
              if(state.model.status)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.model.message),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.green,
                ));
              }
              else
                {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.model.message),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.red,
                  ));
                }
            }
        },
        builder: (context,state) =>
            ShopCubit.get(context).favoriteGetModel == null
          ? const Center(child: CircularProgressIndicator(color: MainColor,))
          : ShopCubit.get(context).favoriteGetModel!.data.data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'There is no product in your favourite try add some',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MainColor,
                            fontSize: 20
                          ),
                        ),
                      )
                    ],
            )
                : Container(
                  color: Colors.grey[300],
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 1,
                    children: List.generate(
                        ShopCubit.get(context).favoriteGetModel!.data.data.length,
                        (index) => buildFavorites(
                            ShopCubit.get(context).favoriteGetModel,
                            index,
                            favorites,
                            context
                        )
                    ),
              ),
            )
      ),
    );
  }

  Widget buildFavorites(FavoriteGetModel? favoriteGetModel , index, Map<int, bool> favorites , context) =>
      GestureDetector(
        onTap: ()
        {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Products_Details(
              favoriteGetModel!.data.data[index].product.id
            ))
          );
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: favoriteGetModel!.data.data[index].product.image,
                    placeholder: (context , url) => const Center(child: CircularProgressIndicator(color: MainColor,)),
                    fit: BoxFit.cover
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      favoriteGetModel.data.data[index].product.name,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '${favoriteGetModel.data.data[index].product.price}'.toString(),
                          style: const TextStyle(
                            color: MainColor
                          ),
                      ),
                    ),
                    favoriteGetModel.data.data[index].product.discount != 0
                      ? Text(
                        '${favoriteGetModel.data.data[index].product.oldPrice}',
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough
                        ),
                      )
                      : const Text('') ,
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: favorites[favoriteGetModel.data.data[index].product.id]?? false
                      ? MainColor
                      : Colors.grey[300],
                      child: IconButton(
                          onPressed: ()
                          {
                            ShopCubit.get(context).changeFavorites(favoriteGetModel.data.data[index].product.id);
                          },
                          icon: const Icon(Icons.favorite_border_outlined,
                          size: 16,
                          color: Colors.black,
                          ),
                      ),
                    ),
                    const SizedBox(height: 8,)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsetsDirectional.all(8),
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      );
}
