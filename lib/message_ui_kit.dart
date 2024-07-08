import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MessageUiKit extends StatelessWidget {
  final Color? scaffoldColor;
  final String? phoneNumber;
  final Color? senderColor;
  final Color? receiverColor;
  final Color? messageTextColor;
  final double? messageTextSize;
  final Color? messageDateColor;
  final Color? dayDateTextColor;
  final Color? dayDateColor;
  final double? dayDateSize;
  final Color? textFieldColor;
  final bool? isFilled;
  final TextStyle? hintStyle;
  final BorderRadius? textFieldRadius;
  final BorderSide? textFieldBorder;
  final Color? sendMessageBtnColor;
  final TextEditingController? messageController = TextEditingController();
  final ScrollController? scrollController = ScrollController();

  // final String name;
  final bool fromNotification;

  MessageUiKit({
    super.key,
    this.scaffoldColor,
    required this.phoneNumber,
    // required this.name,
    this.fromNotification = false,
    this.senderColor,
    this.receiverColor,
    this.messageTextColor,
    this.messageTextSize,
    this.messageDateColor,
    this.dayDateTextColor,
    this.dayDateColor,
    this.dayDateSize,
    this.textFieldColor,
    this.isFilled,
    this.hintStyle,
    this.sendMessageBtnColor,
    this.textFieldRadius,
    this.textFieldBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: scaffoldColor,
      appBar: MessagesAppBar(
        name: phoneNumber ?? 'test user',
        appBarTextColor: Colors.white,
      ),
      body: Column(
        children: [
          messagesList(itemCount: 4),
          sendMessageTextField(
              messageController: messageController!,
              sendBtnColor: sendMessageBtnColor),
        ],
      ),
    );
  }

  Widget sendMessageTextField(
          {required TextEditingController messageController,
          Color? sendBtnColor}) =>
      ValueListenableBuilder(
        valueListenable: messageController,
        builder: (BuildContext context, value, Widget? child) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: AppHeight.h4,
              right: AppWidth.w4,
              left: AppWidth.w4,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // MediaContainer(),
                      CustomTextField(
                        borderRadius: textFieldRadius,
                        borderSide: textFieldBorder,
                        filledColor: textFieldColor,
                        hintStyle: hintStyle,
                        hintText: 'enter your message',
                        isFilled: isFilled,
                        controller: messageController,
                        inputType: TextInputType.text,
                        suffixIcon: value.text.isEmpty
                            ? messageTextFieldSuffixWidget()
                            : null,
                        readOnly: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppWidth.w5),
                SendMessageButton(value: value, sendBtnColor: sendBtnColor),
              ],
            ),
          );
        },
      );

  Widget messageTextFieldSuffixWidget() => Padding(
        padding: EdgeInsets.only(right: AppWidth.w4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [selectMediaButton()],
        ),
      );

  Widget selectMediaButton() => Padding(
        padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
        child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
            child: Icon(
              IconBroken.Image,
              size: AppSize.s20,
              color: AppColors.blue.withOpacity(0.8),
            ),
          ),
        ),
      );

  Widget messagesList({required int itemCount}) => Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          controller: scrollController!,
          reverse: true,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            MessageModel model = MessageModel(
                senderId: '23124',
                messageId: '2',
                receiverId: '123123',
                message: 'hellllow',
                date: DateTime.now().toString());
            // final message = di<MessagesCubit>().chat!.messages![index];
            final isMyMessage = index.isEven;
            return Column(
              children: [
                dayDate(
                    date: DateFormat.yMMMEd()
                        .format(DateTime.parse(model.date!))),
                Row(
                  mainAxisAlignment: isMyMessage
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    // if (model.isDoc == true && !isMyMessage)
                    //   DownloadDocButton(
                    //     url: model.media!,
                    //     messageId: model.messageId!,
                    //     docName: model.message!,
                    //   ),
                    messageBubble(
                      message: model,
                      isLastMessage: true,
                      isMyMessage: false,
                      context: context,
                    ),
                    // if (model.isDoc == true && isMyMessage)
                    //   DownloadDocButton(
                    //     url: model.media!,
                    //     messageId: model.messageId!,
                    //     docName: model.message!,
                    //   ),
                  ],
                ),
                if (0 == index) SizedBox(height: AppHeight.h5),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            height: AppHeight.h6,
          ),
        ),
      );

  Widget dayDate({required String date}) => Padding(
        padding: EdgeInsets.only(
          top: AppHeight.h10,
          bottom: AppHeight.h15,
        ),
        child: Card(
          color: dayDateColor ?? AppColors.lightBlack,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s20)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppHeight.h8,
              horizontal: AppWidth.w10,
            ),
            child: SmallHeadText(
              text: date,
              color: dayDateTextColor ?? AppColors.grey,
              size: dayDateSize ?? FontSize.s11,
            ),
          ),
        ),
      );

  Widget messageBubble(
          {required MessageModel message,
          required bool isLastMessage,
          required BuildContext context,
          required bool isMyMessage}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
        child: GestureDetector(
          onLongPress: () {},
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                minWidth: 0.0),
            padding: EdgeInsets.symmetric(
              vertical: message.message != "" || message.isDeleted == true
                  ? AppHeight.h8
                  : 0,
              horizontal: message.message != "" || message.isDeleted == true
                  ? AppWidth.w12
                  : 0,
            ).subtract(
              const EdgeInsets.only(
                top: 0,
                right: 0,
                left: 0,
              ),
            ),
            decoration: BoxDecoration(
              color: isMyMessage
                  ? senderColor ?? AppColors.blue
                  : receiverColor ?? AppColors.lightBlack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!isMyMessage ? AppSize.s20 : 0),
                topRight: Radius.circular(isMyMessage ? AppSize.s20 : 0),
                bottomLeft: Radius.circular(AppSize.s20),
                bottomRight: Radius.circular(AppSize.s20),
              ),
            ),
            child: message.isDeleted == true
                ? deletedMessage(date: message.date!)
                : message.isImage == true
                    ? imageMessage(isMyMessage: isMyMessage, message: message)
                    : textMessage(message: message, context: context),
          ),
        ),
      );

  Widget textMessage(
          {required MessageModel message, required BuildContext context}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SmallHeadText(
              // text: "${DateTime.parse(message.date!).toUtc()}",
              text: message.message!,
              size: messageTextSize ?? FontSize.s13,
              maxLines: 1000000,
              color: messageTextColor ??
                  Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          SizedBox(width: AppWidth.w5),
          SecondaryText(
            text:
                DateFormat.jm().format(DateTime.parse(message.date!).toLocal()),
            color: messageDateColor ?? AppColors.grey,
            size: FontSize.s10,
          )
        ],
      );

  Widget imageMessage(
          {required MessageModel message, required bool isMyMessage}) =>
      GestureDetector(
        onTap: () {},
        //     Go.to(
        //   context: context,
        //   screen:
        //   ShowMessageImageScreen(
        //     imageUrl: message.media!,
        //     name: message.senderId == di<UserStorage>().getUser()!.uId
        //         ? "You"
        //         : di<MessagesCubit>().user!.name!,
        //     date: message.date!,
        //   ),
        // ),
        child: SizedBox(
          width: AppWidth.w250,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(!isMyMessage ? AppSize.s20 : 0),
              topRight: Radius.circular(isMyMessage ? AppSize.s20 : 0),
              bottomLeft: Radius.circular(AppSize.s20),
              bottomRight: Radius.circular(AppSize.s20),
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CustomNetworkImage(
                    imageUrl: message.media!, fit: BoxFit.contain),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppHeight.h3, horizontal: AppWidth.w5),
                  child: SecondaryText(
                    text: DateFormat.jm()
                        .format(DateTime.parse(message.date!).toLocal()),
                    color: AppColors.grey,
                    size: FontSize.s10,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget deletedMessage({required String date}) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SmallHeadText(
              text: "this message was deleted.",
              size: FontSize.s13,
              color: AppColors.grey,
              italic: true,
            ),
          ),
          SizedBox(width: AppWidth.w5),
          SecondaryText(
            text: DateFormat.jm().format(DateTime.parse(date).toLocal()),
            color: AppColors.grey,
            size: FontSize.s10,
          )
        ],
      );
}

