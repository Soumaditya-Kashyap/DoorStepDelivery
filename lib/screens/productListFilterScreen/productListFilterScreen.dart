import 'package:project/helper/utils/generalImports.dart';
import 'package:project/screens/productListFilterScreen/widget/filterCategoryList.dart';

class ProductListFilterScreen extends StatefulWidget {
  final List<Brands> brands;
  final List<Sizes> sizes;
  final double totalMaxPrice;
  final double totalMinPrice;
  final List<String> selectedCategoryId;

  const ProductListFilterScreen({
    Key? key,
    required this.brands,
    required this.sizes,
    required this.totalMaxPrice,
    required this.totalMinPrice,
    required this.selectedCategoryId,
  }) : super(key: key);

  @override
  State<ProductListFilterScreen> createState() =>
      _ProductListFilterScreenState();
}

class _ProductListFilterScreenState extends State<ProductListFilterScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      if (mounted) {
        try {
          await setTempValues().then((value) {
            if (mounted) {
              context.read<ProductFilterProvider>().currentRangeValues =
                  RangeValues(widget.totalMinPrice, widget.totalMaxPrice);
            }
          });
          if (mounted) {
            context.read<ProductFilterProvider>().setCurrentIndex(0);
            context.read<ProductFilterProvider>().setMinMaxPriceRange(
                widget.totalMinPrice, widget.totalMaxPrice);
            context
                .read<ProductFilterProvider>()
                .setCategories(widget.selectedCategoryId);
          }
        } catch (e) {
          print('Error in initState: $e');
        }
      }
    });
  }

  Future<bool> setTempValues() async {
    if (!mounted) return false;

    try {
      context.read<ProductFilterProvider>().currentRangeValues =
          Constant.currentRangeValues;
      context.read<ProductFilterProvider>().selectedBrands =
          Constant.selectedBrands;
      context.read<ProductFilterProvider>().selectedSizes =
          Constant.selectedSizes;
      context.read<ProductFilterProvider>().selectedCategories =
          Constant.selectedCategories;
      return true;
    } catch (e) {
      print('Error in setTempValues: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List lblFilterTypesList = [];
    lblFilterTypesList.add("filter_types_list_category");
    if (widget.brands.isNotEmpty) {
      lblFilterTypesList.add("filter_types_list_brand");
    }

    if (widget.sizes.isNotEmpty) {
      lblFilterTypesList.add("filter_types_list_pack_size");
    }

    if (widget.totalMaxPrice <= 0 && widget.totalMinPrice <= 0) {
      lblFilterTypesList.add("filter_types_list_price");
    }

    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          jsonKey: "filter",
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            return;
          } else {
            Navigator.pop(context, false);
          }
        },
        child: Stack(
          children: [
            //Filter list screen
            PositionedDirectional(
              top: 10,
              bottom: 10,
              start: 10,
              end: (context.width * 0.6) - 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: CustomTextLabel(
                        jsonKey: "filter_by",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    SizedBox(height: 5),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        children: List.generate(
                          lblFilterTypesList.length,
                          (index) {
                            return (index == 2 &&
                                    widget.totalMinPrice ==
                                        widget.totalMaxPrice)
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: context
                                                  .watch<
                                                      ProductFilterProvider>()
                                                  .currentSelectedFilterIndex ==
                                              index
                                          ? ColorsRes
                                              .appColorLightHalfTransparent
                                          : Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        context
                                            .read<ProductFilterProvider>()
                                            .setCurrentIndex(index);
                                      },
                                      selected: context
                                              .watch<ProductFilterProvider>()
                                              .currentSelectedFilterIndex ==
                                          index,
                                      selectedTileColor:
                                          Theme.of(context).cardColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: CustomTextLabel(
                                        jsonKey: lblFilterTypesList[index],
                                        style: TextStyle(
                                          fontWeight: context
                                                      .watch<
                                                          ProductFilterProvider>()
                                                      .currentSelectedFilterIndex ==
                                                  index
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: context
                                                      .watch<
                                                          ProductFilterProvider>()
                                                      .currentSelectedFilterIndex ==
                                                  index
                                              ? ColorsRes.appColorDark
                                              : ColorsRes.mainTextColor,
                                        ),
                                      ),
                                      trailing: context
                                                  .watch<
                                                      ProductFilterProvider>()
                                                  .currentSelectedFilterIndex ==
                                              index
                                          ? Icon(
                                              Icons.circle,
                                              size: 12,
                                              color: ColorsRes.appColor,
                                            )
                                          : null,
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    GestureDetector(
                      onTap: () {
                        context.read<ProductFilterProvider>().resetAllFilters();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 16,
                              color: ColorsRes.appColor,
                            ),
                            SizedBox(width: 5),
                            CustomTextLabel(
                              jsonKey: "clean_all",
                              style: TextStyle(
                                color: ColorsRes.appColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //Filter list's values screen
            PositionedDirectional(
              top: 0,
              bottom: 0,
              start: context.width * 0.4,
              end: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                margin: EdgeInsetsDirectional.only(
                    start: 5, top: 10, bottom: 10, end: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: context
                                    .watch<ProductFilterProvider>()
                                    .currentSelectedFilterIndex ==
                                0
                            ? ChangeNotifierProvider<CategoryListProvider>(
                                create: (context) => CategoryListProvider(),
                                child: FilterCategoryList(
                                  categoryName: null,
                                  categoryId: null,
                                ),
                              )
                            : context
                                        .watch<ProductFilterProvider>()
                                        .currentSelectedFilterIndex ==
                                    1
                                ? getBrandWidget(widget.brands, context)
                                : context
                                            .watch<ProductFilterProvider>()
                                            .currentSelectedFilterIndex ==
                                        2
                                    ? getSizeWidget(widget.sizes, context)
                                    : widget.totalMinPrice !=
                                            widget.totalMaxPrice
                                        ? getPriceRangeWidget(
                                            widget.totalMinPrice,
                                            widget.totalMaxPrice,
                                            context)
                                        : const SizedBox.shrink(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorsRes.gradient1,
                                ColorsRes.gradient2
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsRes.appColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomTextLabel(
                              jsonKey: "apply",
                              style: TextStyle(
                                color: ColorsRes.appColorWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
