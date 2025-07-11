import 'package:project/helper/utils/generalImports.dart';

Widget gradientBtnWidget(BuildContext context, double borderRadius,
    {required Function callback,
    String title = "",
    Widget? otherWidgets,
    double? height,
    double? width,
    Color? color1,
    Color? color2}) {
  return GestureDetector(
    onTap: () {
      callback();
    },
    child: Container(
      height: height ?? 45,
      width: width,
      alignment: Alignment.center,
      decoration: DesignConfig.boxGradient(
        borderRadius,
        color1: color1,
        color2: color2,
      ),
      child: otherWidgets ??= CustomTextLabel(
        text: title,
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
            color: ColorsRes.mainIconColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500)),
      ),
    ),
  );
}

getDarkLightIcon({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? isActive,
}) {
  String dark =
      (Constant.session.getBoolData(SessionManager.isDarkTheme)) == true
          ? "_dark"
          : "";
  String active = (isActive ??= false) == true ? "_active" : "";

  return defaultImg(
      height: height,
      width: width,
      image: "$image$active${dark}_icon",
      iconColor: iconColor,
      boxFit: boxFit,
      padding: padding);
}

List getHomeBottomNavigationBarIcons({required bool isActive}) {
  return [
    getDarkLightIcon(
        image: "home",
        isActive: isActive,
        iconColor: isActive ? ColorsRes.appColor : null,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "category",
        isActive: isActive,
        iconColor: isActive ? ColorsRes.appColor : null,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "wishlist",
        isActive: isActive,
        iconColor: isActive ? ColorsRes.appColor : null,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "profile",
        isActive: isActive,
        iconColor: isActive ? ColorsRes.appColor : null,
        padding: EdgeInsetsDirectional.zero),
  ];
}

Widget setNetworkImg({
  double? height,
  double? width,
  String image = "placeholder",
  Color? iconColor,
  BoxFit? boxFit,
  BorderRadius? borderRadius,
}) {
  if (image.trim().isNotEmpty && !image.contains("http")) {
    image = "${Constant.hostUrl}storage/$image";
  }

  return image.trim().isEmpty
      ? _buildShimmerPlaceholder(height, width, borderRadius)
      : ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: image,
            height: height,
            width: width,
            fit: boxFit ?? BoxFit.cover,
            placeholder: (context, url) =>
                _buildShimmerPlaceholder(height, width, borderRadius),
            errorWidget: (context, url, error) =>
                _buildErrorPlaceholder(height, width, borderRadius),
            fadeInDuration: Duration(milliseconds: 300),
            fadeOutDuration: Duration(milliseconds: 100),
            // Add cache options for better performance
            maxHeightDiskCache: 1000,
            maxWidthDiskCache: 1000,
            // Custom cache options
            cacheKey: image,
            useOldImageOnUrlChange: true,
          ),
        );
}

Widget _buildShimmerPlaceholder(
    double? height, double? width, BorderRadius? borderRadius) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    ),
  );
}

Widget _buildErrorPlaceholder(
    double? height, double? width, BorderRadius? borderRadius) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: borderRadius ?? BorderRadius.circular(8),
    ),
    child: Icon(
      Icons.image_not_supported_outlined,
      color: Colors.grey[400],
      size: height != null ? height * 0.3 : 40,
    ),
  );
}

Widget defaultImg({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? requiredRTL = true,
}) {
  return Padding(
    padding: padding ?? const EdgeInsets.all(0),
    child: (image.contains("png") ||
            image.contains("jpeg") ||
            image.contains("jpg"))
        ? Image.asset(Constant.getAssetsPath(0, image))
        : SvgPicture.asset(
            Constant.getAssetsPath(1, image),
            width: width,
            height: height,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                : null,
            fit: boxFit ?? BoxFit.contain,
            matchTextDirection: requiredRTL ?? true,
          ),
  );
}

Widget getSizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: child,
  );
}

