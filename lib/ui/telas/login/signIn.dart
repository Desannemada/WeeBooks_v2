import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weebooks2/_view_models/login_model.dart';
import 'package:weebooks2/_view_models/sign_in_validation_model.dart';
import 'package:weebooks2/services/auth.dart';
import 'package:weebooks2/ui/shared/loading.dart';
import 'package:weebooks2/ui/shared/defaultScaffold.dart';
import 'package:weebooks2/ui/telas/login/validacao_reset/senhaReset.dart';
import 'package:weebooks2/ui/telas/login/widgets/templateTextField.dart';
import 'package:weebooks2/values/values.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //text field
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _senhaController = TextEditingController(text: "");
  final FocusNode _emailFocus = new FocusNode();
  final FocusNode _senhaFocus = new FocusNode();

  //text field error
  String error = '';

  //loading
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _senhaController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sivmodel = Provider.of<SignInValidationModel>(context);
    final lmodel = Provider.of<LoginViewModel>(context);

    return Stack(
      children: [
        DefaultScaffold(
          backgroundColor: secondaryPink,
          body: Form(
            key: _formKey,
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
                              SizedBox(height: 10),
                              error.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Text(
                                        error,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              TemplateTextField(
                                id: 0,
                                titulo: "Email",
                                icon: Icons.person_outline,
                                controller: _emailController,
                                focusNode: [_emailFocus, _senhaFocus],
                              ),
                              SizedBox(height: 30),
                              TemplateTextField(
                                id: 1,
                                titulo: "Senha",
                                icon: Icons.lock_outline,
                                controller: _senhaController,
                                focusNode: [_senhaFocus, null],
                              ),
                              SizedBox(height: 10),
                              Align(
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SenhaReset(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Esqueci minha senha",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 55,
                    child: FlatButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (sivmodel.isValid) {
                          setState(() => loading = true);
                          dynamic resultado = await _auth.loginEmailSenha(
                            _emailController.text,
                            _senhaController.text,
                          );
                          if (resultado[0] == null) {
                            String aux = await lmodel.traduzir(resultado[1]);
                            setState(() {
                              error = aux;
                              loading = false;
                            });
                          } else {
                            Navigator.pop(context);
                            print("Logado");
                          }
                        }
                      },
                      child: Text(
                        "Entrar",
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
