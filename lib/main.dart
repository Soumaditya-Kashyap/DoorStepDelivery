import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project/helper/utils/generalImports.dart';

late final SharedPreferences prefs;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Set up global error handling for FormatExceptions
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception is FormatException) {
      print('Caught FormatException: ${details.exception}');
      print('Stack trace: ${details.stack}');
      // Don't crash the app for FormatExceptions
      return;
    }
    // For other errors, use the default handler
    FlutterError.presentError(details);
  };

  // Set custom HTTP overrides for better network handling
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize shared preferences
  prefs = await SharedPreferences.getInstance();

  // Set global navigator key
  navigatorKey = GlobalKey<NavigatorState>();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  } catch (_) {}

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider<HomeMainScreenProvider>(
          create: (context) => HomeMainScreenProvider(),
        ),
        ChangeNotifierProvider<CategoryListProvider>(
          create: (context) => CategoryListProvider(),
        ),
        ChangeNotifierProvider<CityByLatLongProvider>(
          create: (context) => CityByLatLongProvider(),
        ),
        ChangeNotifierProvider<HomeScreenProvider>(
          create: (context) => HomeScreenProvider(),
        ),
        ChangeNotifierProvider<ProductChangeListingTypeProvider>(
          create: (context) => ProductChangeListingTypeProvider(),
        ),
        ChangeNotifierProvider<FaqProvider>(
          create: (context) => FaqProvider(),
        ),
        ChangeNotifierProvider<ProductWishListProvider>(
          create: (context) => ProductWishListProvider(),
        ),
        ChangeNotifierProvider<ProductAddOrRemoveFavoriteProvider>(
          create: (context) => ProductAddOrRemoveFavoriteProvider(),
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) => UserProfileProvider(),
        ),
        ChangeNotifierProvider<CartListProvider>(
          create: (context) => CartListProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (context) => AppSettingsProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionManager>(
      create: (_) => SessionManager(prefs: prefs),
      child: Consumer<SessionManager>(
        builder: (context, SessionManager sessionNotifier, child) {
          Constant.session =
              Provider.of<SessionManager>(context, listen: false);

          if (Constant.session
              .getData(SessionManager.appThemeName)
              .toString()
              .isEmpty) {
            Constant.session.setData(
                SessionManager.appThemeName, Constant.themeList[0], false);
            Constant.session.setBoolData(
                SessionManager.isDarkTheme,
                PlatformDispatcher.instance.platformBrightness ==
                    Brightness.dark,
                false);
          }

          // This callback is called every time the brightness changes from the device.
          PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
            if (Constant.session.getData(SessionManager.appThemeName) ==
                Constant.themeList[0]) {
              Constant.session.setBoolData(
                  SessionManager.isDarkTheme,
                  PlatformDispatcher.instance.platformBrightness ==
                      Brightness.dark,
                  true);
            }
          };

          return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
            return Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                if (Constant.session
                    .getData(SessionManager.appThemeName)
                    .toString()
                    .isEmpty) {
                  Constant.session.setData(SessionManager.appThemeName,
                      Constant.themeList[0], false);
                  Constant.session.setBoolData(
                      SessionManager.isDarkTheme,
                      PlatformDispatcher.instance.platformBrightness ==
                          Brightness.dark,
                      false);
                }

                // This callback is called every time the brightness changes from the device.
                PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
                  if (Constant.session.getData(SessionManager.appThemeName) ==
                      Constant.themeList[0]) {
                    Constant.session.setBoolData(
                        SessionManager.isDarkTheme,
                        PlatformDispatcher.instance.platformBrightness ==
                            Brightness.dark,
                        true);
                  }
                };

                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                      systemNavigationBarColor: Colors.transparent,
                      systemNavigationBarDividerColor: Colors.transparent,
                      statusBarColor: Colors.transparent,
                      systemStatusBarContrastEnforced: true),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: MaterialApp(
                      navigatorKey: navigatorKey,
                      builder: (context, child) {
                        return ScrollConfiguration(
                          behavior: GlobalScrollBehavior(),
                          child: Center(
                            child: Directionality(
                              textDirection: languageProvider.languageDirection
                                          .toLowerCase() ==
                                      "rtl"
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: child!,
                            ),
                          ),
                        );
                      },
                      onGenerateRoute: RouteGenerator.generateRoute,
                      initialRoute: "/",
                      scrollBehavior: ScrollGlowBehavior(),
                      debugShowCheckedModeBanner: false,
                      title: "DoorStep Delivery",
                      theme: ColorsRes.setAppTheme().copyWith(
                        textTheme: GoogleFonts.latoTextTheme(
                            Theme.of(context).textTheme),
                      ),
                      localizationsDelegates: const [
                        CountryLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      home: SplashScreen(),
                    ),
                  ),
                );
              },
            );
          });
        },
      ),
    );
  }
}
