import 'package:project/helper/utils/generalImports.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroSliderScreenState createState() => IntroSliderScreenState();
}

class IntroSliderScreenState extends State<IntroSliderScreen> {
  int currentPosition = 0;
  PageController pageController = PageController();

  /// Intro slider list ...
  /// You can add or remove items from below list as well
  /// Add svg images into asset > svg folder and set name here without any extension and image should not contains space
  static List introSlider = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update system UI overlay style based on current theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: Theme.of(context).brightness,
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    introSlider = [
      {
        "image":
            "intro_slider_1${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": "Discover Fresh Finds",
        "subtitle": "Fill Your Cart with Everything You Need.",
        "description":
            "Explore thousands of fresh products. Add your favorites to cart, checkout with ease, and let us handle the rest!",
      },
      {
        "image":
            "intro_slider_2${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": "Fast & Reliable Delivery",
        "subtitle": "Right to Your Doorstep",
        "description":
            "Get your groceries delivered quickly and safely. We ensure freshness and quality in every order.",
      },
      {
        "image":
            "intro_slider_3${Constant.session.getBoolData(SessionManager.isDarkTheme) ? "_dark" : ""}",
        "title": "Best Prices & Offers",
        "subtitle": "Save More on Every Purchase",
        "description":
            "Enjoy exclusive deals, discounts, and cashback offers. Shop smart and save money on all your essentials.",
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Color(0xFF1A1A1A),
                    Color(0xFF2D2D2D),
                    Color(0xFF3A3A3A),
                  ]
                : [
                    Color(0xFFFFF5F5),
                    Color(0xFFFEEBEB),
                    Color(0xFFFDE2E2),
                  ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                // Skip button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 50), // For balance
                      // Page indicator dots
                      Row(
                        children: List.generate(
                          introSlider.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            width: currentPosition == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: currentPosition == index
                                  ? ColorsRes.appColor
                                  : (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? ColorsRes.appColor
                                          .withValues(alpha: 0.4)
                                      : Color(0xFFFFB3B3)),
                            ),
                          ),
                        ),
                      ),
                      // Skip button
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, loginAccountScreen);
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? ColorsRes.mainTextColor
                                    : Color(0xFF666666),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                getSizedBox(height: constraints.maxHeight * 0.08),

                // Main content
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPosition = index;
                      });
                    },
                    itemCount: introSlider.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Image/Illustration
                            Container(
                              height: constraints.maxHeight * 0.35,
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Color(0xFF404040)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(150),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? ColorsRes.appColor
                                              : Color(0xFFFF6B6B))
                                          .withValues(alpha: 0.1),
                                      blurRadius: 30,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: defaultImg(
                                    image: introSlider[index]["image"],
                                    height: constraints.maxHeight * 0.25,
                                    width: constraints.maxHeight * 0.25,
                                  ),
                                ),
                              ),
                            ),

                            getSizedBox(height: constraints.maxHeight * 0.06),

                            // Title
                            Text(
                              introSlider[index]["title"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsRes.mainTextColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),

                            getSizedBox(height: constraints.maxHeight * 0.02),

                            // Subtitle
                            Text(
                              introSlider[index]["subtitle"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsRes.mainTextColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),

                            getSizedBox(height: constraints.maxHeight * 0.03),

                            // Description
                            Text(
                              introSlider[index]["description"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsRes.subTitleMainTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),

                            Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: GestureDetector(
                    onTap: () {
                      if (currentPosition < introSlider.length - 1) {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                            context, loginAccountScreen);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsRes.appColor,
                            ColorsRes.appColor.withValues(alpha: 0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsRes.appColor.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentPosition < introSlider.length - 1
                                ? "Continue"
                                : "Get Started",
                            style: TextStyle(
                              color: ColorsRes.appColorWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: ColorsRes.appColorWhite,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
