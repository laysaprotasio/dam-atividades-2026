import 'package:flutter/material.dart';
import 'package:save_pass/ui/colors.dart';
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

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      return 'Informe o nome de usuário';
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
                      return 'Informe o e-mail de recuperação';
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
                      return 'Informe a senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
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
