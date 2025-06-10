import 'package:project/helper/utils/generalImports.dart';

class QuickUseWidget extends StatelessWidget {
  const QuickUseWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Constant.session.isUserLoggedIn()
        ? Container(
            margin: EdgeInsetsDirectional.symmetric(horizontal: 16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorsRes.grey.withValues(alpha: 0.08),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: ColorsRes.grey.withValues(alpha: 0.04),
                  spreadRadius: 0,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: ColorsRes.grey.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF4CAF50),
                            Color(0xFF66BB6A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: defaultImg(
                        image: "orders",
                        iconColor: Colors.white,
                        height: 24,
                        width: 24,
                      ),
                    ),
                    label: "all_orders",
                    onClickAction: () {
                      Navigator.pushNamed(
                        context,
                        orderHistoryScreen,
                      );
                    },
                    padding: const EdgeInsetsDirectional.only(
                      end: 8,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2196F3),
                            Color(0xFF42A5F5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2196F3).withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: defaultImg(
                        image: "home_map_icon",
                        iconColor: Colors.white,
                        height: 24,
                        width: 24,
                      ),
                    ),
                    label: "address",
                    onClickAction: () => Navigator.pushNamed(
                      context,
                      addressListScreen,
                      arguments: "quick_widget",
                    ),
                    padding: const EdgeInsetsDirectional.only(
                      start: 8,
                      end: 8,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: QuickActionButtonWidget(
                    icon: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsRes.appColor,
                            ColorsRes.gradient1,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsRes.appColor.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: defaultImg(
                        image: "cart_icon",
                        iconColor: Colors.white,
                        height: 24,
                        width: 24,
                      ),
                    ),
                    label: "cart",
                    onClickAction: () {
                      if (Constant.session.isUserLoggedIn()) {
                        Navigator.pushNamed(context, cartScreen);
                      } else {
                        Navigator.pushNamed(context, cartScreen);
                      }
                    },
                    padding: const EdgeInsetsDirectional.only(
                      start: 8,
                    ),
                    context: context,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
