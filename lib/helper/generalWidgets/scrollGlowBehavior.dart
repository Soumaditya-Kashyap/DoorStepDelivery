import 'package:project/helper/utils/generalImports.dart';

class ScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Removes the default glow effect completely
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Enhanced physics for smoother scrolling experience
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    // Clean scrollbar styling
    return Scrollbar(
      thumbVisibility: false,
      child: child,
    );
  }
}