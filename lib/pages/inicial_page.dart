import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InicialPage extends StatelessWidget {
  const InicialPage({super.key});
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
         body: SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(181, 5, 21, 94), Color.fromARGB(214, 235, 235, 235)], 
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:const Color.fromARGB(255, 8, 29, 121),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                       _opcoesEntrada(context);
                    },  child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ), 
                ),               
                 Container(
                  margin: const EdgeInsets.only(bottom: 70),
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      _opcoesCadastro(context);
                    },  child: const Text(
                      'Cadastrar-se',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                      ),
                    ),
                  ), 
                ),                
              ],
            ),
          ),           
        ),
    );
  }
}

 void _opcoesEntrada(context){
  showModalBottomSheet(context: context, builder: (BuildContext bc){
    return Wrap(children: <Widget>[
              ListTile(
    leading:  const Icon(Icons.mail_outline),
    title:  const Text('Entre com telefone'),  iconColor: Colors.blueGrey,
    onTap: () => {Navigator.pop(context),
      GoRouter.of(context).go('/legal_entities_login')},          
              ),
    	        ListTile(
    	          leading:  const Icon(Icons.g_mobiledata_outlined),
    	          title:  const Text('Entre com Google'),  iconColor: Colors.red,
    	          onTap: () => {}, 
    	        ),
              ListTile(
    	          leading:  const Icon(Icons.facebook),
    	          title:  const Text('Entre com Facebook'),  iconColor: const Color.fromARGB(255, 37, 0, 201),
    	          onTap: () => {}, 
    	        ),
             ],
            );   
    }
  );
} 

void _opcoesCadastro(context){
  showModalBottomSheet(context: context, builder: (BuildContext bc){
    return Wrap(children: <Widget>[
              ListTile(
    leading:  const Icon(Icons.phone_in_talk_outlined),
    title:  const Text('Cadastrar-se com telefone'),  iconColor: Colors.blueGrey,
    onTap: () => { Navigator.pop(context),
      GoRouter.of(context).go('/email_register')},          
              ),
    	        ListTile(
    	          leading:  const Icon(Icons.g_mobiledata_outlined),
    	          title:  const Text('Continuar com Google'),  iconColor: Colors.red,
    	          onTap: () => {}, 
    	        ),
              ListTile(
    	          leading:  const Icon(Icons.facebook),
    	          title:  const Text('Continuar com Facebook'),  iconColor: const Color.fromARGB(255, 37, 0, 201),
    	          onTap: () => {}, 
    	        ),
             ],
            );   
    }
  );
}