class SecondaryText extends StatelessWidget {
  final String text;
  final bool center;
  final double? size;
  final double? letterSpacing;
  final bool isLight;
  final bool isButton;
  final bool isEllipsis;
  final int? maxLines;
  final Color? color;
  final bool italic;

  const SecondaryText({
    super.key,
    required this.text,
    this.size,
    this.letterSpacing,
    this.center = false,
    this.isLight = false,
    this.isButton = false,
    this.isEllipsis = true,
    this.maxLines,
    this.color,
    this.italic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: size ?? FontSize.s14,
          fontWeight: isButton ? FontWeightManager.semiBold : null,
          color: color ??
              (isLight
                  ? Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.8)
                  : null),
          letterSpacing: letterSpacing ?? 0,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal),
      textAlign: center ? TextAlign.center : null,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
      maxLines: maxLines,
    );
  }
}

class LargeHeadText extends StatelessWidget {
  final String text;
  final double? size;
  final double? letterSpacing;
  final bool isEllipsis;
  final int maxLines;
  final Color? color;

  const LargeHeadText(
      {super.key,
      required this.text,
      this.size,
      this.letterSpacing,
      this.isEllipsis = true,
      this.maxLines = 1,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: size ?? FontSize.s16,
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
            letterSpacing: letterSpacing ?? 0,
          ),
      maxLines: maxLines,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
    );
  }
}

