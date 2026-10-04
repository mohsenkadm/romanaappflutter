import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Controller/EditProfileController.dart';
import 'package:romanaappflutter/main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late final EditProfileController c;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<EditProfileController>()) {
      Get.delete<EditProfileController>();
    }
    c = Get.put(EditProfileController());
    c.loadFromSession();
  }

  @override
  Widget build(BuildContext context) {
    final fill = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'profile.edit_title'.tr,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor),
        ),
      ),
      body: Obx(
        () => c.isSaving.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _field(
                        fill: fill,
                        controller: c.nameController,
                        hint: 'profile.name_hint'.tr,
                        validator: c.validateName,
                        textInputAction: TextInputAction.next,
                      ),
                      _field(
                        fill: fill,
                        controller: c.phoneController,
                        hint: 'profile.phone_hint'.tr,
                        validator: c.validatePhone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                      ),
                      _field(
                        fill: fill,
                        controller: c.addressController,
                        hint: 'profile.address_hint'.tr,
                        textInputAction: TextInputAction.next,
                      ),
                      _field(
                        fill: fill,
                        controller: c.functionPointController,
                        hint: 'profile.function_point_hint'.tr,
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                c.save();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myTheme.primaryColor,
                            ),
                            child: Text(
                              'common.save'.tr,
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _field({
    required Color fill,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          hintText: hint,
          contentPadding: const EdgeInsets.all(15),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
