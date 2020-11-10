import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/login_model.dart';
import 'package:weebooks2/_view_models/sign_up_validation_model.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/services/database.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/ui/telas/login/widgets/templateTextField.dart';
import 'package:weebooks2/values/values.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //text field
  TextEditingController _emailController;
  TextEditingController _usuarioController;
  TextEditingController _senhaController;
  TextEditingController _confirmarSenhaController;
  final FocusNode _emailFocus = new FocusNode();
  final FocusNode _usuarioFocus = new FocusNode();
  final FocusNode _senhaFocus = new FocusNode();
  final FocusNode _confirmarSenhaFocus = new FocusNode();

  //text field error
  final DatabaseService _data = DatabaseService();
  String error = '';

  //loading
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _usuarioController = TextEditingController(text: "");
    _senhaController = TextEditingController(text: "");
    _confirmarSenhaController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final suvmodel = Provider.of<SignUpValidationModel>(context);
    final lmodel = Provider.of<LoginViewModel>(context);

    return Stack(
      children: [
        DefaultScaffold(
          backgroundColor: secondaryPink,
          body: Form(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.red,
                          child: Image.asset(
                            "assets/background.webp",
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              Container(
                                width: 100,
                                height: 100,
                                child: FlatButton(
                                  onPressed: () {},
                                  color: shadeGrey1.withOpacity(0.5),
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: error.isNotEmpty
                                    ? EdgeInsets.only(bottom: 10, top: 20)
                                    : EdgeInsets.zero,
                                child: Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              TemplateTextField(
                                id: 2,
                                titulo: "Email",
                                icon: Icons.mail_outline,
                                controller: _emailController,
                                focusNode: [_emailFocus, _usuarioFocus],
                              ),
                              SizedBox(height: 30),
                              TemplateTextField(
                                id: 3,
                                titulo: "Usuário",
                                icon: Icons.person_outline,
                                controller: _usuarioController,
                                focusNode: [_usuarioFocus, _senhaFocus],
                              ),
                              SizedBox(height: 30),
                              TemplateTextField(
                                id: 4,
                                titulo: "Senha",
                                icon: Icons.lock_outline,
                                controller: _senhaController,
                                focusNode: [_senhaFocus, _confirmarSenhaFocus],
                              ),
                              SizedBox(height: 30),
                              TemplateTextField(
                                id: 5,
                                titulo: "Confirmar Senha",
                                icon: Icons.lock_outline,
                                controller: _confirmarSenhaController,
                                focusNode: [_confirmarSenhaFocus, null],
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (suvmodel.isValid) {
                          setState(() => loading = true);

                          if (await _data
                              .validateUsername(_usuarioController.text)) {
                            dynamic resultado = await _auth.cadastroEmailSenha(
                                _emailController.text, _senhaController.text);
                            if (resultado[0] == null) {
                              String aux = await lmodel.traduzir(resultado[1]);
                              setState(() {
                                error = aux;
                                loading = false;
                              });
                            } else if (await _data
                                .createUsername(_usuarioController.text)) {
                              Navigator.of(context).pop();
                              print("Registrado");
                            } else {
                              _auth.deletarUsuario();
                              setState(() {
                                error =
                                    'Ocorreu um erro. Tente novamente mais tarde';
                                loading = false;
                              });
                            }
                          } else {
                            setState(() {
                              error = 'Usuário já existente';
                              loading = false;
                            });
                          }
                        }
                      },
                      child: Text(
                        "Confirmar",
                        style: TextStyle(
                          fontSize: DEFAULT_BUTTON_TEXT_SIZE,
                          color: Colors.white,
                        ),
                      ),
                      color: primaryCyan,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading ? Center(child: Loading()) : Container()
      ],
    );
  }
}
