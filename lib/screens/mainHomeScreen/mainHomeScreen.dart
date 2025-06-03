import 'package:geolocator/geolocator.dart';
import 'package:project/helper/utils/generalImports.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  NetworkStatus networkStatus = NetworkStatus.online;

  @override
  void dispose() {
    context
        .read<HomeMainScreenProvider>()
        .scrollController[0]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[1]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[2]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[3]
        .removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      context.read<HomeMainScreenProvider>().setPages();
    }
    Future.delayed(
      Duration.zero,
      () async {
        context.read<AppSettingsProvider>().getAppSettingsProvider(context);

        await LocalAwesomeNotification().init(context);

        if (Constant.session
            .getData(SessionManager.keyFCMToken)
            .trim()
            .isEmpty) {
          await FirebaseMessaging.instance.getToken().then((token) {
            Constant.session.setData(SessionManager.keyFCMToken, token!, false);

            Map<String, String> params = {
              ApiAndParams.fcmToken:
                  Constant.session.getData(SessionManager.keyFCMToken),
              ApiAndParams.platform: Platform.isAndroid ? "android" : "ios"
            };

            registerFcmKey(context: context, params: params);
          }).onError((e, _) {
            return;
          });
        }

        LocationPermission permission;
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }

        if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
                Constant.session.getData(SessionManager.keyLongitude) == "") ||
            (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
                Constant.session.getData(SessionManager.keyLongitude) == "0")) {
          Navigator.pushNamed(context, confirmLocationScreen,
              arguments: [null, "location"]);
        } else {
          if (context.read<HomeMainScreenProvider>().getCurrentPage() == 0) {
            if (Constant.popupBannerEnabled) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog();
                },
              );
            }
          }

          if (Constant.session.isUserLoggedIn()) {
            await getAppNotificationSettingsRepository(
                    params: {}, context: context)
                .then(
              (value) async {
                if (value[ApiAndParams.status].toString() == "1") {
                  late AppNotificationSettings notificationSettings =
                      AppNotificationSettings.fromJson(value);
                  if (notificationSettings.data!.isEmpty) {
                    await updateAppNotificationSettingsRepository(params: {
                      ApiAndParams.statusIds: "1,2,3,4,5,6,7,8",
                      ApiAndParams.mobileStatuses: "0,1,1,1,1,1,1,1",
                      ApiAndParams.mailStatuses: "0,1,1,1,1,1,1,1"
                    }, context: context);
                  }
                }
              },
            );
          }
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeMainScreenProvider>(
      builder: (context, homeMainScreenProvider, child) {
        return Scaffold(
          // Remove transparency, let Scaffold use theme's background
          // backgroundColor will default to Theme.of(context).scaffoldBackgroundColor
          body: Stack(
            children: [
              // Main content
              networkStatus == NetworkStatus.online
                  ? PopScope(
                      canPop: false,
                      onPopInvokedWithResult: (didPop, _) {
                        if (didPop) {
                          return;
                        } else {
                          if (homeMainScreenProvider.currentPage == 0) {
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else if (Platform.isIOS) {
                              exit(0);
                            }
                          } else {
                            setState(() {});
                            homeMainScreenProvider.currentPage = 0;
                          }
                        }
                      },
                      child: IndexedStack(
                        index: homeMainScreenProvider.currentPage,
                        children: homeMainScreenProvider.getPages(),
                      ),
                    )
                  : const Center(
                      child: CustomTextLabel(
                        jsonKey: "check_internet",
                      ),
                    ),
              // Navigation bar overlay
              homeBottomNavigation(
                homeMainScreenProvider.getCurrentPage(),
                homeMainScreenProvider.selectBottomMenu,
                homeMainScreenProvider.getPages().length,
                context,
              ),
            ],
          ),
        );
      },
    );
  }
  Widget homeBottomNavigation(int selectedIndex, Function selectBottomMenu,
      int totalPage, BuildContext context) {
    List lblHomeBottomMenu = [
      getTranslatedValue(context, "home_bottom_menu_home"),
      getTranslatedValue(context, "home_bottom_menu_category"),
      getTranslatedValue(context, "home_bottom_menu_wishlist"),
      getTranslatedValue(context, "home_bottom_menu_profile"),
    ];
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
        //padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        // width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          // Use a solid color based on the theme, remove opacity for full color
          color: Theme.of(context).cardColor, // Adapts to light/dark theme
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            totalPage,
            (index) => Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => selectBottomMenu(index),
                borderRadius: BorderRadius.circular(24),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                      horizontal: selectedIndex == index ? 16 : 12,
                      vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: selectedIndex == index
                        ? ColorsRes.appColor.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getHomeBottomNavigationBarIcons(
                        isActive: selectedIndex == index,
                      )[index],
                      const SizedBox(height: 4),
                      Text(
                        lblHomeBottomMenu[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? ColorsRes.appColor
                              : ColorsRes.grey,
                          fontSize: 12,
                          fontWeight: selectedIndex == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
