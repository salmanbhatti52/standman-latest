      // showDialog(
      //                         context: context,
      //                         builder: (BuildContext context) => Dialog(
      //                           shape: RoundedRectangleBorder(
      //                             borderRadius: BorderRadius.circular(30.0),
      //                           ),
      //                           child: Stack(
      //                             clipBehavior: Clip.none,
      //                             alignment: Alignment.topCenter,
      //                             children: [
      //                               Container(
      //                                 width: 350,
      //                                 height:  537,
      //                                 decoration: BoxDecoration(
      //                                   color: const Color(0xFFFFFF),
      //                                   borderRadius: BorderRadius.circular(32),
      //                                 ),
      //                                 child: Column(
      //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                                   crossAxisAlignment: CrossAxisAlignment.center,
      //                                   children: [
      //                                     SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
      //                                     const Text(
      //                                       "Job Completed, Amount Paid",
      //                                       style: TextStyle(
      //                                         color: Color.fromRGBO(0, 0, 0, 1),
      //                                         fontFamily: "Outfit",
      //                                         fontSize: 20,
      //                                         fontWeight: FontWeight.w500,
      //                                         // letterSpacing: -0.3,
      //                                       ),
      //                                       textAlign: TextAlign.center,
      //                                     ),
      //                                     Container(
      //                                       width: MediaQuery.of(context).size.width * 0.6 , //241,
      //                                       height: MediaQuery.of(context).size.height * 0.095, // 70,
      //                                       decoration: BoxDecoration(
      //                                         borderRadius: BorderRadius.circular(12),
      //                                         color: Color(0xffF3F3F3),
      //                                         border: Border.all(color: Color(0xffF3F3F3), width: 1),
      //                                       ),
      //                                       child:  Column(
      //                                         mainAxisAlignment: MainAxisAlignment.center,
      //                                         crossAxisAlignment: CrossAxisAlignment.center,
      //                                         children: [
      //                                           SizedBox(width: 5,),
      //                                           Column(
      //                                             mainAxisAlignment: MainAxisAlignment.center,
      //                                             crossAxisAlignment: CrossAxisAlignment.center,
      //                                             children: [
      //                                               Row(
      //                                                 mainAxisAlignment: MainAxisAlignment.center,
      //                                                 crossAxisAlignment: CrossAxisAlignment.center,
      //                                                 children: [
      //                                                   Text(
      //                                                     '\$',
      //                                                     style: TextStyle(
      //                                                       color: Color(0xff21335B),
      //                                                       fontFamily: "Outfit",
      //                                                       fontSize: 18,
      //                                                       fontWeight: FontWeight.w400,
      //                                                       // letterSpacing: -0.3,
      //                                                     ),
      //                                                     textAlign: TextAlign.left,
      //                                                   ),
      //                                                   Text(
      //                                                     ' 22.00',
      //                                                     style: TextStyle(
      //                                                       color: Color(0xff2B65EC),
      //                                                       fontFamily: "Outfit",
      //                                                       fontSize: 36,
      //                                                       fontWeight: FontWeight.w600,
      //                                                       // letterSpacing: -0.3,
      //                                                     ),
      //                                                     textAlign: TextAlign.center,
      //                                                   ),
      //                                                 ],
      //                                               ),
      //                                               Text(
      //                                                 'you paid',
      //                                                 style: TextStyle(
      //                                                   color: Color(0xffA7A9B7),
      //                                                   fontFamily: "Outfit",
      //                                                   fontSize: 12,
      //                                                   fontWeight: FontWeight.w500,
      //                                                   // letterSpacing: -0.3,
      //                                                 ),
      //                                                 textAlign: TextAlign.center,
      //                                               ),
      //                                             ],
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                     Padding(
      //                                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
      //                                       child: Row(
      //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                         children: [
      //                                           const Text(
      //                                             "From",
      //                                             style: TextStyle(
      //                                               color: Color(0xff2B65EC),
      //                                               fontFamily: "Outfit",
      //                                               fontSize: 14,
      //                                               fontWeight: FontWeight.w600,
      //                                               // letterSpacing: -0.3,
      //                                             ),
      //                                             textAlign: TextAlign.left,
      //                                           ),
      //                                           const Text(
      //                                             "Beby Jovanca",
      //                                             style: TextStyle(
      //                                               color: Color.fromRGBO(0, 0, 0, 1),
      //                                               fontFamily: "Outfit",
      //                                               fontSize: 14,
      //                                               fontWeight: FontWeight.w400,
      //                                               // letterSpacing: -0.3,
      //                                             ),
      //                                             textAlign: TextAlign.right,
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                     Divider(
      //                                       color: Color(0xffF3F3F3),
      //                                       height: 1,
      //                                       indent: 40,
      //                                       endIndent: 40,
      //                                       thickness: 1,
      //                                     ),
      //                                     Padding(
      //                                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
      //                                       child: Row(
      //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                         children: [
      //                                           const Text(
      //                                             "To",
      //                                             style: TextStyle(
      //                                               color: Color(0xff2B65EC),
      //                                               fontFamily: "Outfit",
      //                                               fontSize: 14,
      //                                               fontWeight: FontWeight.w600,
      //                                               // letterSpacing: -0.3,
      //                                             ),
      //                                             textAlign: TextAlign.left,
      //                                           ),
      //                                           const Text(
      //                                             "Annette Black",
      //                                             style: TextStyle(
      //                                               color: Color.fromRGBO(0, 0, 0, 1),
      //                                               fontFamily: "Outfit",
      //                                               fontSize: 14,
      //                                               fontWeight: FontWeight.w400,
      //                                               // letterSpacing: -0.3,
      //                                             ),
      //                                             textAlign: TextAlign.right,
      //                                           ),
      //                                         ],
      //                                       ),
      //                                     ),
      //                                     Divider(
      //                                       color: Color(0xffF3F3F3),
      //                                       height: 1,
      //                                       indent: 40,
      //                                       endIndent: 40,
      //                                       thickness: 1,
      //                                     ),
      //                                     Padding(
      //                                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
      //                                       child: Row(
      //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                         children: [
      //                                           const Text(
      //                                             "Date",
      //                                             style: TextStyle(
      //                                               color: Color(0xff2B65EC),
      //                                               fontFamily: "Outfit",
      //                                               fontSize: 14,
      //                                               fontWeight: FontWeight.w600,
      //                                               // letterSpacing: -0.3,
      //                                             ),
      //                                             textAlign: TextAlign.left,
      //                                           ),
      //                                           Column(
      //                                             mainAxisAlignment: MainAxisAlignment.end,
      //                                             crossAxisAlignment: CrossAxisAlignment.end,
      //                                             children: [
      //                                               const Text(
      //                                                 "24 Jul 2020",
      //                                                 style: TextStyle(
      //                                                   color: Color.fromRGBO(0, 0, 0, 1),
      //                                                   fontFamily: "Outfit",
      //                                                   fontSize: 14,
      //                                                   fontWeight: FontWeight.w400,
      //                                                   // letterSpacing: -0.3,
      //                                                 ),
      //                                                 textAlign: TextAlign.right,
      //                                               ),
      //                                               Text(
      //                                                 '15:30',
      //                                                 style: TextStyle(
      //                                                   color: Color(0xffA7A9B7),
      //                                                   fontFamily: "Outfit",
      //                                                   fontSize: 14,
      //                                                   fontWeight: FontWeight.w400,
      //                                                   // letterSpacing: -0.3,
      //                                                 ),
      //                                                 textAlign: TextAlign.right,
      //                                               ),
      //                                             ],
      //                                           )
      //                                         ],
      //                                       ),
      //                                     ),
      //                                     SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
      //                                     // mainButton("Add Ratings", Color(0xff2B65EC), context),
      //                                   ],
      //                                 ),
      //                               ),
      //                               Positioned(
      //                                   top: -48,
      //                                   child: Container(
      //                                     width: MediaQuery.of(context).size.width , //106,
      //                                     height: MediaQuery.of(context).size.height * 0.13, //106,
      //                                     decoration: BoxDecoration(
      //                                       shape: BoxShape.circle,
      //                                       color: Color(0xffFF9900),
      //                                     ),
      //                                     child: Icon(
      //                                       Icons.check,
      //                                       size: 40,
      //                                       color: Colors.white,
      //                                     ),
      //                                   ))
      //                             ],
      //                           ),
      //                         ),
      //                       );