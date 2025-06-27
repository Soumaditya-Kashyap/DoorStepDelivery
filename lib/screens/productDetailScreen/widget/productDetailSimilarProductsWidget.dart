import 'package:project/helper/utils/generalImports.dart';

class ProductDetailSimilarProductsWidget extends StatefulWidget {
  final String tags;
  final String slug;

  ProductDetailSimilarProductsWidget({
    super.key,
    required this.tags,
    required this.slug,
  });

  @override
  State<ProductDetailSimilarProductsWidget> createState() =>
      _ProductDetailSimilarProductsWidgetState();
}

class _ProductDetailSimilarProductsWidgetState
    extends State<ProductDetailSimilarProductsWidget> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData) {
          callApi();
        }
      }
    }
  }

  callApi() async {
    try {
      if (widget.slug.isEmpty || widget.tags.toString() == "null") {
        return;
      }
      context.read<ProductListProvider>().offset = 0;

      context.read<ProductListProvider>().products = [];

      Map<String, String> params = await Constant.getProductsDefaultParams();

      params[ApiAndParams.sort] = "0";
      params[ApiAndParams.tagNames] = widget.tags.toString();
      params[ApiAndParams.tagSlug] = widget.slug.toString();

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
      callApi();
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
    return Consumer<ProductListProvider>(
      builder: (context, productListProvider, _) {
        if (productListProvider.products.length > 0 &&
            (productListProvider.productState == ProductState.loaded ||
                productListProvider.productState == ProductState.loadingMore)) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Enhanced Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorsRes.appColor.withValues(alpha: 0.2),
                              ColorsRes.appColor.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.recommend_outlined,
                          color: ColorsRes.appColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomTextLabel(
                          jsonKey: "similar_products",
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Enhanced Products List with Fixed Dimensions
                Container(
                  height: 240, // Increased height for better product display
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: List.generate(
                          productListProvider.products.length, (index) {
                        ProductListItem product =
                            productListProvider.products[index];
                        return Container(
                          width: 160, // Fixed width to prevent overflow
                          margin: EdgeInsets.only(right: 12),
                          child: ProductGridItemContainer(
                            product: product,
                          ),
                        );
                      })
                        ..addAll([
                          if (productListProvider.productState ==
                              ProductState.loadingMore)
                            Container(
                              width: 160,
                              margin: EdgeInsets.only(right: 12),
                              child: getProductItemShimmer(
                                  context: context, isGrid: true),
                            ),
                        ]),
                    ),
                  ),
                ),

                SizedBox(height: 8),
              ],
            ),
          );
        } else if (productListProvider.productState == ProductState.loading) {
          return Container();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
