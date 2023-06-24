import 'package:flutter/material.dart';
import 'package:phone_otp/provider/auth_provider.dart';
import 'package:phone_otp/screens/home_screen.dart';
import 'package:phone_otp/screens/user_info_screen.dart';
import 'package:phone_otp/utils/utils.dart';
import 'package:phone_otp/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key,required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  Widget build(BuildContext context) {
    final isLoading=Provider.of<AuthProvider>(context,listen:true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading ==true ? Center(
          child:CircularProgressIndicator(
            color: Colors.purple,
          )
          )
          :Center(
          child:Padding(
            padding: EdgeInsets.symmetric(vertical: 25,horizontal: 30),
            child: Column(
              children: [
                Align(alignment: Alignment.topLeft,
                child: GestureDetector
                (
                  onTap: ()=>Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back),
                ),),
                Container(
                  width: 250,
                  height: 200,
                  decoration: BoxDecoration(
                    shape:BoxShape.circle ,                  
                    image: DecorationImage(
                      image: AssetImage("assets/login2.jpg"),
                      fit: BoxFit.cover
                      )
                  ),
                   ),
                   SizedBox(height: 20,),
                   Text("Verification",
                style:TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ) ,
                ),
                SizedBox(height: 10,),
                Text("Enter the OTP send to your phone number",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Pinput(
                  length:6,
                  showCursor:true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue.shade300
                      )
                    ),
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    )
                     ),
                     onCompleted: (value){
                       setState(() {
                         otpCode=value;
                       });
                        print(otpCode);
                     }
                ),
                SizedBox(height: 25,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height:50,
                  child: CustomButton(
                    text: "Verify",
                   onPressed: (){
                   if(otpCode!=null){
                    verifyOtp(context, otpCode!);
                   }
                   else{
                     showSnackBar(context, "Enter 6-Digit code");
                   }
                   }),
                  ),
                  SizedBox(height: 20,),
                  Text("Didn't receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38
                )
                  ),
                  SizedBox(height: 15,),
                  Text("Resend new code",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                  ),
                  )
              ]
            ),
          ),
        ),
      ),
    );
  
  }

  void verifyOtp(BuildContext context,String userOtp){
    final ap=Provider.of<AuthProvider>(context,listen:false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: (){
        //checking whether user exists
        ap.checkExistingUser().then((value) async{
          if(value==true){
            //user exists in our app 
            ap.getDataFromFirestore().then((value) => ap.saveUserDataToSP().then((value) => ap.setSignIn().then((value){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),
              (route)=>false);
            })));
          }
          else{
            //new user
            Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(
              builder: (context) => UserInformationScreen()),
              (route) => false);
          }
        });
      });
  }
}