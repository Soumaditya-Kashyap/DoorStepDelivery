import 'package:project/helper/generalWidgets/ratingImagesWidget.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'package:project/screens/productDetailScreen/widget/otherImagesViewWidget.dart';
import 'package:project/screens/productDetailScreen/widget/productDetailImportantInformationWidget.dart';
import 'package:project/screens/productDetailScreen/widget/productDetailSimilarProductsWidget.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class ProductDetailWidget extends StatefulWidget {
  final BuildContext context;
  final ProductData product;

  ProductDetailWidget(
      {super.key, required this.context, required this.product});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  late QuillEditorController quillEditorController;

  @override
  void initState() {
    quillEditorController = QuillEditorController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Enhanced Image Section with improved layout
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  // Thumbnail images (if multiple images)
                  if (context
                          .read<ProductDetailProvider>()
                          .productData
                          .images
                          .length >
                      1)
                    Container(
                      width: 70,
                      child: OtherImagesViewWidget(
                          context, Axis.vertical, constraints),
                    ),

                  // Main product image
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          fullScreenProductImageScreen,
                          arguments: [
                            context.read<ProductDetailProvider>().currentImage,
                            context.read<ProductDetailProvider>().images,
                          ],
                        );
                      },
                      child: Consumer<SelectedVariantItemProvider>(
                        builder: (context, selectedVariantItemProvider, child) {
                          return Container(
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withValues(alpha: 0.02),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 1.0, // Square aspect ratio
                                child: setNetworkImg(
                                  boxFit: BoxFit.cover,
                                  image: context
                                          .read<ProductDetailProvider>()
                                          .images[
                                      context
                                          .read<ProductDetailProvider>()
                                          .currentImage],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Enhanced Product Information Card
        Container(
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
          child: Consumer<SelectedVariantItemProvider>(
            builder: (context, selectedVariantItemProvider, _) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name with better typography
                    CustomTextLabel(
                      text: widget.product.name,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ColorsRes.mainTextColor,
                        height: 1.3,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Enhanced Price and Rating Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Current Price
                              CustomTextLabel(
                                text: double.parse(widget
                                            .product
                                            .variants[
                                                selectedVariantItemProvider
                                                    .getSelectedIndex()]
                                            .discountedPrice) !=
                                        0
                                    ? widget
                                        .product
                                        .variants[selectedVariantItemProvider
                                            .getSelectedIndex()]
                                        .discountedPrice
                                        .currency
                                    : widget
                                        .product
                                        .variants[selectedVariantItemProvider
                                            .getSelectedIndex()]
                                        .price
                                        .currency,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ColorsRes.appColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              // Original Price (if discounted)
                              if (double.parse(widget
                                      .product.variants[0].discountedPrice) !=
                                  0) ...[
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    CustomTextLabel(
                                      text: widget
                                          .product.variants[0].price.currency,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorsRes.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: CustomTextLabel(
                                        text:
                                            "${((double.parse(widget.product.variants[0].price) - double.parse(widget.product.variants[0].discountedPrice)) / double.parse(widget.product.variants[0].price) * 100).toStringAsFixed(0)}% OFF",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Enhanced Rating Section
                        if (context
                                .read<RatingListProvider>()
                                .totalData
                                .toString()
                                .toInt >
                            0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: ColorsRes.appColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    ColorsRes.appColor.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                ProductListRatingBuilderWidget(
                                  averageRating: context
                                      .read<RatingListProvider>()
                                      .productRatingData
                                      .averageRating
                                      .toString()
                                      .toDouble,
                                  totalRatings: context
                                      .read<RatingListProvider>()
                                      .totalData
                                      .toString()
                                      .toInt,
                                  size: 14,
                                  spacing: 1,
                                ),
                                SizedBox(height: 2),
                                CustomTextLabel(
                                  text:
                                      "${context.read<RatingListProvider>().totalData} reviews",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: ColorsRes.appColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Enhanced Add to Cart Button
                    ProductDetailAddToCartButtonWidget(
                      context: context,
                      product: widget.product,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Important Information Widget
        ProductDetailImportantInformationWidget(context, widget.product),

        SizedBox(height: 8),

        // Enhanced Product Specifications Card
        Container(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              childrenPadding: EdgeInsets.zero,
              backgroundColor: Theme.of(context).cardColor,
              collapsedBackgroundColor: Theme.of(context).cardColor,
              collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              initiallyExpanded: true,
              title: CustomTextLabel(
                jsonKey: "product_specifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ColorsRes.mainTextColor,
                ),
              ),
              leading: Container(
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
                  Icons.info_outline_rounded,
                  color: ColorsRes.appColor,
                  size: 20,
                ),
              ),
              iconColor: ColorsRes.mainTextColor,
              collapsedIconColor: ColorsRes.mainTextColor,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      getSpecificationItem(
                        titleJson: "fssai_lic_no",
                        value: widget.product.fssaiLicNo.toString(),
                        voidCallback: () {},
                        isClickable: false,
                      ),
                      getSpecificationItem(
                        titleJson: "category",
                        value: widget.product.categoryName.toString(),
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "category",
                              widget.product.categoryId.toString(),
                              widget.product.categoryName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "seller_name",
                        value: widget.product.sellerName,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "seller",
                              widget.product.sellerId.toString(),
                              widget.product.sellerName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "brand",
                        value: widget.product.brandName,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "brand",
                              widget.product.brandId.toString(),
                              widget.product.brandName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "made_in",
                        value: widget.product.madeIn,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "country",
                              widget.product.madeInId.toString(),
                              widget.product.madeIn.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "manufacturer",
                        value: widget.product.manufacturer,
                        voidCallback: () {},
                        isClickable: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Enhanced Product Overview Card
        Container(
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              childrenPadding: EdgeInsets.zero,
              backgroundColor: Theme.of(context).cardColor,
              collapsedBackgroundColor: Theme.of(context).cardColor,
              collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              initiallyExpanded: true,
              title: CustomTextLabel(
                jsonKey: "product_overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ColorsRes.mainTextColor,
                ),
              ),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.blue.shade600,
                  size: 20,
                ),
              ),
              iconColor: ColorsRes.mainTextColor,
              collapsedIconColor: ColorsRes.mainTextColor,
              maintainState: true,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: CustomTextLabel(
                    text: widget.product.description
                        .replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
                    softWrap: true,
                    style: TextStyle(
                      color: ColorsRes.mainTextColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Enhanced Ratings and Reviews Section
        Consumer<RatingListProvider>(
          builder: (context, ratingListProvider, child) {
            if (ratingListProvider.ratings.length > 0) {
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ExpansionTile(
                    tilePadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    childrenPadding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).cardColor,
                    collapsedBackgroundColor: Theme.of(context).cardColor,
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    initiallyExpanded: true,
                    title: CustomTextLabel(
                      jsonKey: "ratings_and_reviews",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.star_outline_rounded,
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                    ),
                    iconColor: ColorsRes.appColor,
                    collapsedIconColor: ColorsRes.appColor,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            getOverallRatingSummary(
                                context: context,
                                productRatingData:
                                    ratingListProvider.productRatingData,
                                totalRatings:
                                    ratingListProvider.totalData.toString()),
                            if (ratingListProvider.totalImages > 0) ...[
                              SizedBox(height: 20),
                              CustomTextLabel(
                                text:
                                    "${getTranslatedValue(context, "customer_photos")}(${ratingListProvider.totalImages})",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              SizedBox(height: 12),
                              RatingImagesWidget(
                                images: ratingListProvider.images,
                                from: "productDetails",
                                productId: widget.product.id,
                                totalImages: ratingListProvider.totalImages,
                              ),
                            ],
                            SizedBox(height: 20),
                            CustomTextLabel(
                              jsonKey: "customer_reviews",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                            SizedBox(height: 16),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: List.generate(
                                ratingListProvider.ratings.length,
                                (index) {
                                  ProductRatingList rating =
                                      ratingListProvider.ratings[index];
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey
                                                .withValues(alpha: 0.15),
                                            width: 1,
                                          ),
                                        ),
                                        child:
                                            getRatingReviewItem(rating: rating),
                                      ),
                                      if (index <
                                          ratingListProvider.ratings.length - 1)
                                        SizedBox(height: 12),
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (ratingListProvider.totalData > 5) ...[
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ratingAndReviewScreen,
                                      arguments: widget.product.id.toString());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: ColorsRes.appColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorsRes.appColor
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomTextLabel(
                                        text:
                                            "${getTranslatedValue(context, "view_all_reviews_title")} ${ratingListProvider.totalData.toString().toInt} ${getTranslatedValue(context, "reviews")}",
                                        style: TextStyle(
                                          color: ColorsRes.appColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: ColorsRes.appColor,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),

        // Similar Products Section
        ChangeNotifierProvider<ProductListProvider>(
          create: (context) => ProductListProvider(),
          child: ProductDetailSimilarProductsWidget(
            tags: context
                .read<ProductDetailProvider>()
                .productDetail
                .data
                .tagNames,
            slug: context.read<ProductDetailProvider>().productDetail.data.slug,
          ),
        ),

        // Bottom spacing
        SizedBox(height: 20),
      ],
    );
  }
}

Widget getSpecificationItem({
  required String titleJson,
  required String value,
  required VoidCallback voidCallback,
  required bool isClickable,
}) {
  if (value != "null" && value != "") {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomTextLabel(
              jsonKey: titleJson,
              softWrap: true,
              style: TextStyle(
                color: ColorsRes.subTitleMainTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: voidCallback,
              child: CustomTextLabel(
                text: value,
                softWrap: true,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: isClickable
                      ? ColorsRes.appColor
                      : ColorsRes.mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isClickable) ...[
            SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorsRes.appColor,
              size: 12,
            ),
          ],
        ],
      ),
    );
  } else {
    return SizedBox.shrink();
  }
}
