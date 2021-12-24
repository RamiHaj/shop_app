class HomeModel
{
  bool? status;
  HomeDataModel? data;

  HomeModel({
    this.data,
    this.status
});

  HomeModel.fromjson(Map<String,dynamic> json)
  {
    status = json['status'];
    data = json['data'] != null ? HomeDataModel.fromjson(json['data']) : null;
  }
}

class HomeDataModel
{
  List<BannersModel> banners = [];
  List<ProductsModel> products= [];
  HomeDataModel.fromjson(Map<String,dynamic> json)
  {
    if(json['banners'] != null)
    {
      json['banners'].forEach((element)
      {
        banners.add(BannersModel.fromjson(element));
      });
    }
    if(json['products'] != null)
    {
      json['products'].forEach((element)
      {
        products.add(ProductsModel.fromjson(element));
      });
    }
  }
}

class BannersModel
{
  late int id;
  late String image;

  BannersModel.fromjson(Map<String,dynamic> json)
  {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel
{
  late int id;
  late final price;
  late final old_price;
  int? discount;
  late String image;
  late String name;
  String? description;
  late bool in_favorites;
  late bool in_cart;
  ProductsModel.fromjson(Map<String,dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    in_favorites = json['in_favorites'];
    in_cart = json['in_cart'];
    description = json['description'];
  }
}