import 'package:project/helper/utils/generalImports.dart';

class QuickActionButtonWidget extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final Function onClickAction;
  final EdgeInsetsDirectional padding;
  final BuildContext context;

  QuickActionButtonWidget(
      {super.key,
      this.icon,
      this.label,
      required this.onClickAction,
      required this.padding,
      required this.context});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: ColorsRes.appColor.withValues(alpha: 0.1),
          highlightColor: ColorsRes.appColor.withValues(alpha: 0.05),
          onTap: () {
            onClickAction();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ColorsRes.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsetsDirectional.symmetric(
              vertical: 16, // Reduced from 20
              horizontal: 10, // Reduced from 12
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon ?? SizedBox.shrink(),
                getSizedBox(height: 10), // Reduced from 12
                CustomTextLabel(
                  jsonKey: label,
                  style: TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13, // Reduced from 14
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
