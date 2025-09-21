import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
class CustomText {
/*
  static late final String? text;
  static late final Color? color;
  static late final TextAlign? textAlign;
  static late final int? maxLines;
  static late final bool? softWrap;
  static late final TextOverflow? overflow;
*/

  static primaryTitle(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        double? fontSize,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: fontSize ?? 20,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static secondaryTitle(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: 17,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static headlineText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: 16,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static buttonText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        double? fontSize,
        TextDecoration? decoration,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          decoration: decoration,
          fontSize: fontSize ?? 16,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.white,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static spanText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        double? fontSize,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow,
      );

  static bodyText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        double? fontSize,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow,
      );

  static inputText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight,
        FontStyle? fontStyle}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: 14,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w400,
            color: color ?? Colors.black,
            fontStyle: fontStyle ?? FontStyle.normal),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? false,
        overflow: overflow ?? TextOverflow.fade,
      );

  static calloutText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static subHeadingText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        double? fontSize,
        FontWeight? fontWeight,
        TextDecoration? textDecoration,
        FontStyle? fontStyle}) =>
      Text(
        text!,
        style: TextStyle(
            fontSize: fontSize ?? 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: fontWeight ?? FontWeight.w300,
            color: color ?? Colors.black,
            decoration: textDecoration ?? TextDecoration.none,
            fontStyle: fontStyle ?? FontStyle.normal),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static footNoteText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: 11,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static captionText(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight}) =>
      Text(
        text!,
        style: TextStyle(
          fontSize: 10,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w400,
          color: color ?? Colors.black,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.fade,
      );

  static Widget text({
    required String text,
    Color? color,
    Color? underLineColor,
    TextAlign? textAlign,
    int? maxLines,
    bool? softWrap,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? letterSpacing,
    double? wordSpacing,
    double? lineHeight,
    ValueKey<bool>? key,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: lineHeight,
        decorationColor: underLineColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.fade,
    );
  }


  static appBar(
      {String? text,
        Color? color,
        TextAlign? textAlign,
        int? maxLines,
        bool? softWrap,
        TextOverflow? overflow,
        FontWeight? fontWeight,
        FontStyle? fontStyle}) =>
      Text(
        text!,
        style: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: FontWeight.w500,
        ),
        maxLines: maxLines,
        softWrap: softWrap ?? false,
        overflow: overflow ?? TextOverflow.fade,
      );
}
