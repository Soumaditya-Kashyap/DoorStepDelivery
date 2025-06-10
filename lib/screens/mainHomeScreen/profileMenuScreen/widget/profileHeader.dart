import 'package:project/helper/utils/generalImports.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      child: Row(
        children: [
          // Left side - Professional Avatar Section
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.6),
                      ColorsRes.gradient1.withOpacity(0.4),
                      ColorsRes.gradient2.withOpacity(0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              // Inner avatar container
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: ColorsRes.gradient1.withOpacity(0.1),
                  radius: 38,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38),
                    child: Constant.session.isUserLoggedIn()
                        ? Consumer<UserProfileProvider>(
                            builder: (context, value, child) {
                              return setNetworkImg(
                                height: 74,
                                width: 74,
                                boxFit: BoxFit.cover,
                                image: Constant.session.getData(
                                  SessionManager.keyUserImage,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  ColorsRes.gradient1.withOpacity(0.2),
                                  ColorsRes.gradient2.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: defaultImg(
                              height: 40,
                              width: 40,
                              image: "default_user",
                            ),
                          ),
                  ),
                ),
              ),
              // Edit button overlay for logged in users
              if (Constant.session.isUserLoggedIn())
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        editProfileScreen,
                        arguments: [
                          Constant.session.isUserLoggedIn()
                              ? "header"
                              : "register_header",
                          null
                        ],
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ColorsRes.appColor, ColorsRes.gradient1],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsRes.appColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          getSizedBox(width: 20), // Spacing between avatar and content

          // Right side - User Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (Constant.session.isUserLoggedIn())
                  Consumer<UserProfileProvider>(
                    builder: (context, userProfileProvider, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User name with modern styling
                        CustomTextLabel(
                          text: userProfileProvider.getUserDetailBySessionKey(
                            isBool: false,
                            key: SessionManager.keyUserName,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 0.3,
                            height: 1.2,
                          ),
                        ),
                        getSizedBox(height: 8),
                        // Email with professional chip design
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.email_rounded,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              getSizedBox(width: 8),
                              Flexible(
                                child: CustomTextLabel(
                                  text: Constant.session
                                      .getData(SessionManager.keyEmail),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit Profile Button for logged in users
                        getSizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              editProfileScreen,
                              arguments: [
                                Constant.session.isUserLoggedIn()
                                    ? "header"
                                    : "register_header",
                                null
                              ],
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  size: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                getSizedBox(width: 6),
                                CustomTextLabel(
                                  jsonKey: "edit",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message with professional styling
                      CustomTextLabel(
                        text: "Welcome to DrunkPanda",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                      ),
                      getSizedBox(height: 6),
                      CustomTextLabel(
                        text:
                            "Sign in to access your account and enjoy our services",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                      getSizedBox(height: 16),
                      // Premium login button
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            loginAccountScreen,
                            arguments: "header",
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorsRes.appColorRed,
                                ColorsRes.appColorRed.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: ColorsRes.appColorRed.withOpacity(0.4),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.login_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              getSizedBox(width: 10),
                              CustomTextLabel(
                                jsonKey: "login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
