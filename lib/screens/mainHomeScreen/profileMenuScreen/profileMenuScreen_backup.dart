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

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  List personalDataMenu = [];
  List settingsMenu = [];
  List otherInformationMenu = [];
  List deleteMenuItem = [];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration.zero).then((value) {
      setProfileMenuList();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          setProfileMenuList();
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              controller: widget.scrollController,
              slivers: [
                // Modern SliverAppBar with gradient
                SliverAppBar(
                  expandedHeight: 280,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
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
                    jsonKey: "profile",
                    style: TextStyle(
                      color: ColorsRes.appColorWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  centerTitle: true,
                ),
                // Content
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        getSizedBox(height: 20),
                        QuickUseWidget(),
                        getSizedBox(height: 10),
                        _buildAnimatedMenuSection(
                          title: "personal_data",
                          menuItem: personalDataMenu,
                          delay: 100,
                        ),
                        _buildAnimatedMenuSection(
                          title: "settings",
                          menuItem: settingsMenu,
                          delay: 200,
                        ),
                        _buildAnimatedMenuSection(
                          title: "other_information",
                          menuItem: otherInformationMenu,
                          delay: 300,
                        ),
                        _buildAnimatedMenuSection(
                          title: "",
                          menuItem: deleteMenuItem,
                          fontColor: ColorsRes.appColorRed,
                          iconColor: ColorsRes.appColorRed,
                          delay: 400,
                        ),
                        getSizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedMenuSection({
    required String title,
    required List menuItem,
    Color? iconColor,
    Color? fontColor,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: menuItemsContainer(
              title: title,
              menuItem: menuItem,
              iconColor: iconColor,
              fontColor: fontColor,
            ),
          ),
        );
      },
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
                      getSizedBox(width: 6),
                      CustomTextLabel(
                        text:
                            "${sessionManager.getData(SessionManager.keyWalletBalance)}"
                                .currency,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ));
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
      // if (context.read<LanguageProvider>().languages.length > 1)
      //   {
      //     "icon": "translate_icon",
      //     "label": "change_language",
      //     "clickFunction": (context) {
      //       showModalBottomSheet<void>(
      //         context: context,
      //         isScrollControlled: true,
      //         shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      //         backgroundColor: Theme.of(context).cardColor,
      //         builder: (BuildContext context) {
      //           return Wrap(
      //             children: [
      //               BottomSheetLanguageListContainer(),
      //             ],
      //           );
      //         },
      //       );
      //     },
      //     "isResetLabel": true,
      //   },
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
/*      if (isUserLogin)
        {
          "icon": "refer_friend_icon",
          "label": "refer_and_earn",
          "clickFunction": ReferAndEarn(),
          "isResetLabel": false
        },*/
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
    if (menuItem.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorsRes.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        margin: EdgeInsetsDirectional.only(
          start: 16,
          end: 16,
          bottom: 16,
          top: Constant.session.isUserLoggedIn() ? 0 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 20,
                  end: 20,
                  top: 20,
                  bottom: 10,
                ),
                child: CustomTextLabel(
                  jsonKey: title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ColorsRes.mainTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: menuItem.length,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsetsDirectional.only(start: 65, end: 20),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: ColorsRes.mainTextColor.withValues(alpha: 0.1),
                ),
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
                          ? 20
                          : index == menuItem.length - 1
                              ? 20
                              : 0,
                    ),
                    child: Container(
                      padding: EdgeInsetsDirectional.only(
                        start: 20,
                        end: 20,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: (iconColor ?? ColorsRes.appColor)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
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
                          getSizedBox(width: 15),
                          Expanded(
                            child: CustomTextLabel(
                              jsonKey: menuItem[index]['label'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: fontColor ?? ColorsRes.mainTextColor,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          if (menuItem[index]['value'] != null) ...[
                            menuItem[index]['value'],
                            getSizedBox(width: 12),
                          ],
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: (fontColor ?? ColorsRes.mainTextColor)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: fontColor ??
                                  ColorsRes.mainTextColor
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            getSizedBox(height: 10),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
