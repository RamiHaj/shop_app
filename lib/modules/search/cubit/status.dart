import 'package:shopapp/models/favorites/change_favorites_model.dart';

abstract class SearchStates{}

class SearchInitialStates extends SearchStates{}

class SearchLoadingStates extends SearchStates{}
class SearchSuccesStates extends SearchStates{}
class SearchErrorStates extends SearchStates{}

class SearchLoadingFavoritesState extends SearchStates{}
class SearchErrorFavoritesState extends SearchStates{
  final String Error;
  SearchErrorFavoritesState(this.Error);
}
class SearchSuccesFavoritesState extends SearchStates{}

class SearchSuccesChangeIconFavoritesState extends SearchStates{
  final ChangeFavoritesModel model;
  SearchSuccesChangeIconFavoritesState(this.model);
}

class SearchLoadingGetFavoritesState extends SearchStates{}
class SearchErrorGetFavoritesState extends SearchStates{
  final String Error;
  SearchErrorGetFavoritesState(this.Error);
}
class SearchSuccesGetFavoritesState extends SearchStates{}