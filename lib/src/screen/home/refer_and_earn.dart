import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RefferEarn extends StatelessWidget {
  const RefferEarn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 4, left: 10, right: 10),
      decoration: BoxDecoration(
          color: authGreyColor,
          border: Border.all(color: greyColor.withOpacity(0.2), width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icon/refer.svg",
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Share the app with your friends",
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: blackColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 6, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: blackColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          "Share Now",
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: whiteColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
