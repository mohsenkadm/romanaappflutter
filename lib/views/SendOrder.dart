import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/SendOrderController.dart';
import 'package:romanaappflutter/main.dart';

// ignore: camel_case_types
class SendOrder extends StatefulWidget {
  const SendOrder({Key? key}) : super(key: key);
  @override
  State<SendOrder> createState() => _SendOrder();
}

// ignore: camel_case_types
class _SendOrder extends State<SendOrder> {
  final SendOrderController _controller = Get.put(SendOrderController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: ListItemCard.itemscard.isEmpty
                ? Center(
                    child: Container(
                      height: 250,
                      width: 300,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(
                            Icons.production_quantity_limits,
                            size: 100,
                            color: myTheme.primaryColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'لا توجد منتجات في السلة',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  )
                : GetBuilder<SendOrderController>(
                    init: SendOrderController(),
                    builder: (controller) => Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ListItemCard.itemscard.length,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                padding: const EdgeInsets.all(0),
                                child: ListTile(
                                  title: Text(
                                    ListItemCard.itemscard[index].productsName,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: Text(
                                    ' د.ع ' +
                                        ListItemCard.itemscard[index].total
                                            .toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                  trailing: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: myTheme.secondaryHeaderColor),
                                    child: Center(
                                      child: Text(
                                        ListItemCard.itemscard[index].count
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'ادخال المعلومات',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'اكتب اسمك الكامل';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: 'اسمك الكامل',
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'اكتب رقم الهاتف';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: 'رقم الهاتف',
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'اكتب عنوانك الكامل';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: 'عنوانك',
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'اكتب اقرب نقطة دالة';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: 'اقرب نقطة دالة',
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: const TextField( 
                                      decoration:  InputDecoration(
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: 'ملاحظات',
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextField(
                                    decoration: InputDecoration(
                                    hintTextDirection: TextDirection.rtl,
                                    hintText: 'اكتب كود الخصم',
                                    prefixIcon: InkWell(
                                      onTap: () => _controller.getpromocode(),
                                      child: Icon(
                                        Icons.send,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(15),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  )),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5),
                                    child: Text(
                                      'التكلفة',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        trailing: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Icon(Icons.attach_money,
                                                size: 30,
                                                color: myTheme.primaryColor)),
                                        title: Text(
                                          'مجموع الطلب',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        leading: Text(
                                          ' د.ع ' +
                                              _controller.totalprice.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        trailing: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Icon(Icons.attach_money,
                                                size: 30,
                                                color: myTheme.primaryColor)),
                                        title: Text(
                                          'الخصم',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        leading: Text(
                                          ' د.ع ' +
                                              _controller.discount.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        trailing: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Icon(Icons.currency_exchange,
                                                size: 30,
                                                color: myTheme.primaryColor)),
                                        title: Text(
                                          'المبلغ الكلي',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        leading: Text(
                                          ' د.ع ' +
                                              _controller.netAmount.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                          onPressed: () => {
                                                // Validate returns true if the form is valid, or false otherwise.
                                                if (_formKey.currentState!
                                                    .validate())
                                                  {}
                                              },
                                          icon: const Icon(
                                              Icons.shopping_cart_checkout),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  myTheme.primaryColor),
                                          label: const Text(
                                            'ارسال الطلب',
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      const SizedBox(
                                        height: 30,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
          ),
        ),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text(
          "انهاء الطلب",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
