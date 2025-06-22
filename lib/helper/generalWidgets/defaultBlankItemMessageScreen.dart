import 'package:project/helper/utils/generalImports.dart';

class DefaultBlankItemMessageScreen extends StatelessWidget {
  final String image, title, description;
  final Function? callback;
  final String? buttonTitle;
  final double? height;

  const DefaultBlankItemMessageScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      this.callback,
      this.buttonTitle,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      height: height ?? context.height * 0.65,
      width: context.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            margin: const EdgeInsets.only(bottom: 30),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsRes.appColor.withOpacity(0.1),
                  ColorsRes.appColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: CircleBorder(
                side: BorderSide(
                    width: 3, color: ColorsRes.appColor.withOpacity(0.2)),
              ),
            ),
            child: Center(
              child: defaultImg(
                image: image,
                width: context.width * 0.2,
                height: context.width * 0.2,
                iconColor: ColorsRes.appColor,
              ),
            ),
          ),
          CustomTextLabel(
            jsonKey: title,
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.merge(
                  TextStyle(
                    color: ColorsRes.mainTextColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
          ),
          SizedBox(height: Constant.size15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextLabel(
              jsonKey: description,
              softWrap: true,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.merge(
                    TextStyle(
                      letterSpacing: 0.3,
                      color: ColorsRes.subTitleMainTextColor,
                      height: 1.4,
                    ),
                  ),
            ),
          ),
          if (callback != null && buttonTitle != null)
            const SizedBox(height: 20),
          if (callback != null && buttonTitle != null)
            GestureDetector(
              onTap: () {
                callback!();
              },
              child: Container(
                decoration: DesignConfig.boxDecoration(ColorsRes.appColor, 10),
                padding: const EdgeInsets.all(10),
                child: CustomTextLabel(
                  jsonKey: buttonTitle,
                  softWrap: true,
                  style: TextStyle(
                    color: ColorsRes.appColorWhite,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