Widget getDivider(
    {Color? color,
    double? endIndent,
    double? height,
    double? indent,
    double? thickness}) {
  return Divider(
    color: color ?? ColorsRes.subTitleMainTextColor,
    endIndent: endIndent ?? 0,
    indent: indent ?? 0,
    height: height,
    thickness: thickness,
  );
}

Widget getLoadingIndicator() {
  return CircularProgressIndicator(
    backgroundColor: Colors.transparent,
    color: ColorsRes.appColor,
    strokeWidth: 2,
  );
}

// CategorySimmer
Widget getCategoryShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image shimmer
            Expanded(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: CustomShimmer(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 8,
                ),
              ),
            ), // Text shimmer
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomShimmer(
                      width: double.infinity,
                      height: 11,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 2),
                    CustomShimmer(
                      width: 50,
                      height: 9,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 0.8,
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
  );
}

// CategorySimmer
Widget getRatingPhotosShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// BrandSimmer
Widget getBrandShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// BrandSimmer
Widget getSellerShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

AppBar getAppBar(
    {required BuildContext context,
    bool? centerTitle,
    required Widget title,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    GestureTapCallback? onTap}) {
  return AppBar(
    leading: showBackButton ?? true
        ? GestureDetector(
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: SizedBox(
                  child: defaultImg(
                    boxFit: BoxFit.contain,
                    image: "ic_arrow_back",
                    iconColor: ColorsRes.mainTextColor,
                  ),
                  height: 10,
                  width: 10,
                ),
              ),
            ),
          )
        : null,
    automaticallyImplyLeading: true,
    elevation: 0,
    titleSpacing: 0,
    title: Row(
      children: [
        if (showBackButton == false || !Navigator.of(context).canPop())
          getSizedBox(
            width: 10,
          ),
        Expanded(child: title),
      ],
    ),
    centerTitle: centerTitle ?? false,
    surfaceTintColor: Colors.transparent,
    backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
    actions: actions ?? [],
  );
}

Widget getProductListShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : Column(
          children: List.generate(20, (index) {
            return const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: CustomShimmer(
                width: double.maxFinite,
                height: 125,
              ),
            );
          }),
        );
}

Widget getProductItemShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 2,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
}

//Search widgets for the multiple screen
Widget getSearchWidget({
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, productSearchScreen);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorsRes.subTitleMainTextColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: ColorsRes.subTitleMainTextColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              getTranslatedValue(context, "product_search_hint"),
              style: TextStyle(
                color: ColorsRes.subTitleMainTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Icon(
            Icons.tune,
            color: ColorsRes.subTitleMainTextColor,
            size: 18,
          ),
        ],
      ),
    ),
  );
}

Widget setRefreshIndicator(
    {required RefreshCallback refreshCallback, required Widget child}) {
  return RefreshIndicator(
    onRefresh: refreshCallback,
    child: child,
    backgroundColor: Colors.transparent,
    color: ColorsRes.appColor,
    triggerMode: RefreshIndicatorTriggerMode.anywhere,
  );
}

Widget setNotificationIcon({required BuildContext context}) {
  return IconButton(
    onPressed: () {
      Navigator.pushNamed(context, notificationListScreen);
    },
    icon: defaultImg(
      image: "notification_icon",
      iconColor: ColorsRes.appColor,
    ),
  );
}