class SmallHeadText extends StatelessWidget {
  final String text;
  final double? size;
  final bool center;
  final bool isEllipsis;
  final bool isUnderLine;
  final bool italic;
  final int maxLines;
  final Color? color;

  const SmallHeadText(
      {super.key,
      required this.text,
      this.size,
      this.center = false,
      this.isEllipsis = true,
      this.isUnderLine = false,
      this.italic = false,
      this.maxLines = 1,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: size ?? 14.sp,
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
            decoration: isUnderLine ? TextDecoration.underline : null,
            decorationColor: AppColors.white,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          ),
      textAlign: center ? TextAlign.center : null,
      maxLines: maxLines,
      overflow: isEllipsis ? TextOverflow.ellipsis : null,
    );
  }
}

TextStyle _getTextStyle({
  required double fontSize,
  required String fontFamily,
  required FontWeight fontWeight,
  required Color fontColor,
  double? letterSpacing,
}) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: fontColor,
      letterSpacing: letterSpacing);
}

///Bold font style
TextStyle getBoldStyle(
    {double? fontSize, required Color fontColor, double? letterSpacing}) {
  double size = fontSize ?? FontSize.s14;
  return _getTextStyle(
      fontSize: size,
      fontFamily: FontFamily.fontFamily,
      fontWeight: FontWeightManager.bold,
      fontColor: fontColor,
      letterSpacing: letterSpacing);
}

///SemiBold font style
TextStyle getSemiBoldStyle(
    {double? fontSize, required Color fontColor, double? letterSpacing}) {
  double size = fontSize ?? FontSize.s14;
  return _getTextStyle(
      fontSize: size,
      fontFamily: FontFamily.fontFamily,
      fontWeight: FontWeightManager.semiBold,
      fontColor: fontColor,
      letterSpacing: letterSpacing);
}

///Medium font style
TextStyle getMediumStyle(
    {double? fontSize, required Color fontColor, double? letterSpacing}) {
  double size = fontSize ?? FontSize.s14;
  return _getTextStyle(
      fontSize: size,
      fontFamily: FontFamily.fontFamily,
      fontWeight: FontWeightManager.medium,
      fontColor: fontColor,
      letterSpacing: letterSpacing);
}

///Regular font style
TextStyle getRegularStyle(
    {double? fontSize, required Color fontColor, double? letterSpacing}) {
  double size = fontSize ?? FontSize.s14;
  return _getTextStyle(
      fontSize: size,
      fontFamily: FontFamily.fontFamily,
      fontWeight: FontWeightManager.regular,
      fontColor: fontColor,
      letterSpacing: letterSpacing);
}

