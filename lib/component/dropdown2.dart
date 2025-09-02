import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constant/constant.dart';

class MyDropDown1 extends StatelessWidget {
  final String? selectedItem;
  final onChange;
  final List<String> items1;
  const MyDropDown1(
      {super.key,
      required this.items1,
      this.selectedItem,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: const [
              Icon(
                Icons.list,
                size: 16,
                color: Colors.black,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items1
              .map((item2) => DropdownMenuItem<String>(
                    value: item2,
                    child: Text(
                      item2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedItem,
          onChanged: onChange,
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.black,
          iconDisabledColor: Colors.grey,
          buttonHeight: 50,
          buttonWidth: MediaQuery.of(context).size.width,
          buttonPadding: const EdgeInsets.only(left: 14, right: 14),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.black26,
            ),
            color: kWhite,
          ),
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 24, right: 14),
          dropdownMaxHeight: 200,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          scrollbarRadius: const Radius.circular(30),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
        ),
      ),
    );
  }
}
