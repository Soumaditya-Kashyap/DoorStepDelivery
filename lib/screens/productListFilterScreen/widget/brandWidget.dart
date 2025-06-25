import 'package:project/helper/utils/generalImports.dart';

getBrandWidget(List<Brands> brands, BuildContext context) {
  return GridView.builder(
    itemCount: brands.length,
    padding: EdgeInsets.symmetric(
        horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      Brands brand = brands[index];
      return GestureDetector(
        onTap: () {
          context
              .read<ProductFilterProvider>()
              .addRemoveBrandIds(brand.id.toString());
        },
        child: Card(
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: setNetworkImg(
                            image: brand.imageUrl, boxFit: BoxFit.cover),
                      ),
                    ),
                    if (context
                        .watch<ProductFilterProvider>()
                        .selectedBrands
                        .contains(brand.id.toString()))
                      PositionedDirectional(
                        top: 0,
                        start: 0,
                        bottom: 0,
                        end: 0,
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12))),
                            child: Icon(
                              Icons.check_rounded,
                              color: ColorsRes.appColor,
                              size: 40,
                            )),
                      ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: CustomTextLabel(
                  text: brand.name,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: context
                            .watch<ProductFilterProvider>()
                            .selectedBrands
                            .contains(brand.id.toString())
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: context
                            .watch<ProductFilterProvider>()
                            .selectedBrands
                            .contains(brand.id.toString())
                        ? ColorsRes.appColor
                        : ColorsRes.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5),
  );
}
