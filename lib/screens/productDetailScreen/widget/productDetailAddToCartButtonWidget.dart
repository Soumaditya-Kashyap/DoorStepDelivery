import 'package:project/helper/utils/generalImports.dart';

Widget ProductDetailAddToCartButtonWidget({
  required BuildContext context,
  required ProductData product,
  Color? bgColor,
  double? padding,
}) {
  return Container(
    color: bgColor,
    padding:
        EdgeInsetsDirectional.only(top: padding ?? 0, bottom: padding ?? 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Variant Selector Section
        Consumer<SelectedVariantItemProvider>(
          builder: (context, selectedVariantItemProvider, _) {
            return Padding(
              padding: EdgeInsetsDirectional.only(
                start: padding ?? 0,
                end: padding ?? 0,
                bottom: 12,
              ),
              child: GestureDetector(
                onTap: () {
                  if (product.variants.length > 1) {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      shape: DesignConfig.setRoundedBorderSpecific(20,
                          istop: true),
                      backgroundColor: Theme.of(context).cardColor,
                      builder: (BuildContext modalContext) {
                        return ChangeNotifierProvider.value(
                          value: selectedVariantItemProvider,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(modalContext).cardColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.size15,
                                end: Constant.size15,
                                top: Constant.size15,
                                bottom: Constant.size15),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size15,
                                      end: Constant.size15),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: Constant.borderRadius10,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: setNetworkImg(
                                              boxFit: BoxFit.fill,
                                              image: product.imageUrl,
                                              height: 70,
                                              width: 70)),
                                      getSizedBox(width: Constant.size10),
                                      Expanded(
                                        child: CustomTextLabel(
                                          text: product.name,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: ColorsRes.mainTextColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size15,
                                      end: Constant.size15,
                                      top: Constant.size15,
                                      bottom: Constant.size15),
                                  child: Consumer<SelectedVariantItemProvider>(
                                      builder: (context,
                                          selectedVariantProvider, _) {
                                    return ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: product.variants.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            selectedVariantProvider
                                                .setSelectedIndex(index);
                                            Navigator.pop(modalContext);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: selectedVariantProvider
                                                          .getSelectedIndex() ==
                                                      index
                                                  ? ColorsRes.appColor
                                                      .withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: selectedVariantProvider
                                                            .getSelectedIndex() ==
                                                        index
                                                    ? ColorsRes.appColor
                                                    : Colors.grey
                                                        .withValues(alpha: 0.3),
                                                width: selectedVariantProvider
                                                            .getSelectedIndex() ==
                                                        index
                                                    ? 2
                                                    : 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                CustomTextLabel(
                                                              text:
                                                                  "${product.variants[index].measurement} ${product.variants[index].stockUnitName}",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: ColorsRes
                                                                    .mainTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          if (double.parse(product
                                                                  .variants[
                                                                      index]
                                                                  .discountedPrice) !=
                                                              0) ...[
                                                            SizedBox(width: 8),
                                                            CustomTextLabel(
                                                              text: product
                                                                  .variants[
                                                                      index]
                                                                  .price
                                                                  .currency,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: ColorsRes
                                                                    .grey,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                decorationThickness:
                                                                    2,
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      CustomTextLabel(
                                                        text: double.parse(product
                                                                    .variants[
                                                                        index]
                                                                    .discountedPrice) !=
                                                                0
                                                            ? product
                                                                .variants[index]
                                                                .discountedPrice
                                                                .currency
                                                            : product
                                                                .variants[index]
                                                                .price
                                                                .currency,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: ColorsRes
                                                              .appColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (selectedVariantProvider
                                                        .getSelectedIndex() ==
                                                    index)
                                                  Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: ColorsRes.appColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(height: 8);
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextLabel(
                                text: "Size : ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorsRes.subTitleMainTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Flexible(
                                child: CustomTextLabel(
                                  text:
                                      "${product.variants[selectedVariantItemProvider.getSelectedIndex()].measurement} ${product.variants[selectedVariantItemProvider.getSelectedIndex()].stockUnitName}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorsRes.mainTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (product.variants.length > 1) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ColorsRes.appColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: defaultImg(
                              image: "ic_drop_down",
                              height: 12,
                              width: 12,
                              boxFit: BoxFit.cover,
                              iconColor: ColorsRes.appColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Add to Cart Button Section
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: padding ?? 0,
            end: padding ?? 0,
          ),
          child: Container(
            height: 56,
            child: Consumer<SelectedVariantItemProvider>(
                builder: (context, selectedVariantItemProvider, _) {
              return ProductCartButton(
                productId: product.id.toString(),
                productVariantId: product
                    .variants[selectedVariantItemProvider.getSelectedIndex()].id
                    .toString(),
                count: int.parse(product
                            .variants[
                                selectedVariantItemProvider.getSelectedIndex()]
                            .status) ==
                        0
                    ? -1
                    : int.parse(product
                        .variants[
                            selectedVariantItemProvider.getSelectedIndex()]
                        .cartCount),
                isUnlimitedStock: product.isUnlimitedStock == "1",
                maximumAllowedQuantity:
                    double.parse(product.totalAllowedQuantity.toString()),
                availableStock: double.parse(product
                    .variants[selectedVariantItemProvider.getSelectedIndex()]
                    .stock),
                isGrid: false,
                sellerId: product.sellerId.toString(),
                from: "product_details",
              );
            }),
          ),
        ),
      ],
    ),
  );
}
