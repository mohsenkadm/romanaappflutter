import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/CityController.dart';
import 'package:romanaappflutter/Model/CityModel.dart';
import 'package:romanaappflutter/main.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

final CityController cityController = Get.put(CityController());
final TextEditingController textEditingController = TextEditingController();
final TextEditingController textEditing2Controller = TextEditingController();

class _ChooseLocationState extends State<ChooseLocation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: MyAppBar(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              alignment: Alignment.topCenter,
              child: Obx(
                () => Center( 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                           DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:   BorderSide(color: Theme.of(context).primaryColor),
                          ), 
                            contentPadding: const EdgeInsets.symmetric(vertical: 5),
                            border: OutlineInputBorder( 
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // Add more decoration..
                          ),
                          hint: Center(
                            child: Text(
                              "اختيار المحافظة",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          items: cityController.itemsCountriesAll.map((value) {
                            return DropdownMenuItem(
                              value: value.CountriesId.toString(),
                              child: Text(
                                value.CountriesName.toString(),
                              ),
                            );
                          }).toList(),
                          value: cityController.currentSelected2Item.value == ""
                              ? null
                              : cityController.currentSelected2Item.value,
                          onChanged: (value) {
                            cityController.ChooseCountries(value);
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 200,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 300,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditing2Controller,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                expands: true,
                                textAlign: TextAlign.right,
                                maxLines: null,
                                controller: textEditing2Controller,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: "بحث عن المحافظة",
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().contains(searchValue);
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditing2Controller.clear();
                            }
                          },
                        ),
                      ),
                 const SizedBox(height: 50,),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                           enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:   BorderSide(color: Theme.of(context).primaryColor),
                          ), 
                            contentPadding: const EdgeInsets.symmetric(vertical: 5),
                            border: OutlineInputBorder( 
                              borderRadius: BorderRadius.circular(15),
                            ),
                            // Add more decoration..
                          ),
                          hint: Center(
                            child: Text(
                              "اختيار المنطقة",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          items: cityController.itemscityAll.map((value) {
                            return DropdownMenuItem(
                              value: value.CityId.toString(),
                              child: Text(
                                value.CityName.toString(),
                              ),
                            );
                          }).toList(),
                          value: cityController.currentSelectedItem.value == ""
                              ? null
                              : cityController.currentSelectedItem.value,
                          onChanged: (value) {
                            cityController.ChooseCity(value);
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 200,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 300,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 4,
                                right: 8,
                                left: 8,
                              ),
                              child: TextFormField(
                                expands: true,
                                textAlign: TextAlign.right,
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: "بحث عن المنطقة",
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().contains(searchValue);
                            },
                          ),
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    const SizedBox(height: 50,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {
                          cityController.savecity();
                        },
                        child: const Text(
                          "حفظ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "اختيار المنطقة",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
