import 'package:e_warung/data/model/cart_buyer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBuyerHelper {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const cartKey = 'CART';

  Future<List<CartBuyerModel>> get getCartList async {
    final SharedPreferences prefs = await _prefs;

    final String? cartList = prefs.getString(cartKey);

    if (cartList == null) {
      return [];
    }

    return cartBuyerModelFromJson(cartList);
  }

  void setCartList(List<CartBuyerModel> cartList) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString(cartKey, cartBuyerModelToJson(cartList));
  }
}
