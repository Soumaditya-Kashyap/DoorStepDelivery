import 'package:project/helper/utils/generalImports.dart';

class ProductListScreen extends StatefulWidget {
  final String? title;
  final String from;
  final String id;

  const ProductListScreen(
      {Key? key, this.title, required this.from, required this.id})
      : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isFilterApplied = false;
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData &&
            context.read<ProductListProvider>().productState !=
                ProductState.loadingMore) {
          callApi(isReset: false);
        }
      }
    }
  }

  callApi({required bool isReset}) async {
    try {
      if (isReset) {
        context.read<ProductListProvider>().offset = 0;

        context.read<ProductListProvider>().products = [];
      }

      Map<String, String> params = await Constant.getProductsDefaultParams();

      params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
          context.read<ProductListProvider>().currentSortByOrderIndex];
      if (widget.from == "category") {
        params[ApiAndParams.categoryId] = widget.id.toString();
      } else if (widget.from == "brand") {
        params[ApiAndParams.brandId] = widget.id.toString();
      } else if (widget.from == "seller") {
        params[ApiAndParams.sellerId] = widget.id.toString();
      } else if (widget.from == "country") {
        params[ApiAndParams.countryId] = widget.id.toString();
      } else if (widget.from == "sections") {
        params[ApiAndParams.sectionId] = widget.id.toString();
      }

      params = await setFilterParams(params);

      await context
          .read<ProductListProvider>()
          .getProductListProvider(context: context, params: params);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      scrollController.addListener(scrollListener);
      callApi(isReset: true);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List lblSortingDisplayList = [
      "sorting_display_list_default",
      "sorting_display_list_newest_first",
      "sorting_display_list_oldest_first",
      "sorting_display_list_price_high_to_low",
      "sorting_display_list_price_low_to_high",
      "sorting_display_list_discount_high_to_low",
      "sorting_display_list_popularity"
    ];
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: widget.title ??
              getTranslatedValue(
                context,
                "products",
              ),
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              getSearchWidget(
                context: context,
              ),
              getSizedBox(
                height: 3,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                  border: Border.all(
                    color:
                        ColorsRes.subTitleMainTextColor.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Enhanced Filter Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(
                            context,
                            productListFilterScreen,
                            arguments: [
                              context
                                  .read<ProductListProvider>()
                                  .productList
                                  .brands,
                              double.parse(context
                                          .read<ProductListProvider>()
                                          .productList
                                          .totalMaxPrice) !=
                                      0
                                  ? double.parse(context
                                      .read<ProductListProvider>()
                                      .productList
                                      .totalMaxPrice)
                                  : double.parse(context
                                      .read<ProductListProvider>()
                                      .productList
                                      .totalMaxPrice),
                              double.parse(context
                                          .read<ProductListProvider>()
                                          .productList
                                          .totalMinPrice) !=
                                      0
                                  ? double.parse(context
                                      .read<ProductListProvider>()
                                      .productList
                                      .totalMinPrice)
                                  : double.parse(context
                                      .read<ProductListProvider>()
                                      .productList
                                      .totalMinPrice),
                              context
                                  .read<ProductListProvider>()
                                  .productList
                                  .sizes,
                              Constant.selectedCategories,
                            ],
                          ).then((value) async {
                            if (value == true) {
                              context.read<ProductListProvider>().offset = 0;
                              context.read<ProductListProvider>().products = [];

                              callApi(isReset: true);
                            }
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isFilterApplied
                                ? ColorsRes.appColor.withValues(alpha: 0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isFilterApplied
                                          ? ColorsRes.appColor
                                          : ColorsRes.appColor
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: defaultImg(
                                      image: "filter_icon",
                                      height: 14,
                                      width: 14,
                                      iconColor: isFilterApplied
                                          ? Colors.white
                                          : ColorsRes.appColor,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: CustomTextLabel(
                                      jsonKey: "filter",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isFilterApplied
                                            ? ColorsRes.appColor
                                            : ColorsRes.mainTextColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Filter count indicator
                              if (isFilterApplied)
                                Positioned(
                                  right: 0,
                                  top: -2,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: ColorsRes.appColor,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 6,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 0.5,
                      height: 20,
                      color: ColorsRes.subTitleMainTextColor
                          .withValues(alpha: 0.15),
                    ),

                    // Enhanced Sort Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context1) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Handle bar
                                    Container(
                                      width: 32,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: ColorsRes.subTitleMainTextColor
                                            .withValues(alpha: 0.3),
                                        borderRadius:
                                            BorderRadius.circular(1.5),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Header
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: ColorsRes.appColor
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: defaultImg(
                                            image: "sorting_icon",
                                            height: 16,
                                            width: 16,
                                            iconColor: ColorsRes.appColor,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextLabel(
                                            jsonKey: "sort_by",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: ColorsRes.mainTextColor,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: ColorsRes
                                                  .subTitleMainTextColor
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: ColorsRes.mainTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20),

                                    // Sort options
                                    ...List.generate(
                                      ApiAndParams.productListSortTypes.length,
                                      (index) {
                                        bool isSelected = context
                                                .read<ProductListProvider>()
                                                .currentSortByOrderIndex ==
                                            index;

                                        return GestureDetector(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            context
                                                .read<ProductListProvider>()
                                                .products = [];
                                            context
                                                .read<ProductListProvider>()
                                                .offset = 0;
                                            context
                                                    .read<ProductListProvider>()
                                                    .currentSortByOrderIndex =
                                                index;
                                            callApi(isReset: true);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 6),
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? ColorsRes.appColor
                                                      .withValues(alpha: 0.08)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: isSelected
                                                    ? ColorsRes.appColor
                                                        .withValues(alpha: 0.2)
                                                    : Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 16,
                                                  height: 16,
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? ColorsRes.appColor
                                                        : Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? ColorsRes.appColor
                                                          : ColorsRes
                                                              .subTitleMainTextColor
                                                              .withValues(
                                                                  alpha: 0.4),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: isSelected
                                                      ? Icon(
                                                          Icons.check,
                                                          size: 10,
                                                          color: Colors.white,
                                                        )
                                                      : null,
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: CustomTextLabel(
                                                    jsonKey:
                                                        lblSortingDisplayList[
                                                            index],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.w400,
                                                      color: isSelected
                                                          ? ColorsRes.appColor
                                                          : ColorsRes
                                                              .mainTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    SizedBox(height: 16),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      ColorsRes.appColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: defaultImg(
                                  image: "sorting_icon",
                                  height: 14,
                                  width: 14,
                                  iconColor: ColorsRes.appColor,
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: CustomTextLabel(
                                  jsonKey: "sort_by",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 0.5,
                      height: 20,
                      color: ColorsRes.subTitleMainTextColor
                          .withValues(alpha: 0.15),
                    ),

                    // Enhanced View Toggle Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<ProductChangeListingTypeProvider>()
                              .changeListingType();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      ColorsRes.appColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: defaultImg(
                                  image: context
                                              .watch<
                                                  ProductChangeListingTypeProvider>()
                                              .getListingType() ==
                                          false
                                      ? "grid_view_icon"
                                      : "list_view_icon",
                                  height: 14,
                                  width: 14,
                                  iconColor: ColorsRes.appColor,
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(
                                child: CustomTextLabel(
                                  text: context
                                              .watch<
                                                  ProductChangeListingTypeProvider>()
                                              .getListingType() ==
                                          false
                                      ? getTranslatedValue(context, "grid_view")
                                      : getTranslatedValue(
                                          context, "list_view"),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: setRefreshIndicator(
                  refreshCallback: () async {
                    context
                        .read<CartListProvider>()
                        .getAllCartItems(context: context);
                    context.read<ProductListProvider>().offset = 0;
                    context.read<ProductListProvider>().products = [];

                    callApi(isReset: true);
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: ProductWidget(
                      voidCallBack: () {
                        callApi(isReset: false);
                      },
                      from: "product_listing",
                    ),
                  ),
                ),
              )
            ],
          ),
          if (context.watch<CartProvider>().totalItemsCount > 0)
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: CartOverlay(),
            ),
        ],
      ),
    );
  }
}