///Light font style
TextStyle getLightStyle(
    {double? fontSize, required Color fontColor, double? letterSpacing}) {
  double size = fontSize ?? FontSize.s14;
  return _getTextStyle(
      fontSize: size,
      fontFamily: FontFamily.fontFamily,
      fontWeight: FontWeightManager.light,
      fontColor: fontColor,
      letterSpacing: letterSpacing);
}

class AppWidth {
  static double w1 = 1.w;
  static double w2 = 2.w;
  static double w3 = 3.w;
  static double w4 = 4.w;
  static double w5 = 5.w;
  static double w6 = 6.w;
  static double w7 = 7.w;
  static double w8 = 8.w;
  static double w9 = 9.w;
  static double w10 = 10.w;
  static double w11 = 11.w;
  static double w12 = 12.w;
  static double w13 = 13.w;
  static double w14 = 14.w;
  static double w15 = 15.w;
  static double w16 = 16.w;
  static double w17 = 17.w;
  static double w18 = 18.w;
  static double w19 = 19.w;
  static double w20 = 20.w;
  static double w25 = 25.w;
  static double w30 = 30.w;
  static double w35 = 35.w;
  static double w40 = 40.w;
  static double w45 = 45.w;
  static double w50 = 50.w;
  static double w60 = 60.w;
  static double w70 = 70.w;
  static double w80 = 80.w;
  static double w90 = 90.w;
  static double w100 = 100.w;
  static double w115 = 115.w;
  static double w120 = 120.w;
  static double w130 = 130.w;
  static double w140 = 140.w;
  static double w150 = 150.w;
  static double w160 = 160.w;
  static double w170 = 170.w;
  static double w180 = 180.w;
  static double w190 = 190.w;
  static double w200 = 200.w;
  static double w210 = 210.w;
  static double w220 = 220.w;
  static double w230 = 230.w;
  static double w240 = 240.w;
  static double w250 = 250.w;
  static double w300 = 300.w;
  static double w500 = 500.w;
  static double w600 = 600.w;
}

class AppHeight {
  static double h0_7 = 0.7.h;
  static double h1 = 1.h;
  static double h2 = 2.h;
  static double h3 = 3.h;
  static double h4 = 4.h;
  static double h5 = 5.h;
  static double h6 = 6.h;
  static double h7 = 7.h;
  static double h8 = 8.h;
  static double h9 = 9.h;
  static double h10 = 10.h;
  static double h11 = 11.h;
  static double h12 = 12.h;
  static double h13 = 13.h;
  static double h14 = 14.h;
  static double h15 = 15.h;
  static double h16 = 16.h;
  static double h17 = 17.h;
  static double h18 = 18.h;
  static double h19 = 19.h;
  static double h20 = 20.h;
  static double h25 = 25.h;
  static double h30 = 30.h;
  static double h40 = 40.h;
  static double h41 = 41.h;
  static double h42 = 42.h;
  static double h43 = 43.h;
  static double h44 = 44.h;
  static double h45 = 45.h;
  static double h50 = 50.h;
  static double h60 = 60.h;
  static double h70 = 70.h;
  static double h75 = 75.h;
  static double h80 = 80.h;
  static double h90 = 90.h;
  static double h100 = 100.h;
  static double h110 = 110.h;
  static double h120 = 120.h;
  static double h130 = 130.h;
  static double h140 = 140.h;
  static double h150 = 150.h;
  static double h160 = 160.h;
  static double h170 = 170.h;
  static double h180 = 180.h;
  static double h200 = 200.h;
  static double h230 = 230.h;
  static double h250 = 250.h;
  static double h300 = 300.h;
  static double h320 = 320.h;
  static double h400 = 400.h;
  static double h490 = 490.h;
}

