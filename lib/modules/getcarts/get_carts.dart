import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/cubit.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/getcartmodel/get_cart_model.dart';
import 'package:shopapp/shared/style/color/shared_color.dart';

class getCarts extends StatelessWidget {
  const getCarts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)..getAllCart(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          return Scaffold(
              body: ShopCubit.get(context).getCartModel == null
                  ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Center(child: LinearProgressIndicator(color: MainColor,)),
                  )
                  : ShopCubit.get(context).getCartModel!.data.cartItems.isEmpty
                    ? Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'Your cart is Empty',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MainColor,
                                  fontSize: 20
                              ),
                            ),
                          ],
                      ),
                    )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            color: Colors.grey[300],
                            child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 1,
                                shrinkWrap: true,
                                children: List.generate(
                                ShopCubit.get(context).getCartModel!.data.cartItems.length,
                                (index) => productView(ShopCubit.get(context).getCartModel , index , context)),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              'Total Price: ${ShopCubit.get(context).getCartModel!.data.total}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: MainColor
                            ),
                          )
                        ],
                      )
          );
        },
      ),
    );
  }
  Widget productView(GetCartModel? model , index , context) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                  imageUrl: model!.data.cartItems[index].product.image,
                  placeholder: (context , url ) => const Center(child: CircularProgressIndicator(color: MainColor,)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                  model.data.cartItems[index].product.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15
                  ),
              ),
            ),
            const SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                  ShopCubit.get(context).minusQuantity(model,index);
                  ShopCubit.get(context).updateQuantity(
                      id: model.data.cartItems[index].id.toString(),
                      quantity: ShopCubit.get(context).quantity
                  );
                  }
                  ,icon: const Icon(Icons.remove),color: MainColor,),
                const SizedBox(width: 2,),
                Text(
                  model.data.cartItems[index].quantity.toString(),
                  style: const TextStyle(
                      color: MainColor,fontSize: 25
                  ),),
                const SizedBox(width: 2,),
                IconButton(onPressed: (){
                  ShopCubit.get(context).plusQuantity(model,index);
                  ShopCubit.get(context).updateQuantity(
                      id: model.data.cartItems[index].id.toString(),
                      quantity: ShopCubit.get(context).quantity
                  );
                },
                  icon: const Icon(Icons.add),color: MainColor,),
              ],),
            const SizedBox(height: 15,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0,left: 8.0),
                  child: Text(
                    model.data.cartItems[index].product.price.toString(),
                    style: const TextStyle(color: MainColor),),
                ),
                const Spacer(),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      children: const [
                        Icon(Icons.restore_from_trash,color: Colors.red,),
                        Text("Remove from cart",style: TextStyle(color: Colors.red),)
                      ],),
                  ),
                  onTap: (){
                    ShopCubit.get(context).addCart(id: model.data.cartItems[index].product.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Container(
              padding: const EdgeInsetsDirectional.all(8),
              width: double.infinity,
              height: 1.0,
              color: Colors.grey,
            ),
          ],
        ),
      );
}
