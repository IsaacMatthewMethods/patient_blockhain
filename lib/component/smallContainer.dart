import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/constant.dart';

class SmallContainer extends StatelessWidget {
  final txt, icon, onTap;
  const SmallContainer({super.key, this.txt, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kWhiteSmoke,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(3, 2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        icon,
                        color: kDefault,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      sizedBox,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          txt,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_outlined, color: kDefault)
            ],
          ),
        ),
      ),
    );
  }
}

class ListContainer1 extends StatelessWidget {
  final title,
      dates,
      driver_name,
      onPressed,
      price,
      subtitle,
      viewBidder,
      prescribe,
      license_no,
      departure,
      destination;

  final int counter;
  const ListContainer1({
    super.key,
    this.title,
    this.price,
    this.dates,
    this.onPressed,
    this.subtitle,
    required this.counter,
    this.license_no,
    this.departure,
    this.destination,
    this.driver_name,
    this.viewBidder,
    this.prescribe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 14.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 160,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: kWhiteSmoke),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: Offset(3, 2),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Item name:"),
                                Text("Minimum amount:"),
                                Text("Ending date:"),
                                Text("Item status:"),
                                // Text("Chasis number"),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("$title",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Bold")),
                                      // Text(" / $price")
                                    ],
                                  ),
                                  Text(
                                    "$driver_name",
                                    style: TextStyle(fontFamily: "Bold"),
                                  ),
                                  Text(
                                    "$departure",
                                    style: TextStyle(fontFamily: "Bold"),
                                  ),
                                  license_no == "sold"
                                      ? Text(
                                          "$license_no",
                                          style: TextStyle(
                                            fontFamily: "Bold",
                                            color: kRed,
                                          ),
                                        )
                                      : Text("$license_no",
                                          style: TextStyle(
                                            fontFamily: "Bold",
                                            color: kDefault,
                                          )),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
              sizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    color: Color.fromARGB(255, 155, 94, 2),
                    child: TextButton(
                      onPressed: prescribe,
                      child:
                          Text("Delete Item", style: TextStyle(color: kWhite)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: kBlue,
                        // ),
                        borderRadius: BorderRadius.circular(5)),
                    height: 30,
                    child: Container(
                      color: kDefault,
                      child: TextButton(
                        // style: ButtonStyle(backgroundColor: kRed),
                        onPressed: viewBidder,
                        child: Text("Highest Bidder",
                            style: TextStyle(color: kWhite)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListContainer2 extends StatelessWidget {
  final String? title,
      paymentDate,
      bookingDate,
      bookingTime,
      bookingAddress,
      description,
      subtitle,
      amount,
      departure,
      status,
      receipt;
  final VoidCallback? onPressed, viewBidder, prescribe;
  final int counter;

  const ListContainer2({
    super.key,
    this.title,
    this.paymentDate,
    this.bookingDate,
    this.bookingTime,
    this.bookingAddress,
    this.description,
    this.subtitle,
    this.amount,
    this.departure,
    this.status,
    this.receipt,
    this.onPressed,
    this.viewBidder,
    this.prescribe,
    required this.counter,
  });

  Color getStatusColor() {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.redAccent;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return kDefault;
    }
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🧾 Order ID + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: ${receipt ?? '-'}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status?.toUpperCase() ?? 'N/A',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: getStatusColor(),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            /// 🔠 Labeled Info Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Labels
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Category:", style: _labelStyle),
                      SizedBox(height: 14),
                      Text("Amount:", style: _labelStyle),
                      SizedBox(height: 14),
                      Text("Payment Date:", style: _labelStyle),
                      SizedBox(height: 14),
                      Text("Booking Date:", style: _labelStyle),
                      SizedBox(height: 14),
                      Text("Booking Time:", style: _labelStyle),
                      SizedBox(height: 14),
                      Text("Booking Address:", style: _labelStyle),
                    ],
                  ),
                ),

                /// Values
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title ?? '-', style: _valueStyle),
                      const SizedBox(height: 14),
                      Text("₦${amount ?? '-'}",
                          style: _valueStyle.copyWith(
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      Text(paymentDate ?? '-', style: _valueStyle),
                      const SizedBox(height: 14),
                      Text(bookingDate ?? '-', style: _valueStyle),
                      const SizedBox(height: 14),
                      Text(bookingTime ?? '-', style: _valueStyle),
                      const SizedBox(height: 14),
                      Text(bookingAddress ?? '-', style: _valueStyle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// 🖨️ CTA Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: viewBidder,
                icon: const Icon(Icons.receipt_long_rounded, size: 18),
                label: const Text("Print Receipt"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
const _labelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF888D95),
);

const _valueStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Color(0xFF1C1C1E),
);