class AppSize {
  static double s1 = 1.sp;
  static double s2 = 2.sp;
  static double s3 = 3.sp;
  static double s4 = 4.sp;
  static double s5 = 5.sp;
  static double s6 = 6.sp;
  static double s7 = 7.sp;
  static double s8 = 8.sp;
  static double s9 = 9.sp;
  static double s10 = 10.sp;
  static double s11 = 11.sp;
  static double s12 = 12.sp;
  static double s13 = 13.sp;
  static double s14 = 14.sp;
  static double s15 = 15.sp;
  static double s16 = 16.sp;
  static double s17 = 17.sp;
  static double s18 = 18.sp;
  static double s19 = 19.sp;
  static double s20 = 20.sp;
  static double s21 = 21.sp;
  static double s22 = 22.sp;
  static double s23 = 23.sp;
  static double s24 = 24.sp;
  static double s25 = 25.sp;
  static double s26 = 26.sp;
  static double s27 = 27.sp;
  static double s28 = 28.sp;
  static double s29 = 29.sp;
  static double s30 = 30.sp;
  static double s35 = 35.sp;
  static double s40 = 40.sp;
  static double s45 = 45.sp;
  static double s50 = 50.sp;
  static double s60 = 60.sp;
  static double s70 = 70.sp;
  static double s80 = 80.sp;
  static double s90 = 90.sp;
  static double s100 = 100.sp;
  static double s110 = 110.sp;
  static double s120 = 120.sp;
  static double s130 = 130.sp;
  static double s140 = 140.sp;
  static double s150 = 150.sp;
  static double s250 = 250.sp;
}

class AppColors {
  static const Color black = Color(0xff1C1B1B);
  static const Color offWhite = Color(0xffF2F2F2);
  static const Color grey = Color(0xffCCCCCC);
  static const Color white = Color(0xffFFFFFF);
  static const Color blue = Color(0xff007EF4);
  static const Color lightBlack = Color(0xff2B2B2B);
  static const Color darkBlack = Color(0xff1F1F1F);
  static const Color red = Colors.red;
  static final Color lightRed = Colors.red.withOpacity(0.4);

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  static Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  static int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  static Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);
}

class FontWeightManager {
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight light = FontWeight.w300;
}

class FontSize {
  static double s2 = 2.sp;
  static double s4 = 4.sp;
  static double s6 = 6.sp;
  static double s8 = 8.sp;
  static double s10 = 10.sp;
  static double s11 = 11.sp;
  static double s12 = 12.sp;
  static double s13 = 13.sp;
  static double s14 = 14.sp;
  static double s15 = 15.sp;
  static double s16 = 16.sp;
  static double s17 = 17.sp;
  static double s18 = 18.sp;
  static double s20 = 20.sp;
  static double s21 = 21.sp;
  static double s22 = 22.sp;
  static double s24 = 24.sp;
  static double s26 = 26.sp;
  static double s28 = 28.sp;
  static double s30 = 30.sp;
  static double s34 = 34.sp;
  static double s38 = 38.sp;
  static double s42 = 42.sp;
  static double s45 = 45.sp;
  static double s50 = 50.sp;
  static double s55 = 55.sp;
  static double s60 = 60.sp;
}

class FontFamily {
  static const String fontFamily = "Montserrat";
}

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const CustomNetworkImage(
      {super.key, required this.imageUrl, required this.fit});

  Future<bool> checkInternet() async {
    bool? result;
    InternetConnectionChecker().hasConnection.then((value) => result = value);
    return result!;
    // return await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, s) => SizedBox(
        height: AppHeight.h200,
        child: Center(
          child:
              CustomCircleIndicator(color: AppColors.white, size: AppSize.s25),
        ),
      ),
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) {
        return Center(
          child: SizedBox(
            height: AppHeight.h200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconBroken.Danger,
                  size: AppSize.s50,
                  color: AppColors.grey,
                ),
                const SecondaryText(text: "connection error")
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final bool obscureText;
  final bool readOnly;
  final int? maxlength;
  final Color? filledColor;
  final bool? isFilled;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onFelidSubmitted;
  final void Function()? onTap;
  final TextEditingController controller;
  final TextInputType inputType;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxlength,
    this.obscureText = false,
    this.readOnly = false,
    required this.controller,
    this.onChange,
    this.onFelidSubmitted,
    this.onTap,
    required this.inputType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.filledColor,
    this.isFilled = true,
    this.hintStyle,
    this.borderRadius,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      // onTapOutside: (event) => FocusScope.of(context).unfocus(),
      maxLength: maxlength,
      style: getSemiBoldStyle(
          fontColor: Theme.of(context).textTheme.bodyLarge!.color!),
      validator: validator,
      onChanged: onChange,
      onFieldSubmitted: onFelidSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(25.0),
          borderSide: borderSide ?? BorderSide.none,
        ),
        fillColor: filledColor,
        filled: isFilled,
        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: AppColors.blue,
                size: AppSize.s20,
              )
            : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class SendMessageButton extends StatefulWidget {
  final TextEditingValue value;
  final Color? sendBtnColor;

  const SendMessageButton({super.key, required this.value, this.sendBtnColor});

  @override
  State<SendMessageButton> createState() => _SendMessageButtonState();
}

