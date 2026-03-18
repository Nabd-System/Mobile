class AppEndpoints {
  static const String baseUrl = 'https://codingarabic.online/api';

  // auth
  static const String login = '/login';
  static const String register = '/register';

  // home
  static const String newArrivalsBooks = '/products-new-arrivals';
  static const String sliders = '/sliders';

  // wishlist
  static const String addToWishlist = '/add-to-wishlist';
  static const String removeFromWishlist = '/remove-from-wishlist';
  static const String getWishlist = '/wishlist';

  // cart
  static const String addToCart = '/add-to-cart';
  static const String removeFromCart = '/remove-from-cart';
  static const String getCart = '/cart';
  static const String updateCart = '/update-cart';

  // checkout
  static const String checkout = '/checkout';
  static const String placeOrder = '/place-order';

  // profile
  static const String getProfile = '/profile';
  static const String updateProfile = '/update-profile';
}
