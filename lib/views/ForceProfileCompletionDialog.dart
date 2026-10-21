import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Controller/EditProfileController.dart';

class ForceProfileCompletion {
  ForceProfileCompletion._();

  static bool _showing = false;

  static Future<void> ensureShown() async {
    if (_showing) return;
    final box = GetStorage();
    if (!SessionStorage.needsCompletion(box)) return;
    final overlay = Get.overlayContext;
    if (overlay == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ensureShown();
      });
      return;
    }
    _showing = true;
    try {
      await Get.dialog(
        const ForceProfileCompletionDialog(),
        barrierDismissible: false,
        useSafeArea: true,
      );
    } finally {
      _showing = false;
    }
  }

  static void closeIfComplete() {
    final box = GetStorage();
    if (!SessionStorage.needsCompletion(box) &&
        _showing &&
        (Get.isDialogOpen ?? false)) {
      Get.back();
    }
  }
}

class ForceProfileCompletionDialog extends StatefulWidget {
  const ForceProfileCompletionDialog({Key? key}) : super(key: key);

  @override
  State<ForceProfileCompletionDialog> createState() =>
      _ForceProfileCompletionDialogState();
}

class _ForceProfileCompletionDialogState
    extends State<ForceProfileCompletionDialog> {
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

  Future<void> _save() async {
    if (_formKey.currentState?.validate() != true) return;
    await c.save(popOnSuccess: false, requireComplete: true);
    if (!SessionStorage.needsCompletion(GetStorage())) {
      if (mounted) Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'profile.complete_title'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'profile.complete_body'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _field(
                              controller: c.nameController,
                              hint: 'profile.name_hint'.tr,
                              validator: c.validateName,
                            ),
                            _field(
                              controller: c.phoneController,
                              hint: 'profile.phone_hint'.tr,
                              validator: c.validatePhone,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                            ),
                            _field(
                              controller: c.addressController,
                              hint: 'profile.address_required_hint'.tr,
                              validator: c.validateAddress,
                            ),
                            _field(
                              controller: c.functionPointController,
                              hint: 'profile.function_point_required_hint'.tr,
                              validator: c.validateFunctionPoint,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: c.isSaving.value ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: c.isSaving.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'common.save'.tr,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