class _SendMessageButtonState extends State<SendMessageButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: CircleAvatar(
        radius: AppSize.s22,
        backgroundColor:
            widget.value.text.isNotEmpty ? widget.sendBtnColor : Colors.grey,
        child: Icon(
          IconBroken.Send,
          size: AppSize.s22,
          color: widget.value.text.isNotEmpty
              ? Colors.white
              : AppColors.lightBlack,
        ),
      ),
    );
  }
}

enum MessageType {
  deleted,
  text,
  image,
  video,
  doc,
}

class IconBroken {
  IconBroken._();

  static const String _fontFamily = 'IconBroken';

  static const IconData User = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData User1 = IconData(0xe901, fontFamily: _fontFamily);
  static const IconData Activity = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData Add_User = IconData(0xe903, fontFamily: _fontFamily);
  static const IconData Arrow___Down_2 =
      IconData(0xe904, fontFamily: _fontFamily);
  static const IconData Arrow___Down_3 =
      IconData(0xe905, fontFamily: _fontFamily);
  static const IconData Arrow___Down_Circle =
      IconData(0xe906, fontFamily: _fontFamily);
  static const IconData Arrow___Down_Square =
      IconData(0xe907, fontFamily: _fontFamily);
  static const IconData Arrow___Down =
      IconData(0xe908, fontFamily: _fontFamily);
  static const IconData Arrow___Left_2 =
      IconData(0xe909, fontFamily: _fontFamily);
  static const IconData Arrow___Left_3 =
      IconData(0xe90a, fontFamily: _fontFamily);
  static const IconData Arrow___Left_Circle =
      IconData(0xe90b, fontFamily: _fontFamily);
  static const IconData Arrow___Left_Square =
      IconData(0xe90c, fontFamily: _fontFamily);
  static const IconData Arrow___Left =
      IconData(0xe90d, fontFamily: _fontFamily);
  static const IconData Arrow___Right_2 =
      IconData(0xe90e, fontFamily: _fontFamily);
  static const IconData Arrow___Right_3 =
      IconData(0xe90f, fontFamily: _fontFamily);
  static const IconData Arrow___Right_Circle =
      IconData(0xe910, fontFamily: _fontFamily);
  static const IconData Arrow___Right_Square =
      IconData(0xe911, fontFamily: _fontFamily);
  static const IconData Arrow___Right =
      IconData(0xe912, fontFamily: _fontFamily);
  static const IconData Arrow___Up_2 =
      IconData(0xe913, fontFamily: _fontFamily);
  static const IconData Arrow___Up_3 =
      IconData(0xe914, fontFamily: _fontFamily);
  static const IconData Arrow___Up_Circle =
      IconData(0xe915, fontFamily: _fontFamily);
  static const IconData Arrow___Up_Square =
      IconData(0xe916, fontFamily: _fontFamily);
  static const IconData Arrow___Up = IconData(0xe917, fontFamily: _fontFamily);
  static const IconData Bag_2 = IconData(0xe918, fontFamily: _fontFamily);
  static const IconData Bag = IconData(0xe919, fontFamily: _fontFamily);
  static const IconData Bookmark = IconData(0xe91a, fontFamily: _fontFamily);
  static const IconData Buy = IconData(0xe91b, fontFamily: _fontFamily);
  static const IconData Calendar = IconData(0xe91c, fontFamily: _fontFamily);
  static const IconData Call_Missed = IconData(0xe91d, fontFamily: _fontFamily);
  static const IconData Call_Silent = IconData(0xe91e, fontFamily: _fontFamily);
  static const IconData Call = IconData(0xe91f, fontFamily: _fontFamily);
  static const IconData Calling = IconData(0xe920, fontFamily: _fontFamily);
  static const IconData Camera = IconData(0xe921, fontFamily: _fontFamily);
  static const IconData Category = IconData(0xe922, fontFamily: _fontFamily);
  static const IconData Chart = IconData(0xe923, fontFamily: _fontFamily);
  static const IconData Chat = IconData(0xe924, fontFamily: _fontFamily);
  static const IconData Close_Square =
      IconData(0xe925, fontFamily: _fontFamily);
  static const IconData Danger = IconData(0xe926, fontFamily: _fontFamily);
  static const IconData Delete = IconData(0xe927, fontFamily: _fontFamily);
  static const IconData Discount = IconData(0xe928, fontFamily: _fontFamily);
  static const IconData Discovery = IconData(0xe929, fontFamily: _fontFamily);
  static const IconData Document = IconData(0xe92a, fontFamily: _fontFamily);
  static const IconData Download = IconData(0xe92b, fontFamily: _fontFamily);
  static const IconData Edit_Square = IconData(0xe92c, fontFamily: _fontFamily);
  static const IconData Edit = IconData(0xe92d, fontFamily: _fontFamily);
  static const IconData Filter_2 = IconData(0xe92e, fontFamily: _fontFamily);
  static const IconData Filter = IconData(0xe92f, fontFamily: _fontFamily);
  static const IconData Folder = IconData(0xe930, fontFamily: _fontFamily);
  static const IconData Game = IconData(0xe931, fontFamily: _fontFamily);
  static const IconData Graph = IconData(0xe932, fontFamily: _fontFamily);
  static const IconData Heart = IconData(0xe933, fontFamily: _fontFamily);
  static const IconData Hide = IconData(0xe934, fontFamily: _fontFamily);
  static const IconData Home = IconData(0xe935, fontFamily: _fontFamily);
  static const IconData Image_2 = IconData(0xe936, fontFamily: _fontFamily);
  static const IconData Image = IconData(0xe937, fontFamily: _fontFamily);
  static const IconData Info_Circle = IconData(0xe938, fontFamily: _fontFamily);
  static const IconData Info_Square = IconData(0xe939, fontFamily: _fontFamily);
  static const IconData Location = IconData(0xe93a, fontFamily: _fontFamily);
  static const IconData Lock = IconData(0xe93b, fontFamily: _fontFamily);
  static const IconData Login = IconData(0xe93c, fontFamily: _fontFamily);
  static const IconData Logout = IconData(0xe93d, fontFamily: _fontFamily);
  static const IconData Message = IconData(0xe93e, fontFamily: _fontFamily);
  static const IconData More_Circle = IconData(0xe93f, fontFamily: _fontFamily);
  static const IconData More_Square = IconData(0xe940, fontFamily: _fontFamily);
  static const IconData Notification =
      IconData(0xe941, fontFamily: _fontFamily);
  static const IconData Paper_Download =
      IconData(0xe942, fontFamily: _fontFamily);
  static const IconData Paper_Fail = IconData(0xe943, fontFamily: _fontFamily);
  static const IconData Paper_Negative =
      IconData(0xe944, fontFamily: _fontFamily);
  static const IconData Paper_Plus = IconData(0xe945, fontFamily: _fontFamily);
  static const IconData Paper_Upload =
      IconData(0xe946, fontFamily: _fontFamily);
  static const IconData Paper = IconData(0xe947, fontFamily: _fontFamily);
  static const IconData Password = IconData(0xe948, fontFamily: _fontFamily);
  static const IconData Play = IconData(0xe949, fontFamily: _fontFamily);
  static const IconData Plus = IconData(0xe94a, fontFamily: _fontFamily);
  static const IconData Profile = IconData(0xe94b, fontFamily: _fontFamily);
  static const IconData Scan = IconData(0xe94c, fontFamily: _fontFamily);
  static const IconData Search = IconData(0xe94d, fontFamily: _fontFamily);
  static const IconData Send = IconData(0xe94e, fontFamily: _fontFamily);
  static const IconData Setting = IconData(0xe94f, fontFamily: _fontFamily);
  static const IconData Shield_Done = IconData(0xe950, fontFamily: _fontFamily);
  static const IconData Shield_Fail = IconData(0xe951, fontFamily: _fontFamily);
  static const IconData Show = IconData(0xe952, fontFamily: _fontFamily);
  static const IconData Star = IconData(0xe953, fontFamily: _fontFamily);
  static const IconData Swap = IconData(0xe954, fontFamily: _fontFamily);
  static const IconData Tick_Square = IconData(0xe955, fontFamily: _fontFamily);
  static const IconData Ticket_Star = IconData(0xe956, fontFamily: _fontFamily);
  static const IconData Ticket = IconData(0xe957, fontFamily: _fontFamily);
  static const IconData Time_Circle = IconData(0xe958, fontFamily: _fontFamily);
  static const IconData Time_Square = IconData(0xe959, fontFamily: _fontFamily);
  static const IconData Unlock = IconData(0xe95a, fontFamily: _fontFamily);
  static const IconData Upload = IconData(0xe95b, fontFamily: _fontFamily);
  static const IconData Video = IconData(0xe95c, fontFamily: _fontFamily);
  static const IconData Voice_2 = IconData(0xe95d, fontFamily: _fontFamily);
  static const IconData Voice = IconData(0xe95e, fontFamily: _fontFamily);
  static const IconData Volume_Down = IconData(0xe95f, fontFamily: _fontFamily);
  static const IconData Volume_Off = IconData(0xe960, fontFamily: _fontFamily);
  static const IconData Volume_Up = IconData(0xe961, fontFamily: _fontFamily);
  static const IconData Wallet = IconData(0xe962, fontFamily: _fontFamily);
  static const IconData Work = IconData(0xe963, fontFamily: _fontFamily);
}