Widget getOverallRatingSummary(
    {required BuildContext context,
    required ProductRatingData productRatingData,
    required String totalRatings}) {
  return Row(
    children: [
      Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsRes.appColor,
            maxRadius: 45,
            minRadius: 20,
            child: CustomTextLabel(
              text: "${productRatingData.averageRating.toString().toDouble}",
              style: TextStyle(
                color: ColorsRes.appColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          getSizedBox(height: 10),
          CustomTextLabel(
            text:
                "${getTranslatedValue(context, "rating")}\n${totalRatings.toString().toInt}",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Container(
        margin: EdgeInsetsDirectional.only(start: 20, end: 20),
        color: ColorsRes.subTitleMainTextColor,
        height: 165,
        width: 0.7,
      ),
      Expanded(
        child: Column(
          children: [
            PercentageWiseRatingBar(
              context: context,
              index: 4,
              totalRatings: productRatingData.fiveStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.fiveStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 3,
              totalRatings: productRatingData.fourStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.fourStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 2,
              totalRatings: productRatingData.threeStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.threeStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 1,
              totalRatings: productRatingData.twoStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.twoStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 0,
              totalRatings: productRatingData.oneStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.oneStarRating.toString().toInt,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget PercentageWiseRatingBar({
  required double ratingPercentage,
  required int totalRatings,
  required int index,
  required BuildContext context,
}) {
  return Column(
    children: [
      Row(
        children: [
          CustomTextLabel(
            text: "${index + 1}",
          ),
          getSizedBox(width: 5),
          Icon(
            Icons.star_rounded,
            color: Colors.amber,
          ),
          getSizedBox(width: 5),
          Expanded(
            child: Container(
              height: 5,
              width: context.width * 0.4,
              decoration: BoxDecoration(
                color: ColorsRes.mainTextColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 5,
                  width: (context.width * 0.34) * ratingPercentage,
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          getSizedBox(width: 10),
          CustomTextLabel(
            text: "$totalRatings",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      getSizedBox(height: 10),
    ],
  );
}

double calculatePercentage(
    {required int totalRatings, required int starsWiseRatings}) {
  double percentage = 0.0;

  percentage = (starsWiseRatings * 100) / totalRatings;
  return percentage / 100;
}

Widget getRatingReviewItem({required ProductRatingList rating}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(
              start: 5,
            ),
            decoration: BoxDecoration(
              color: ColorsRes.appColor,
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                CustomTextLabel(
                  text: rating.rate,
                  style: TextStyle(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                  size: 20,
                )
              ],
            ),
          ),
          getSizedBox(width: 7),
          CustomTextLabel(
            text: rating.user?.name.toString() ?? "",
            style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 15),
            softWrap: true,
          )
        ],
      ),
      getSizedBox(height: 10),
      if (rating.review.toString().length > 100)
        ExpandableText(
          text: rating.review.toString(),
          max: 0.2,
          color: ColorsRes.subTitleMainTextColor,
        ),
      if (rating.review.toString().length <= 100)
        CustomTextLabel(
          text: rating.review.toString(),
          style: TextStyle(
            color: ColorsRes.subTitleMainTextColor,
          ),
        ),
      getSizedBox(height: 10),
      if (rating.images != null && rating.images!.length > 0)
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            runSpacing: 10,
            spacing: constraints.maxWidth * 0.017,
            children: List.generate(
              rating.images!.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, fullScreenProductImageScreen, arguments: [
                      index,
                      rating.images?.map((e) => e.imageUrl.toString()).toList()
                    ]);
                  },
                  child: ClipRRect(
                    borderRadius: Constant.borderRadius2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: setNetworkImg(
                      image: rating.images?[index].imageUrl ?? "",
                      width: 50,
                      height: 50,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      getSizedBox(height: 10),
      CustomTextLabel(
        text: rating.updatedAt.toString().formatDate(),
        style: TextStyle(
          color: ColorsRes.subTitleMainTextColor,
        ),
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget CheckoutShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CustomShimmer(
        margin: EdgeInsetsDirectional.all(Constant.size10),
        borderRadius: 7,
        width: double.maxFinite,
        height: 150,
      ),
      const CustomShimmer(
        width: 250,
        height: 25,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            10,
            (index) {
              return const CustomShimmer(
                width: 50,
                height: 80,
                borderRadius: 10,
                margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
              );
            },
          ),
        ),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: 250,
        height: 25,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
      const CustomShimmer(
        width: double.maxFinite,
        height: 45,
        borderRadius: 10,
        margin: EdgeInsetsDirectional.all(10),
      ),
    ],
  );
}

Widget DeliveryChargeShimmer() {
  return Padding(
    padding: EdgeInsets.all(Constant.size10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: CustomShimmer(
                height: 20,
                borderRadius: 7,
              ),
            ),
            getSizedBox(
              width: Constant.size10,
            ),
            const Expanded(
              child: CustomShimmer(
                height: 20,
                width: 80,
                borderRadius: 7,
              ),
            )
          ],
        ),
        getSizedBox(
          height: Constant.size7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: CustomShimmer(
                height: 20,
                borderRadius: 7,
              ),
            ),
            getSizedBox(
              width: Constant.size10,
            ),
            const Expanded(
              child: CustomShimmer(
                height: 20,
                borderRadius: 7,
              ),
            )
          ],
        ),
        getSizedBox(
          height: Constant.size7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: CustomShimmer(
                height: 22,
                borderRadius: 7,
              ),
            ),
            getSizedBox(
              width: Constant.size10,
            ),
            const Expanded(
              child: CustomShimmer(
                height: 22,
                borderRadius: 7,
              ),
            )
          ],
        ),
        getSizedBox(
          height: Constant.size7,
        ),
      ],
    ),
  );
}

Widget DashedDivider({Color? color, double? height}) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      const dashWidth = 5.0;
      final dashHeight = height;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (_) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: color ?? ColorsRes.subTitleMainTextColor),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    },
  );
}

