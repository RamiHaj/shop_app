import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/layot/shop_layot/cubit/states.dart';
import 'package:shopapp/models/cartmodel/cart_model.dart';
import 'package:shopapp/models/categories/categories_model.dart';
import 'package:shopapp/models/categoriesdetails/categories_details.dart';
import 'package:shopapp/models/favorites/change_favorites_model.dart';
import 'package:shopapp/models/favoritesmodel/favorites_model.dart';
import 'package:shopapp/models/getcartmodel/get_cart_model.dart';
import 'package:shopapp/models/home/home_model.dart';
import 'package:shopapp/models/prodectsdetails/products_details.dart';
import 'package:shopapp/models/profilemodel/profile_model.dart';
import 'package:shopapp/modules/categories/categoriesscreen.dart';
import 'package:shopapp/modules/favorites/favoritescreen.dart';
import 'package:shopapp/modules/home/home_screen.dart';
import 'package:shopapp/modules/settings/settingsscreen.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/network/end_points.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex= 0;

  List<Widget> screens =
  [
    const Home_Screen(),
    const Categories_Screen(),
    const Favorite_Screen(),
    Settings_Screen()
  ];

  void changeindex(int index)
  {
    currentIndex = index;
    emit(ShopBottomIndexState());
  }

  HomeModel? homeModel;
  Map<int,bool> isCart ={};

  void getHomeData()async
  {
    emit(ShopLoadingDataHomeState());
    try
    {
      var value = await DioHelper.getdata(
        url: Home,
        token: token
      );
      homeModel = HomeModel.fromjson(value.data);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id : element.in_favorites
        });
      }
      for (var element in homeModel!.data!.products) {
        isCart.addAll({
          element.id : element.in_cart
        });
      }
      emit(ShopSuccesDataHomeState());
    }catch(error)
    {
      emit(ShopErrorDataHomeState(error.toString()));
    }
  }

  CategoriesModel? categoriesModel;

  void getCategories()async
  {
    emit(ShopSuccesCategoriesState());
    try
    {
      var value = await DioHelper.getdata(
          url: Categories
      );
      categoriesModel = CategoriesModel.fromjson(value.data);
      emit(ShopSuccesCategoriesState());
    }catch(error)
    {
      emit(ShopErrorCategoriesState(error.toString()));
    }
  }

  ProductDetailsModel? productsDetailsModel;

  void getProductsDetails(String id)async
  {
    emit(ShopLoadingProductsDetailsState());
    try
    {
      var value =await DioHelper.getdata(
          url: ProductsDetails+id,
          token: token
      );
      productsDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(ShopSuccesProductsDetailsState());
    }catch(error)
    {
      emit(ShopErrorProductsDetailsState(error.toString()));
    }
  }

  CategoryDetailsModel? categoryDetailsModel;

  void getCategoriesDetails({required int? id})async
  {
    emit(ShopLoadingCategoriesDetailsState());
    try
    {
      var value = await DioHelper.getdata(
          url: Products,
          token: token,
          query: {
            'category_id':id
          },
      );
      categoryDetailsModel = CategoryDetailsModel.fromJson(value.data);
      emit(ShopSuccesCategoriesDetailsState());
    }catch(error)
    {
      emit(ShopErrorCategoriesDetailsState(error.toString()));
    }
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) async
  {
    emit(ShopLoadingFavoritesState());
    try
    {
      var value = await DioHelper.postdata(
          url: Favorites,
          data: {
            "product_id" : productId
          },
          token: token,
      );
      changeFavoritesModel=ChangeFavoritesModel.fromjson(value.data);

      favorites[productId] = !(favorites[productId]??false);
      emit(ShopSuccesChangeIconFavoritesState(changeFavoritesModel!));

      if(changeFavoritesModel!.status == false)
      {
        favorites[productId] = !(favorites[productId]??false);
      }
      emit(ShopSuccesFavoritesState());
    }catch(error)
    {
      favorites[productId] = !(favorites[productId]??false);
      emit(ShopErrorFavoritesState(error.toString()));
    }
  }

  FavoriteGetModel? favoriteGetModel;
  
  void getFavorite()async
  {
    emit(ShopLoadingGetFavoritesState());
    try
    {
      var value = await DioHelper.getdata(
          url: Favorites,
          token: token,

      );
      favoriteGetModel =FavoriteGetModel.fromJson(value.data);
      emit(ShopSuccesGetFavoritesState());
    }catch(error)
    {
      emit(ShopErrorGetFavoritesState(error.toString()));
    }
  }

  ProfileModel? profileModel;

  void getUserData()async
  {
    emit(ShopLoadingUserDataState());
    try
    {
      var value = await DioHelper.getdata(
        url: PROFILE,
        token: token,
      );
      profileModel =ProfileModel.fromJson(value.data);
      emit(ShopSuccesUserDataState());
    }catch(error)
    {
      emit(ShopErrorUserDataState(error.toString()));
    }
  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
})async
  {
    emit(ShopLoadingUpdateState());
    try
    {
      var value = await DioHelper.putdata(
        url: UPDATE,
        token: token,
        data:
        {
          'name':name,
          'email':email,
          'phone':phone,
        },
      );
      profileModel =ProfileModel.fromJson(value.data);
      emit(ShopSuccesUpdateState(profileModel!));
    }catch(error)
    {
      emit(ShopErrorUpdateState(error.toString()));
    }
  }
  
  GetCartModel? getCartModel;
  
  void getAllCart()async
  {
    emit(ShopLoadingCartState());
    try
    {
      var value = await DioHelper.getdata(
          url: Carts,
          token: token
      );
      getCartModel = GetCartModel.fromjson(value.data);
      emit(ShopSuccesCartState(getCartModel!));
    }catch(error)
    {
      emit(ShopErrorCartState(error.toString()));
    }
  }

  CartModel? cartModel;

  void addCart({required int id})async
  {
    emit(ShopLoadingChangeCartState());
    try
    {
      var value = await DioHelper.postdata(
          url: Carts,
          data:
          {
            'product_id': id
          },
          token: token,
      );
      isCart[id] = !(isCart[id]??false);
      getAllCart();
      cartModel = CartModel.fromJson(value.data);
      emit(ShopSuccesChangeCartState());
    }catch(error)
    {
      emit(ShopErrorChangeCartState(error.toString()));
    }
  }

  int quantity = 1;

  void plusQuantity(GetCartModel model ,index)
  {
    quantity = model.data.cartItems[index].quantity;
    quantity++;
    emit(PlusDone());
  }

  void minusQuantity(GetCartModel model ,index)
  {
    quantity = model.data.cartItems[index].quantity;
    if(quantity>1) {
      quantity--;
    }
    emit(MinusDone());
  }

  void updateQuantity({
  required String id,
  int? quantity
})async
  {
    emit(ShopLoadingUpdateCartState());
    try
    {
      await DioHelper.putdata(
          url: CartsUpdate + id,
          data: {
            'quantity': quantity
          },
          token: token
      );
    getAllCart();
    emit(ShopSuccesUpdateCartState());
    }catch(error)
    {
      emit(ShopErrorUpdateCartState(error.toString()));
    }
  }

  int value = 0;
  void changeVal(val){
    value = val;
    emit(ShopChangeImageProductState());
  }
}

