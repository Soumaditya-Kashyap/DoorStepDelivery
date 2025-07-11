import 'package:project/helper/utils/generalImports.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<OfferImages>> map = {};

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then(
      (value) async {
        await getAppSettings(context: context);

        Map<String, String> params = await Constant.getProductsDefaultParams();
        await context
            .read<HomeScreenProvider>()
            .getHomeScreenApiProvider(context: context, params: params);

        await context
            .read<ProductListProvider>()
            .getProductListProvider(context: context, params: params);

        if (Constant.session.isUserLoggedIn()) {
          await context
              .read<CartProvider>()
              .getCartListProvider(context: context);

          await context
              .read<CartListProvider>()
              .getAllCartItems(context: context);

          await getUserDetail(context: context).then(
            (value) {
              if (value[ApiAndParams.status].toString() == "1") {
                context
                    .read<UserProfileProvider>()
                    .updateUserDataInSession(value, context);
              }
            },
          );
        } else {
          context.read<CartListProvider>().setGuestCartItems();
          if (context.read<CartListProvider>().cartList.isNotEmpty) {
            await context
                .read<CartProvider>()
                .getGuestCartListProvider(context: context);
          }
        }
      },
    );
  }

  // Safe image precaching with timeout and error handling
  Future<void> _safePrecacheImage(String imageUrl, BuildContext context) async {
    if (imageUrl.trim().isEmpty || !mounted) return;

    try {
      // Add timeout to prevent hanging requests
      await precacheImage(
        NetworkImage(imageUrl),
        context,
      ).timeout(
        Duration(seconds: 10), // 10 second timeout
        onTimeout: () {
          // Handle timeout gracefully
          if (kDebugMode) {
            print('Image precache timeout for: $imageUrl');
          }
        },
      );
    } catch (e) {
      // Handle any network or image loading errors silently
      if (kDebugMode) {
        print('Image precache error for: $imageUrl - Error: $e');
      }
    }
  }

  scrollListener() async {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger =
        0.7 * widget.scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (widget.scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData &&
            context.read<ProductListProvider>().productState !=
                ProductState.loadingMore) {
          Map<String, String> params =
              await Constant.getProductsDefaultParams();

          await context
              .read<ProductListProvider>()
              .getProductListProvider(context: context, params: params);
        }
      }
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: DeliveryAddressWidget(),
        centerTitle: false,
        actions: [
          setNotificationIcon(context: context),
        ],
        showBackButton: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                getSearchWidget(context: context),
                Expanded(
                  child: setRefreshIndicator(
                    refreshCallback: () async {
                      context
                          .read<CartListProvider>()
                          .getAllCartItems(context: context);
                      Map<String, String> params =
                          await Constant.getProductsDefaultParams();
                      return await context
                          .read<HomeScreenProvider>()
                          .getHomeScreenApiProvider(
                              context: context, params: params);
                    },
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      physics: BouncingScrollPhysics(),
                      child: Consumer<HomeScreenProvider>(
                        builder: (context, homeScreenProvider, _) {
                          map = homeScreenProvider.homeOfferImagesMap;
                          if (homeScreenProvider.homeScreenState ==
                              HomeScreenState.loaded) {
                            // Safely precache slider images with error handling
                            for (int i = 0;
                                i <
                                    homeScreenProvider
                                        .homeScreenData.sliders!.length;
                                i++) {
                              _safePrecacheImage(
                                homeScreenProvider
                                        .homeScreenData.sliders?[i].imageUrl ??
                                    "",
                                context,
                              );
                            }
                            return Column(
                              children: [
                                // Top Sections
                                SectionWidget(position: 'top'),
                                //top offer images
                                if (map.containsKey("top"))
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: OfferImagesWidget(
                                      offerImages: map["top"]!.toList(),
                                    ),
                                  ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ChangeNotifierProvider<
                                      SliderImagesProvider>(
                                    create: (context) => SliderImagesProvider(),
                                    child: SliderImageWidget(
                                      sliders: homeScreenProvider
                                              .homeScreenData.sliders ??
                                          [],
                                    ),
                                  ),
                                ),
                                // Below Slider Sections
                                SectionWidget(position: 'below_slider'),
                                //below slider offer images
                                if (map.containsKey("below_slider"))
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: OfferImagesWidget(
                                      offerImages:
                                          map["below_slider"]!.toList(),
                                    ),
                                  ),
                                if (homeScreenProvider
                                            .homeScreenData.categories !=
                                        null &&
                                    homeScreenProvider
                                        .homeScreenData.categories!.isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: CategoryWidget(
                                        categories: homeScreenProvider
                                            .homeScreenData.categories),
                                  ),
                                //below category offer images
                                if (map.containsKey("below_category"))
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: OfferImagesWidget(
                                      offerImages:
                                          map["below_category"]!.toList(),
                                    ),
                                  ),
                                // Below Category Sections
                                SectionWidget(position: 'below_category'),
                                // Shop By Brands
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: BrandWidget(),
                                ),
                                // Below Shop By Seller Sections
                                SectionWidget(
                                    position: 'custom_below_shop_by_brands'),
                                // Shop By Sellers
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: SellerWidget(),
                                ),
                                // Below Shop By Seller Sections
                                SectionWidget(position: 'below_shop_by_seller'),
                                // Shop By Country Of Origin
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: CountryOfOriginWidget(),
                                ),
                                // Below Country Of Origin Sections
                                SectionWidget(
                                    position:
                                        'below_shop_by_country_of_origin'),
                                // All Products Sections
                                getSizedBox(height: 10),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: TitleHeaderWithViewAllOption(
                                    title: getTranslatedValue(
                                        context, "all_products"),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        productListScreen,
                                        arguments: [
                                          "home",
                                          "0",
                                          "all_products"
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                getSizedBox(height: 10),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: ProductWidget(from: "product_listing"),
                                ),
                                if (context
                                        .watch<CartProvider>()
                                        .totalItemsCount >
                                    0)
                                  getSizedBox(height: 75),
                                getSizedBox(height: 20), // Bottom padding
                              ],
                            );
                          } else if (homeScreenProvider.homeScreenState ==
                                  HomeScreenState.loading ||
                              homeScreenProvider.homeScreenState ==
                                  HomeScreenState.initial) {
                            return getHomeScreenShimmer(context);
                          } else {
                            return NoInternetConnectionScreen(
                              height: context.height * 0.65,
                              message: homeScreenProvider.message,
                              callback: () async {
                                Map<String, String> params =
                                    await Constant.getProductsDefaultParams();
                                await context
                                    .read<HomeScreenProvider>()
                                    .getHomeScreenApiProvider(
                                        context: context, params: params);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (context.watch<CartProvider>().totalItemsCount > 0)
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: CartOverlay(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