Widget getHomeScreenShimmer(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: Constant.size10, horizontal: Constant.size10),
    child: Column(
      children: [
        // Header shimmer with modern design
        _buildModernShimmerCard(
          height: context.height * 0.26,
          width: context.width,
          borderRadius: 16,
        ),
        getSizedBox(height: Constant.size15),

        // Search bar shimmer
        _buildModernShimmerCard(
          height: 50,
          width: context.width,
          borderRadius: 25,
        ),
        getSizedBox(height: Constant.size15),

        // Categories shimmer
        Row(
          children: List.generate(
            4,
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    _buildModernShimmerCard(
                      height: 60,
                      width: 60,
                      borderRadius: 30,
                    ),
                    SizedBox(height: 8),
                    _buildModernShimmerCard(
                      height: 12,
                      width: double.infinity,
                      borderRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        getSizedBox(height: Constant.size20),

        // Product sections
        Column(
          children: List.generate(3, (sectionIndex) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildModernShimmerCard(
                      height: 20,
                      width: context.width * 0.4,
                      borderRadius: 10,
                    ),
                    _buildModernShimmerCard(
                      height: 16,
                      width: context.width * 0.2,
                      borderRadius: 8,
                    ),
                  ],
                ),
                getSizedBox(height: Constant.size15),

                // Product grid
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(3, (productIndex) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: Constant.size10,
                        ),
                        child: _buildProductCardShimmer(context),
                      );
                    }),
                  ),
                ),
                getSizedBox(height: Constant.size20),
              ],
            );
          }),
        )
      ],
    ),
  );
}

