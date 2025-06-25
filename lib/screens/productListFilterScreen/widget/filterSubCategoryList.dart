import 'package:project/helper/utils/generalImports.dart';
import 'package:project/screens/productListFilterScreen/widget/filterCategoryList.dart';

class FilterSubCategoryList extends StatefulWidget {
  final String? categoryName;
  final String? categoryId;

  const FilterSubCategoryList({
    Key? key,
    this.categoryName,
    this.categoryId,
  }) : super(key: key);

  static Widget getRouteInstance(RouteSettings settings) {
    final arguments = settings.arguments as List<dynamic>;
    ;
    return FilterSubCategoryList(
      categoryName: arguments[0] as String,
      categoryId: arguments[1] as String,
    );
  }

  static List<dynamic> buildArguments({
    required String categoryName,
    required String categoryId,
  }) {
    return [categoryName, categoryId];
  }

  @override
  State<FilterSubCategoryList> createState() => _FilterSubCategoryListState();
}

class _FilterSubCategoryListState extends State<FilterSubCategoryList> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        try {
          if (context.read<CategoryListProvider>().hasMoreData) {
            callApi(false);
          }
        } catch (e) {
          // Handle case where context is no longer available
          print('Context error in scroll listener: $e');
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) async {
      await callApi(true);
    });
  }

  callApi(bool isReset) {
    if (!mounted) return Future.value();

    try {
      if (isReset == true) {
        context.read<CategoryListProvider>().offset = 0;
        context.read<CategoryListProvider>().categories.clear();
      }
      return context
          .read<CategoryListProvider>()
          .getCategoryApiProvider(context: context, params: {
        ApiAndParams.categoryId:
            widget.categoryId == null ? "0" : widget.categoryId.toString()
      });
    } catch (e) {
      print('Error in callApi: $e');
      return Future.value();
    }
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return categoryWidget();
    // child:
  }

// categoryList ui
  Widget categoryWidget() {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          if (widget.categoryName != null)
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      categoryNavigatorKey.currentState?.pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: ColorsRes.mainTextColor,
                        ),
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomTextLabel(
                      text: widget.categoryName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          Expanded(
            child: Consumer<ProductFilterProvider>(
                builder: (context, productFilterProvider, child) {
              return Consumer<CategoryListProvider>(
                builder: (context, categoryListProvider, _) {
                  if (categoryListProvider.categoryState ==
                          CategoryState.loaded ||
                      categoryListProvider.categoryState ==
                          CategoryState.loadingMore) {
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: categoryListProvider.categories.length,
                      itemBuilder: (context, index) {
                        CategoryItem category =
                            categoryListProvider.categories[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (category.hasChild == false) {
                                  productFilterProvider.addRemoveCategories(
                                      category.id.toString());
                                } else {
                                  categoryNavigatorKey.currentState?.pushNamed(
                                    subCategoryRouteName,
                                    arguments: [
                                      category.name.toString(),
                                      category.id.toString()
                                    ],
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: 15, end: 15, top: 12, bottom: 12),
                                margin: EdgeInsetsDirectional.only(
                                    start: 5, end: 5, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                  color: productFilterProvider
                                          .selectedCategories
                                          .contains(category.id.toString())
                                      ? ColorsRes.appColorLightHalfTransparent
                                      : Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextLabel(
                                        text: category.name,
                                        style: TextStyle(
                                            color: productFilterProvider
                                                    .selectedCategories
                                                    .contains(
                                                        category.id.toString())
                                                ? ColorsRes.appColorDark
                                                : ColorsRes.mainTextColor,
                                            fontSize: 15,
                                            fontWeight: productFilterProvider
                                                    .selectedCategories
                                                    .contains(
                                                        category.id.toString())
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      ),
                                    ),
                                    if (category.hasChild == false &&
                                        productFilterProvider.selectedCategories
                                            .contains(
                                          category.id.toString(),
                                        ))
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: ColorsRes.appColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    if (category.hasChild == true)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: ColorsRes.mainTextColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (categoryListProvider.categoryState ==
                      CategoryState.loading) {
                    return getCategoryShimmer();
                  } else {
                    return NoInternetConnectionScreen(
                      height: context.height * 0.65,
                      message: categoryListProvider.message,
                      callback: () {
                        callApi(true);
                      },
                    );
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget getCategoryShimmer() {
    return ListView(
      children: List.generate(
        10,
        (index) => CustomShimmer(
          height: 30,
          width: context.width,
          margin: EdgeInsets.only(top: 5, bottom: 5),
        ),
      ),
    );
  }
}
