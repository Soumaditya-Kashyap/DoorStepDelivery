import 'package:project/helper/utils/generalImports.dart';

class HomeScreenProductListItem extends StatelessWidget {
  final ProductListItem product;
  final int position;
  final double? padding;
  final double? borderRadius;

  const HomeScreenProductListItem(
      {Key? key,
      required this.product,
      required this.position,
      this.padding,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Variants>? variants = product.variants;
    return variants!.isNotEmpty
        ? Consumer<ProductListProvider>(
            builder: (context, productListProvider, _) {
              return ChangeNotifierProvider<SelectedVariantItemProvider>(
                create: (context) => SelectedVariantItemProvider(),
                child: Container(
                  height: context.width * 0.8,
                  width: context.width * 0.45,
                  margin: EdgeInsets.symmetric(
                      horizontal: padding ?? 5, vertical: padding ?? 5),
                  decoration: DesignConfig.boxDecoration(
                    Theme.of(context).cardColor,
                    borderRadius ?? 12,
                    isboarder: true,
                    bordercolor:
                        ColorsRes.subTitleMainTextColor.withValues(alpha: 0.1),
                    borderwidth: 1,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius ?? 12),
                      onTap: () {
                        Navigator.pushNamed(context, productDetailScreen,
                            arguments: [
                              product.id.toString(),
                              product.name,
                              product
                            ]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: Consumer<SelectedVariantItemProvider>(
                                    builder: (context,
                                        selectedVariantItemProvider, child) {
                                      return Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                borderRadius ?? 10,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                borderRadius ?? 10,
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: setNetworkImg(
                                                boxFit: BoxFit.cover,
                                                image: product.imageUrl ?? "",
                                                height: context.width,
                                                width: context.width,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        borderRadius ?? 10),
                                              ),
                                            ),
                                          ),
                                          PositionedDirectional(
                                            bottom: 8,
                                            end: 8,
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  if (product.indicator
                                                          .toString() ==
                                                      "1")
                                                    defaultImg(
                                                      height: 20,
                                                      width: 20,
                                                      image:
                                                          "product_veg_indicator",
                                                      boxFit: BoxFit.cover,
                                                    ),
                                                  if (product.indicator
                                                          .toString() ==
                                                      "2")
                                                    defaultImg(
                                                        height: 20,
                                                        width: 20,
                                                        image:
                                                            "product_non_veg_indicator",
                                                        boxFit: BoxFit.cover),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextLabel(
                                        text: product.name ?? "",
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: ColorsRes.mainTextColor,
                                            height: 1.2),
                                      ),
                                      SizedBox(height: 4),
                                      ProductListRatingBuilderWidget(
                                        averageRating: product.averageRating
                                            .toString()
                                            .toDouble,
                                        totalRatings: product.ratingCount
                                            .toString()
                                            .toInt,
                                        size: 12,
                                        spacing: 2,
                                      ),
                                      SizedBox(height: 8),
                                      ProductVariantDropDownMenuGrid(
                                        variants: variants,
                                        from: "",
                                        product: product,
                                        isGrid: true,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            PositionedDirectional(
                              end: 8,
                              top: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ProductWishListIcon(
                                  product: product,
                                ),
                              ),
                            ),
                            Builder(
                              builder: (context) {
                                double discountPercentage = 0.0;
                                if (product.variants!.first.discountedPrice
                                        .toString()
                                        .toDouble >
                                    0.0) {
                                  discountPercentage = product
                                      .variants!.first.price
                                      .toString()
                                      .toDouble
                                      .calculateDiscountPercentage(product
                                          .variants!.first.discountedPrice
                                          .toString()
                                          .toDouble);
                                }

                                if (discountPercentage > 0.0) {
                                  return PositionedDirectional(
                                    start: 8,
                                    top: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red[400]!,
                                            Colors.red[600]!
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: CustomTextLabel(
                                        text:
                                            "${discountPercentage.toStringAsFixed(0)}% ${getTranslatedValue(context, "off")}",
                                        style: TextStyle(
                                          color: ColorsRes.appColorWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : const SizedBox.shrink();
  }
}
