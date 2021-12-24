class ChangeFavoritesModel
{
  late bool status;
  late String message;

  ChangeFavoritesModel.fromjson(Map<String , dynamic> json)
  {
    status = json['status'];
    message = json['message']?? Null;
  }
}