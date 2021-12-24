import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/models/favorites/change_favorites_model.dart';
import 'package:shopapp/models/favoritesmodel/favorites_model.dart';
import 'package:shopapp/models/search/searchmodel.dart';
import 'package:shopapp/modules/search/cubit/status.dart';
import 'package:shopapp/shared/constants.dart';
import 'package:shopapp/shared/network/end_points.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates>
{
  SearchCubit() : super(SearchInitialStates());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void getSearch({
  required String text
})async
  {
    emit(SearchLoadingStates());
    try
    {
      var value = await DioHelper.postdata(
          url: Search,
          data:
          {
            'text':text
          }
      );
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccesStates());
    }catch(error)
    {
      print(error.toString());
      emit(SearchErrorStates());
    }
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) async
  {
    emit(SearchLoadingFavoritesState());
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
      getFavorite();
      favorites[productId] = !(favorites[productId]??false);
      getFavorite();
      emit(SearchSuccesChangeIconFavoritesState(changeFavoritesModel!));

      if(changeFavoritesModel!.status == false)
      {
        favorites[productId] = !(favorites[productId]??false);
      }
      emit(SearchSuccesFavoritesState());
    }catch(error)
    {
      favorites[productId] = !(favorites[productId]??false);
      print(error.toString());
      emit(SearchErrorFavoritesState(error.toString()));
    }
  }

  FavoriteGetModel? favoriteGetModel;

  void getFavorite()async
  {
    emit(SearchLoadingGetFavoritesState());
    try
    {
      var value = await DioHelper.getdata(
        url: Favorites,
        token: token,

      );
      favoriteGetModel =FavoriteGetModel.fromJson(value.data);
      emit(SearchSuccesGetFavoritesState());
    }catch(error)
    {
      print(error.toString());
      emit(SearchErrorGetFavoritesState(error.toString()));
    }
  }
}