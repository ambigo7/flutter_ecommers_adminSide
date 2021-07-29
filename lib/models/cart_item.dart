
class CartItemModel {
  static const ID= "id";

  static const NAME_PRODUCT = "nameProduct";
  static const IMAGE_PRODUCT = "imageProduct";
  static const PRODUCT_ID = "productId";
  static const PRICE_PRODUCT = "priceProduct";

  static const ID_LENS = "lensId";
  static const NAME_LENS = "nameLens";
  static const IMAGE_LENS = "imageLens";
  static const LENS_ID = "lensId";
  static const PRICE_LENS = "priceLens";
  static const TOTAL_PRICE_CART = "totalPriceCart";
  static const ADJUST_LENS = "adjustLens";

  /*static const QUANTITY = "quantity";*/

  // Private Variabel
  String _id;
  String _nameProduct;
  String _imageProduct;
  String _productId;
  int _priceProduct;

  String _nameLens;
  String _imageLens;
  String _lensId;
  int _priceLens;

  String _adjustLens;

  int _totalPriceCart;
/*  int _quantity;*/

//Getter read only, private variabel
  String get id => _id;
  String get nameProduct => _nameProduct;
  String get imageProduct => _imageProduct;
  String get productId => _productId;
  int get priceProduct => _priceProduct;

  String get nameLens => _nameLens;
  String get imageLens => _imageLens;
  String get lensId => _lensId;
  String get adjustLens => _adjustLens;
  int get priceLens => _priceLens;

  int get totalPriceCart => _totalPriceCart;
  /*int get quantity => _quantity;*/

  CartItemModel.fromMap(Map data){
    _id = data[ID];
    _nameProduct =  data[NAME_PRODUCT];
    _imageProduct =  data[IMAGE_PRODUCT];
    _productId = data[PRODUCT_ID];
    _priceProduct = data[PRICE_PRODUCT];
    _nameLens =  data[NAME_LENS] ?? '';
    _imageLens =  data[IMAGE_LENS]?? '';
    _lensId = data[LENS_ID] ?? '';
    _priceLens = data[PRICE_LENS] ?? 0;
    _totalPriceCart = data[TOTAL_PRICE_CART] ?? 0;
    _adjustLens = data[ADJUST_LENS] ?? '' /*_convertAdjustLens(data[ADJUST_LENS] ?? [])*/;
    print('adjust cart item $_adjustLens');
    /*_quantity = data[QUANTITY];*/
  }

// buat convert ke map
  Map toMap() => {
    ID: _id,
    IMAGE_PRODUCT: _imageProduct,
    NAME_PRODUCT: _nameProduct,
    PRODUCT_ID: _productId,
    PRICE_PRODUCT: _priceProduct,
    IMAGE_LENS: _imageLens ?? '' ,
    NAME_LENS: _nameLens ?? '' ,
    LENS_ID: _lensId ?? '' ,
    PRICE_LENS: _priceLens ?? '' ,
    TOTAL_PRICE_CART: _totalPriceCart,
    ADJUST_LENS: adjustLens ?? ''
    /*QUANTITY: _quantity*/
  };

}

