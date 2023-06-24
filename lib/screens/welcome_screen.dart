import 'package:flutter/material.dart';
import 'package:phone_otp/provider/auth_provider.dart';
import 'package:phone_otp/screens/home_screen.dart';
import 'package:phone_otp/screens/register_screen.dart';
import 'package:phone_otp/widgets/custom_button.dart';
import 'package:provider/provider.dart';
class WelcomeScreen extends StatefulWidget {
 

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap=Provider.of<AuthProvider>(context,listen:false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25,horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/login.jpg",
                height: 300,
                ),
                SizedBox(height: 10,),
                Text("Let's get started ",
                style:TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ) ,
                ),
                SizedBox(height: 10,),
                Text("Never a better time than now to start.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Get started",  
                    onPressed:() async{
                      if(ap.isSignedIn==true){
                         await ap.getDataFromSP().whenComplete(() => Navigator.pushReplacement(context,  //when true then fetch shared preference data
                     MaterialPageRoute(builder: (context)=>HomeScreen(),),),);
                      }
                      else{
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context)=>RegisterScreen()
                        ));
                      }
                    }),
                )
              ],
            ),
            ),
        )),
    );
  }
}