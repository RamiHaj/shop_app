class GetCartModel
{
  late bool status;
  String? messege;
  late Data data;

  GetCartModel.fromjson(Map<String,dynamic> json)
  {
    status = json['status'];
    messege = json['message'];
    data = (json['data'] != null ? Data.fromjson(json['data']) : null)!;
  }
}

class Data
{
  List<CartItems> cartItems = [];
  late final subTotal;
  late final total;

  Data.fromjson(Map<String,dynamic> json)
  {
    if (json['cart_items'] != null) {
      json['cart_items'].forEach((v) {
        cartItems.add(CartItems.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    total = json['total'];
  }
}

class CartItems
{
  late final id;
  late final quantity;
  late Product product;
  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product =
    (json['product'] != null ? Product.fromJson(json['product']) : null)!;
  }

}

class Product
{
  late final id;
  late final price;
  late String image;
  late String name;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
  }

}