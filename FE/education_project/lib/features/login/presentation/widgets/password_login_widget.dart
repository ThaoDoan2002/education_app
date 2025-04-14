import 'package:education_project/config/routes/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class TextPass extends StatelessWidget {
  const TextPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.login_password,
          style: const TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            context.push('/forgot_password');
          },
          child: Text(
            AppLocalizations.of(context)!.login_forgot_password,
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        )
      ],
    );
  }
}

class TextFormPass extends StatelessWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final bool isLoading;
  final bool isOsecured;
  final VoidCallback function1;
  final ValueChanged<String> function2;
  final VoidCallback function3;

  const TextFormPass(
      {super.key,
      required this.passwordController,
      required this.passwordFocusNode,
      required this.isLoading,
      required this.isOsecured,
      required this.function1,
      required this.function2,
      required this.function3});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.login_invalid_password;
        }
        return null;
      },
      onChanged: function2,
      obscureText: isOsecured,
      focusNode: passwordFocusNode,
      controller: passwordController,
      decoration: InputDecoration(
        suffixIcon: SizedBox(
          width: passwordController.text.isEmpty ? 10 : 105,
          // Đặt kích thước tùy ý phù hợp với giao diện của bạn
          child: Row(
            children: [
              IconButton(
                onPressed: function1,
                icon: isOsecured
                    ? const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      ),
              ),
              if (passwordController.text.isNotEmpty) ...[
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey,
                ),
                IconButton(
                  onPressed: function3,
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                ),
              ]
            ],
          ),
        ),
        filled: true,
        fillColor: isLoading ? Colors.grey[200] : Colors.white12,
        hintText: AppLocalizations.of(context)!.login_hint_password,
        labelText: AppLocalizations.of(context)!.login_hint_password,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isLoading ? Colors.grey : Colors.blue,
            // Màu viền khi loading
            width: 1.5,
          ),
        ),
        hintStyle: TextStyle(
          color: isLoading ? Colors.grey : Colors.black,
          // Màu chữ khi loading
          fontSize: 17,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(
        fontSize: 18,
        color:
            isLoading ? Colors.grey : Colors.black, // Màu chữ input khi loading
      ),
    );
  }
}
