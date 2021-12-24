import 'package:shopapp/models/favorites/change_favorites_model.dart';
import 'package:shopapp/models/getcartmodel/get_cart_model.dart';
import 'package:shopapp/models/profilemodel/profile_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopBottomIndexState extends ShopStates{}

class ShopSuccesDataHomeState extends ShopStates{}
class ShopErrorDataHomeState extends ShopStates{
  final String error;
  ShopErrorDataHomeState(this.error);
}
class ShopLoadingDataHomeState extends ShopStates{}

class ShopLoadingCategoriesState extends ShopStates{}
class ShopErrorCategoriesState extends ShopStates{
  final String error;
  ShopErrorCategoriesState(this.error);
}
class ShopSuccesCategoriesState extends ShopStates{}

class ShopLoadingCategoriesDetailsState extends ShopStates{}
class ShopErrorCategoriesDetailsState extends ShopStates{
  final String error;
  ShopErrorCategoriesDetailsState(this.error);
}
class ShopSuccesCategoriesDetailsState extends ShopStates{}

class ShopLoadingProductsDetailsState extends ShopStates{}
class ShopErrorProductsDetailsState extends ShopStates{
  final String error;
  ShopErrorProductsDetailsState(this.error);
}
class ShopSuccesProductsDetailsState extends ShopStates{}

class ShopChangeImageProductState extends ShopStates{}

class ShopLoadingFavoritesState extends ShopStates{}
class ShopErrorFavoritesState extends ShopStates{
  final String error;
  ShopErrorFavoritesState(this.error);
}
class ShopSuccesFavoritesState extends ShopStates{}

class ShopSuccesChangeIconFavoritesState extends ShopStates{
  final ChangeFavoritesModel model;
  ShopSuccesChangeIconFavoritesState(this.model);
}

class ShopLoadingGetFavoritesState extends ShopStates{}
class ShopErrorGetFavoritesState extends ShopStates{
  final String error;
  ShopErrorGetFavoritesState(this.error);
}
class ShopSuccesGetFavoritesState extends ShopStates{}

class ShopLoadingUserDataState extends ShopStates{}
class ShopErrorUserDataState extends ShopStates{
  final String error;
  ShopErrorUserDataState(this.error);
}
class ShopSuccesUserDataState extends ShopStates{}

class ShopLoadingUpdateState extends ShopStates{}
class ShopErrorUpdateState extends ShopStates{
  final String error;
  ShopErrorUpdateState(this.error);
}
class ShopSuccesUpdateState extends ShopStates{
  final ProfileModel model;
  ShopSuccesUpdateState(this.model);
}

class ShopLoadingCartState extends ShopStates{}
class ShopErrorCartState extends ShopStates{
  final String error;
  ShopErrorCartState(this.error);
}
class ShopSuccesCartState extends ShopStates{
  final GetCartModel model;
  ShopSuccesCartState(this.model);
}

class ShopLoadingChangeCartState extends ShopStates{}
class ShopErrorChangeCartState extends ShopStates{
  final String error;
  ShopErrorChangeCartState(this.error);
}
class ShopSuccesChangeCartState extends ShopStates{}

class PlusDone extends ShopStates{}

class MinusDone extends ShopStates{}

class ShopLoadingUpdateCartState extends ShopStates{}
class ShopErrorUpdateCartState extends ShopStates{
  final String error;
  ShopErrorUpdateCartState(this.error);
}
class ShopSuccesUpdateCartState extends ShopStates{}
