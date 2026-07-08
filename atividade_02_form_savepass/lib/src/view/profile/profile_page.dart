import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pass/src/controller/sqlite_password_controller.dart';
import 'package:save_pass/src/model/user_profile_model.dart';
import 'package:save_pass/ui/colors.dart';
import 'package:save_pass/ui/components/app_button.dart';
import 'package:save_pass/ui/components/custom_text_field.dart';
import 'package:save_pass/ui/text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegExp _emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  bool _isObscure = true;
  bool _initialized = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<SQlitePasswordController>().profile;
    if (!_initialized && profile != null) {
      _usernameController.text = profile.username;
      _emailController.text = profile.email;
      _passwordController.text = profile.password;
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Perfil do Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text('Nome de usuário', style: AppTextStyle.bodyText1),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'Insira seu nome de usuário',
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome de usuário é obrigatório';
                    }
                    if (value.length < 3) {
                      return 'O nome de usuário deve ter no mínimo 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('E-mail de recuperação', style: AppTextStyle.bodyText1),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'usuario@email.com',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O e-mail é obrigatório';
                    }
                    if (!_emailRegex.hasMatch(value)) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Text('Senha secreta', style: AppTextStyle.bodyText1),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'Sua senha mestra',
                  obscureText: _isObscure,
                  controller: _passwordController,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.gray200,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A senha é obrigatória';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Salvar Perfil',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final profile = UserProfileModel(
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      context.read<SQlitePasswordController>().saveProfile(
                        profile,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
