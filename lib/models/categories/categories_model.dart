class CategoriesModel
{
  bool? status;
  CategoriesDataModel? data;

  CategoriesModel.fromjson(Map<String,dynamic> json)
  {
    status = json['status'];
    data = json['data'] != null ? CategoriesDataModel.fromjson(json['data']) :null;
  }
}

class CategoriesDataModel
{
  int? current_page;
  List<DataModel> data = [];

  CategoriesDataModel.fromjson(Map<String,dynamic> json)
  {
    current_page = json['current_page'];
    if(json['data'] != null)
    {
      json['data'].forEach((element)
      {
        data.add(DataModel.fromjson(element));
      });
    }
  }

}

class DataModel
{
  int? id;
  String? name;
  String? image;

  DataModel.fromjson(Map<String,dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}