Widget _buildModernShimmerCard({
  required double height,
  required double width,
  required double borderRadius,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      period: Duration(milliseconds: 1200),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}

Widget _buildProductCardShimmer(BuildContext context) {
  return Container(
    width: context.width * 0.45,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        _buildModernShimmerCard(
          height: context.width * 0.45,
          width: context.width * 0.45,
          borderRadius: 12,
        ),
        SizedBox(height: 8),

        // Product name
        _buildModernShimmerCard(
          height: 16,
          width: double.infinity,
          borderRadius: 8,
        ),
        SizedBox(height: 4),

        // Product rating
        Row(
          children: [
            _buildModernShimmerCard(
              height: 12,
              width: 80,
              borderRadius: 6,
            ),
          ],
        ),
        SizedBox(height: 8),

        // Price and add to cart
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildModernShimmerCard(
              height: 18,
              width: 60,
              borderRadius: 9,
            ),
            _buildModernShimmerCard(
              height: 32,
              width: 80,
              borderRadius: 16,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget ProductListViewListingWidget({required List<ProductListItem> products}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(
      products.length,
      (index) {
        return ProductListItemContainer(product: products[index]);
      },
    ),
  );
}

Widget ProductGridViewListingWidget({required List<ProductListItem> products}) {
  return GridView.builder(
    itemCount: products.length,
    padding: EdgeInsetsDirectional.only(
        start: Constant.size10,
        end: Constant.size10,
        bottom: Constant.size10,
        top: Constant.size5),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return ProductGridItemContainer(product: products[index]);
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 0.55,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
  );
}

Widget ProductWidget({VoidCallback? voidCallBack, required String from}) {
  return Consumer<ProductListProvider>(
    builder: (context, productListProvider, _) {
      List<ProductListItem> products = productListProvider.products;
      if (productListProvider.productState == ProductState.initial ||
          productListProvider.productState == ProductState.loading) {
        return getProductListShimmer(
            context: context,
            isGrid: context
                .read<ProductChangeListingTypeProvider>()
                .getListingType());
      } else if (productListProvider.productState == ProductState.loaded ||
          productListProvider.productState == ProductState.loadingMore) {
        return Column(
          children: [
            (context
                            .read<ProductChangeListingTypeProvider>()
                            .getListingType() ==
                        true &&
                    from == "product_listing")
                ? /* GRID VIEW UI */ ProductGridViewListingWidget(
                    products: products)
                : /* LIST VIEW UI */ ProductListViewListingWidget(
                    products: products),
            if (productListProvider.productState == ProductState.loadingMore)
              getProductItemShimmer(
                  context: context,
                  isGrid: context
                      .read<ProductChangeListingTypeProvider>()
                      .getListingType()),
            if (context.watch<CartProvider>().totalItemsCount > 0)
              getSizedBox(height: 65),
          ],
        );
      } else if (productListProvider.productState == ProductState.empty &&
          from == "product_listing") {
        return DefaultBlankItemMessageScreen(
          title: "empty_product_list_message",
          description: "empty_product_list_description",
          image: "no_product_icon",
        );
      } else if (from != "product_listing") {
        return Container();
      } else {
        return NoInternetConnectionScreen(
          height: context.height * 0.65,
          message: productListProvider.message,
          callback: voidCallBack,
        );
      }
    },
  );
}

getDefaultPinTheme() {
  PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: ColorsRes.mainTextColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorsRes.mainTextColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

getFocusedPinTheme() {
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: ColorsRes.mainTextColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorsRes.mainTextColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  ).copyDecorationWith(
    border: Border.all(color: ColorsRes.mainTextColor),
    borderRadius: BorderRadius.circular(10),
  );
}

getSubmittedPinTheme(BuildContext context) {
  return PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: ColorsRes.mainTextColor,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        color: ColorsRes.mainTextColor,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  ).copyWith(
    decoration: PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: ColorsRes.mainTextColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsRes.mainTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ).decoration?.copyWith(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: ColorsRes.appColor,
          ),
        ),
  );
}

Widget otpPinWidget(
    {required BuildContext context,
    required TextEditingController pinController,
    VoidCallback? onCompleted}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Pinput(
      defaultPinTheme: getFocusedPinTheme(),
      focusedPinTheme: getFocusedPinTheme(),
      submittedPinTheme: getSubmittedPinTheme(context),
      /* onClipboardFound: (value) {
        pinController.setText(value);
      }, */
      controller: pinController,
      length: 6,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      hapticFeedbackType: HapticFeedbackType.heavyImpact,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.singleLineFormatter
      ],
      autofocus: true,
      closeKeyboardWhenCompleted: true,
      pinAnimationType: PinAnimationType.slide,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      animationCurve: Curves.bounceInOut,
      enableSuggestions: true,
      pinContentAlignment: AlignmentDirectional.center,
      isCursorAnimationEnabled: true,
      onCompleted: (value) {
        onCompleted?.call();
      },
    ),
  );
}