class MessageModel {
  String? senderId;
  String? receiverId;
  String? message;
  String? messageId;
  String? date;
  String? isDeleted;
  String? media;
  String? isImage;

  MessageModel(
      {this.senderId,
      this.receiverId,
      this.message,
      this.messageId,
      this.isDeleted,
      this.date,
      this.isImage,
      this.media});

  MessageModel.fromJson(dynamic json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    messageId = json['messageId'];
    isDeleted = json['isDeleted'];
    date = json['date'];
    isImage = json['isImage'];
    media = json['media'];
  }
}

class CustomCircleIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;
  final double? percentage;

  const CustomCircleIndicator(
      {super.key, this.size, this.color, this.strokeWidth, this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? AppSize.s30,
      height: size ?? AppSize.s30,
      child: CircularProgressIndicator(
        color: color ?? AppColors.blue,
        strokeWidth: strokeWidth ?? AppSize.s2,
        backgroundColor: percentage != null ? AppColors.lightBlack : null,
        value: percentage,
      ),
    );
  }
}

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final Color? appBarColor;
  final Color? appBarTextColor;
  final Color? appBarIconColor;

  const MessagesAppBar(
      {super.key,
      required this.name,
      this.appBarColor,
      this.appBarTextColor,
      this.appBarIconColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppHeight.h60,
      backgroundColor: appBarColor ?? AppColors.darkBlack,
      surfaceTintColor: AppColors.darkBlack,
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(AppSize.s20),
        bottomRight: Radius.circular(AppSize.s20),
      )),
      title: LargeHeadText(
        text: name,
        size: FontSize.s15,
        color: appBarTextColor ?? Colors.black,
      ),
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(IconBroken.Arrow___Left, color: appBarIconColor)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppHeight.h60);
}
