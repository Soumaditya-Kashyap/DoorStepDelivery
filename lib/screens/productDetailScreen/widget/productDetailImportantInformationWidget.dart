import 'package:project/helper/utils/generalImports.dart';

Widget ProductDetailImportantInformationWidget(
  BuildContext context,
  ProductData product,
) {
  String productType = product.indicator.toString();
  String cancelableStatus = product.cancelableStatus.toString();
  String returnStatus = product.returnStatus.toString();

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
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              CustomTextLabel(
                text: "Important Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ColorsRes.mainTextColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Information Items
          if (productType != "null" && productType != "0")
            _buildInfoItem(
              context,
              icon: productType == "1"
                  ? "product_veg_indicator"
                  : "product_non_veg_indicator",
              text: getTranslatedValue(context,
                  productType == "1" ? "vegetarian" : "non_vegetarian"),
              color: productType == "1" ? Colors.green : Colors.red,
            ),

          _buildInfoItem(
            context,
            icon: cancelableStatus == "1"
                ? "product_cancellable"
                : "product_non_cancellable",
            text: (cancelableStatus == "1")
                ? "${getTranslatedValue(context, "product_is_cancellable_till")} ${Constant.getOrderActiveStatusLabelFromCode(product.tillStatus, context)}"
                : getTranslatedValue(context, "non_cancellable"),
            color: cancelableStatus == "1" ? Colors.orange : Colors.red,
          ),

          _buildInfoItem(
            context,
            icon: returnStatus == "1"
                ? "product_returnable"
                : "product_non_returnable",
            text: (returnStatus == "1")
                ? "${getTranslatedValue(context, "product_is_returnable_till")} ${product.returnDays} ${getTranslatedValue(context, "days")}"
                : getTranslatedValue(context, "non_returnable"),
            color: returnStatus == "1" ? Colors.green : Colors.red,
            isLast: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoItem(
  BuildContext context, {
  required String icon,
  required String text,
  required Color color,
  bool isLast = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: color.withValues(alpha: 0.2),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: defaultImg(
            height: 16,
            width: 16,
            image: icon,
            iconColor: color,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: CustomTextLabel(
            text: text,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
