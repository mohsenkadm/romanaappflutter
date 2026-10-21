class AppLink { 
  static const String apiUrl="www.rummana.info";
//========================== imagestCategories ============================
  static const String getAllCategories = "Categories/GetAll";
//========================== imagestCategories ============================
  static const String getAllCarousel = "Carousel/GetAllApp";
  /// 1 = تطبيق الزبون
  static const int carouselAppType = 1;
//========================== imagestCategories ============================
  static const String getNotification= "Notification/GetNotificationAll";
//========================== getRestaurantAllForApp (DEPRECATED - use getRestaurantByLocation) ============================
  static const String getRestaurantAllForApp= "GetAllForApp";     
//========================== getRestaurantAllForApp ============================
  static const String getRestaurantById= "Restaurant/GetById";            
//========================== getRestaurantTopAllForApp (DEPRECATED - use getRestaurantByLocation) ============================
  static const String getRestaurantTopAllForApp= "GetTopAllForApp";
//========================== GetByUserLocation (Section 1.2 - replaces GetAllForApp & GetTopAllForApp) ============================
  // GET ?lat=X&lng=Y&radius_km=Z(optional)
  static const String getRestaurantByLocation= "Restaurant/GetByUserLocation";
//========================== getRestaurantSubCategories ============================
  static const String getRestaurantSubCategories= "RestaurantSubCategories/GetByResId/"; 
//========================== getProductsByRestaurantId ============================
  static const String getProductsByRestaurantId= "Products/GetByRestaurantId/";  
//========================== getProductsallBySearch ============================
  static const String getProductsallBySearch= "Products/GetAllBySearch/";  
//========================== getProductsByRestaurantId ============================
  static const String getProductsById= "Products/GetById/";  
//========================== getRestaurantAllForApp ============================
  static const String getPromoCode= "PromoCode/GetAll"; 
//========================== getRestaurantAllForApp ============================
  static const String getStarsByRestaurantId= "Products/GetByRestaurantId"; 
//========================== GetOrdersByOrderNoAndUserId ============================
  static const String getMyOrder= "GetOrdersByOrderNoAndUserId"; 
//========================== GetOrdersWithDetailAll ============================
  static const String getOrdersWithDetailAll= "Orders/GetOrdersWithDetailAll"; 
//========================== City-GetAll ============================
  static const String getcity= "City/GetAll"; 
//========================== Countries-GetAll ============================
  static const String getCountries= "Countries/GetAll"; 
//========================== City-GetByCountriesId ============================
  static const String getcityGetByCountriesId= "City/GetByCountriesId"; 

//========================== Order-Post ============================
  static const String sendOrder= "Orders/Post"; 
//========================== Stars-Post ============================
  static const String sendStars= "Stars/Post"; 
  
//========================== RestaurantCity/GetByResId ============================
  static const String RestaurantCityGetByResId= "RestaurantCity/GetByResId"; 
  //========================== OTP WhatsApp login (2026) ============================
  static String sendOtpLogin(String phone) => "Users/Login/SendOtp/$phone";
  static String verifyOtpLogin(String phone, String code) =>
      "Users/Login/VerifyOtp/$phone,$code";
  static String refreshToken(int userId) => "Users/RefreshToken/$userId";

  //========================== App splash ============================
  static const String appSplashGetForApp = "AppSplash/GetForApp";

  //========================== Products 2026 ============================
  /// الأكثر مبيعاً / طلباً للمطعم — عادةً 4 منتجات.
  static String topSellingByRestaurant(int restaurantId) =>
      "Products/GetTopSellingByRestaurant/$restaurantId";

  //========================== Orders full details ============================
  static String getOrderFullDetails(int orderId) =>
      "Orders/GetOrderFullDetails/$orderId";

  /// إلغاء الطلب من الزبون قبل خروجه للتوصيل / التسليم.
  static String cancelByUser(int orderId) => "Orders/CancelByUser/$orderId";
  /// لا تستخدم من تطبيق الزبون — للمطعم/الأدمن فقط.
  static String setIsCancel(int orderId) => "Orders/SetIsCancel/$orderId";

  /// Live driver position for an order (customer JWT). Backend pending.
  static String getDriverLocation(int orderId) =>
      "dispatch/orders/$orderId/driver-location";

  //========================== Promo 2026 ============================
  static const String validatePromoCodeGet = "PromoCode/ValidatePromoCode";
  static const String applyPromoCode = "PromoCode/ApplyPromoCode";

  //========================== login-user (legacy) ============================
  static const String loginUsers= "Users/Login"; 
//========================== PostUsers ============================
  static const String PostUsers= "Users/Post";
  //========================== Update profile + phone-change OTP ============================
  static const String updateProfile = "Users/UpdateProfile";
  static const String resendPhoneChangeOtp = "Users/ResendPhoneChangeOtp";
  static String confirmPhoneChange(String code) =>
      "Users/ConfirmPhoneChange/$code";
//========================== getuserById (Admin فقط — لا تستدعِ من تطبيق الزبون) ============================
  // static const String getuserById= "Users/GetById";     
//========================== forgatepassUsers ============================
  static const String forgatepassUsers= "Users/ForgatePassword/";            
//========================== ConfirmCode ============================
  static const String ConfirmCode= "Users/ConfirmCode/";             
//========================== Update_Pass_WithCode ============================
  static const String Update_Pass_WithCode= "Users/Update_Pass_WithCode/";            
//========================== SendOTPCodeToPhoneNo ============================
  static const String SendOTPCodeToPhoneNo= "Users/SendOTPCodeToPhoneNo/";            
//========================== DeleteUser (Admin فقط — لا تستدعِ من تطبيق الزبون) ============================
  // static const String DeleteUser= "Users/Delete";   
           
  static const String getQuestions= "Questions/GetAllApp";            

  //========================== pricing / coverage (LZA/ECA) ============================
  static const String pricingQuote = "pricing/quote";
  static const String pricingCoverageCheck = "pricing/coverage/check";
  static const String pricingZonesResolve = "pricing/zones/resolve";
  static const String coverageRequests = "coverage-requests";
  static String getDeliveryFee(int restaurantId, int cityId) =>
      "RestaurantCity/GetDeliveryFee/$restaurantId/$cityId";

  //========================== Products Sizes & Ingredients ============================
  static const String getSizesByProductId= "Products/GetSizesByProductId/";
  static const String getIngredientsByProductId= "Products/GetIngredientsByProductId/";

  //========================== Orders/GetOrdersWithDetailAll ============================
  static const String getOrderById= "Orders/GetOrdersWithDetailAll/";

  //========================== promo code validation (scope/limits/cap) ============================
  static const String validatePromoCode = "PromoCode/Validate";

  //========================== order ratings (food + driver) ============================
  // Usage: "orders/$orderId/rating/store"  and  "orders/$orderId/rating/driver"
  static String ratingStore(int orderId) => "orders/$orderId/rating/store";
  static String ratingDriver(int orderId) => "orders/$orderId/rating/driver";

  //========================== support phone (admin-managed, no auth) ============================
  static const String supportPhoneForApp = "SupportPhone/GetForApp";
  static const String supportPhoneAllForApps = "SupportPhone/GetAllForApps";
}