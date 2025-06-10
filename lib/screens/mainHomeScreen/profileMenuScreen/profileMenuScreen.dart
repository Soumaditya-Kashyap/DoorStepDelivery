import 'package:project/helper/generalWidgets/bottomSheetChangePasswordContainer.dart';
import 'package:project/helper/utils/generalImports.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List personalDataMenu = [];
  List settingsMenu = [];
  List otherInformationMenu = [];
  List deleteMenuItem = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => setProfileMenuList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          setProfileMenuList();
          return CustomScrollView(
            controller: widget.scrollController,
            physics: ClampingScrollPhysics(), // Prevents overscroll bounce
            slivers: [
              // Modern SliverAppBar with enhanced gradient
              SliverAppBar(
                expandedHeight:
                    200, // Increased for better proportions with new header
                floating: false,
                pinned: true,
                automaticallyImplyLeading: false,
                stretch: false, // Disable stretch to prevent scroll jump
                clipBehavior: Clip.none, // Prevent clipping issues
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ColorsRes.gradient1,
                          ColorsRes.gradient2,
                          ColorsRes.appColorDark,
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: ProfileHeader(),
                    ),
                  ),
                ),
                backgroundColor: ColorsRes.gradient2,
                title: CustomTextLabel(
                  jsonKey: "",
                  style: TextStyle(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
                centerTitle: true,
              ), // Content with modern design
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      getSizedBox(height: 20), // Proper top spacing
                      QuickUseWidget(),
                      getSizedBox(
                          height: 16), // Consistent spacing between sections
                      menuItemsContainer(
                        title: "personal_data",
                        menuItem: personalDataMenu,
                      ),
                      getSizedBox(
                          height: 8), // Consistent spacing between cards
                      menuItemsContainer(
                        title: "settings",
                        menuItem: settingsMenu,
                      ),
                      getSizedBox(
                          height: 8), // Consistent spacing between cards
                      menuItemsContainer(
                        title: "other_information",
                        menuItem: otherInformationMenu,
                      ),
                      if (deleteMenuItem.isNotEmpty) ...[
                        getSizedBox(height: 8), // Consistent spacing
                        menuItemsContainer(
                          title: "",
                          menuItem: deleteMenuItem,
                          fontColor: ColorsRes.appColorRed,
                          iconColor: ColorsRes.appColorRed,
                        ),
                      ],
                      // Extra bottom padding to ensure all content is accessible above nav bar
                      getSizedBox(
                          height:
                              80), // Increased padding for nav bar clearance
                      // Additional safe area for different device sizes
                      SafeArea(
                        top: false,
                        child:
                            getSizedBox(height: 10), // Additional safe padding
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  setProfileMenuList() {
    personalDataMenu = [];
    settingsMenu = [];
    otherInformationMenu = [];
    deleteMenuItem = [];

    personalDataMenu = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "wallet_history_icon",
          "label": "my_wallet",
          "value": Consumer<SessionManager>(
            builder: (context, sessionManager, child) {
              return Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsRes.appColor.withValues(alpha: 0.1),
                      ColorsRes.gradient1.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorsRes.appColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 16,
                      color: ColorsRes.appColor,
                    ),
                    getSizedBox(width: 8),
                    CustomTextLabel(
                      text:
                          "${sessionManager.getData(SessionManager.keyWalletBalance)}"
                              .currency,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: ColorsRes.appColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          "clickFunction": (context) {
            Navigator.pushNamed(context, walletHistoryListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "notification_icon",
          "label": "notification",
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "transaction_icon",
          "label": "transaction_history",
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },
    ];

    settingsMenu = [
      if (Constant.session.isUserLoggedIn() &&
          (Constant.session.getData(SessionManager.keyLoginType) == "phone" ||
              Constant.session.getData(SessionManager.keyLoginType) == "email"))
        {
          "icon": "password_icon",
          "label": "change_password",
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              backgroundColor: Theme.of(context).cardColor,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetChangePasswordContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": false
        },
      {
        "icon": "theme_icon",
        "label": "change_theme",
        "clickFunction": (context) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
            backgroundColor: Theme.of(context).cardColor,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  BottomSheetThemeListContainer(),
                ],
              );
            },
          );
        },
        "isResetLabel": true,
      },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "settings",
          "label": "notifications_settings",
          "clickFunction": (context) {
            Navigator.pushNamed(
                context, notificationsAndMailSettingsScreenScreen);
          },
          "isResetLabel": false
        },
    ];

    otherInformationMenu = [
      {
        "icon": "contact_icon",
        "label": "contact_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "contact_us",
            ),
          );
        }
      },
      {
        "icon": "about_icon",
        "label": "about_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "about_us",
            ),
          );
        },
        "isResetLabel": false
      },
      {
        "icon": "rate_us_icon",
        "label": "rate_us",
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
      {
        "icon": "share_icon",
        "label": "share_app",
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(
            context,
            "share_app_message",
          );
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      },
      {
        "icon": "faq_icon",
        "label": "faq",
        "clickFunction": (context) {
          Navigator.pushNamed(context, faqListScreen);
        }
      },
      {
        "icon": "terms_icon",
        "label": "terms_and_conditions",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "terms_and_conditions",
              ));
        }
      },
      {
        "icon": "privacy_icon",
        "label": "policies",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "policies",
              ));
        }
      },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "logout_icon",
          "label": "logout",
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        },
    ];

    deleteMenuItem = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "delete_user_account_icon",
          "label": "delete_user_account",
          "clickFunction": Constant.session.deleteUserAccount,
          "isResetLabel": false
        },
    ];
  }

  Widget menuItemsContainer({
    required String title,
    required List menuItem,
    Color? iconColor,
    Color? fontColor,
  }) {
    if (menuItem.isEmpty) return SizedBox.shrink();

    return Container(
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
      margin: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section with perfect spacing
          if (title.isNotEmpty) ...[
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 20,
                vertical: 16, // Symmetric vertical padding
              ),
              child: CustomTextLabel(
                jsonKey: title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: ColorsRes.mainTextColor,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ),
            // Divider after title
            Container(
              height: 1,
              margin: EdgeInsetsDirectional.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    ColorsRes.mainTextColor.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],

          // Menu items with perfect spacing
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: menuItem.length,
            separatorBuilder: (context, index) => Container(
              height: 1,
              margin: EdgeInsetsDirectional.only(start: 76, end: 20),
              color: ColorsRes.mainTextColor.withValues(alpha: 0.06),
            ),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    menuItem[index]['clickFunction'](context);
                  },
                  borderRadius: BorderRadius.circular(
                    index == 0 && title.isNotEmpty
                        ? 0
                        : index == menuItem.length - 1
                            ? 20
                            : 0,
                  ),
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 20,
                      vertical: 16, // Perfect symmetric padding
                    ),
                    child: Row(
                      children: [
                        // Icon container with modern design
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (iconColor ?? ColorsRes.appColor)
                                    .withValues(alpha: 0.12),
                                (iconColor ?? ColorsRes.appColor)
                                    .withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (iconColor ?? ColorsRes.appColor)
                                  .withValues(alpha: 0.15),
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: defaultImg(
                              image: menuItem[index]['icon'],
                              iconColor: iconColor ?? ColorsRes.appColor,
                              height: 22,
                              width: 22,
                            ),
                          ),
                        ),

                        getSizedBox(width: 16), // Consistent spacing

                        // Label section
                        Expanded(
                          child: CustomTextLabel(
                            jsonKey: menuItem[index]['label'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: fontColor ?? ColorsRes.mainTextColor,
                              letterSpacing: 0.2,
                              height: 1.3,
                            ),
                          ),
                        ),

                        // Value section (if exists)
                        if (menuItem[index]['value'] != null) ...[
                          menuItem[index]['value'],
                          getSizedBox(width: 12),
                        ],
                        // Arrow button with modern design
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: (fontColor ?? ColorsRes.mainTextColor)
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (fontColor ?? ColorsRes.mainTextColor)
                                  .withValues(alpha: 0.1),
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: fontColor ??
                                ColorsRes.mainTextColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (title.isNotEmpty)
            getSizedBox(
                height: 4), 
        ],
      ),
    );
  }
}
