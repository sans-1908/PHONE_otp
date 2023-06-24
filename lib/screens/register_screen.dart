import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_otp/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController=TextEditingController();
  Country selectedCountry=Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example:"India",
    displayName: "India",
    displayNameNoCountryCode:"IN",
    e164Key: "",
    );

  @override
  Widget build(BuildContext context) {
    phoneController.selection=TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length) //no inverted phone number
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child:Padding(
            padding: EdgeInsets.symmetric(vertical: 25,horizontal: 35),
            child: Column(
              children: [
                Container(
                  width: 250,
                  height: 200,
                  decoration: BoxDecoration(
                    shape:BoxShape.circle ,                  
                    image: DecorationImage(
                      image: AssetImage("assets/login1.jpg"),
                      fit: BoxFit.cover
                      )
                  ),
                   ),
                   SizedBox(height: 20,),
                   Text("Register",
                style:TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ) ,
                ),
                SizedBox(height: 10,),
                Text("Add your phone number. We'll send you a verification code",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                TextFormField(
                  onChanged:(value){
                    setState(() {
                      phoneController.text=value;
                    });
                  } ,
                  controller: phoneController,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey
                      ),
                    hintText: "Enter your phone number",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black12)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black12)
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(8.0),
                      child:InkWell(
                        onTap: (){
                          showCountryPicker(
                          context: context, 
                          countryListTheme: const CountryListThemeData(
                            bottomSheetHeight: 550
                          ),
                          onSelect:(value) {
                            setState(() {
                              selectedCountry=value;
                            });
                          });
                        },
                        child: Text("${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      )
                    ),
                    suffixIcon: phoneController.text.length>9 ? Container(
                      height: 30,width: 30,
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green ),
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        ),
                    ):null,
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Login",
                    onPressed: (){
                      sendPhoneNumber();
                    }),
                )
              ],
            ),
            )
        )),
    );
  }

  void sendPhoneNumber(){
    //+91123456790
    final ap=Provider.of<AuthProvider>(context,listen:false);
    String phoneNumber=phoneController.text.trim(); //trim white spaces
    ap.SignInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}