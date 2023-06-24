import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phone_otp/provider/auth_provider.dart';
import 'package:phone_otp/utils/utils.dart';
import 'package:phone_otp/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import 'home_screen.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final bioController=TextEditingController();
  
  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }
   //selecting image
   void selectImage() async{
    image=await pickImage(context);
    setState(() {   
    });
   }


  Widget build(BuildContext context) {
    final isLoading=Provider.of<AuthProvider>(context,listen:true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading ==true? Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            )) 
          :        
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 25,horizontal: 5),
          child:Column(
              children: [
                InkWell(
                  onTap: ()=>selectImage(),
                  child: image==null ? CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                      ),                   
                  )
                  :CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 50,
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      //name field
                       textField(
                        hintText: " Your name",
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                        ),
                        //email
                        textField(
                        hintText: "abc@example.com",
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                        ),
                        //bio
                          textField(
                        hintText: "Enter your bio here",
                        icon: Icons.edit,
                        inputType: TextInputType.name,
                        maxLines: 2,
                        controller: bioController,
                        ),
                    ],
                  ),

                ) ,
                SizedBox(height:20 ,),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.90,
                  child: CustomButton(
                    text: "Continue",
                    onPressed:(){
                       storeData();
                    }),
                )
              ],
            ) ),
          )
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
    }
    ){
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple
            ),
            child: Icon(icon,size: 20,color: Colors.white,),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.blue.shade50,
          filled: true
        ),
      ),
      );  
  }
  //store user data to database
  void storeData() async{
    // ignore: unused_local_variable
    final ap=Provider.of<AuthProvider>(context,listen:false);
    // ignore: unused_local_variable
    UserModel userModel=UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bio: bioController.text.trim()  ,
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid:""
      );
      if(image!=null){
       ap.saveUserdataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: (){
          //once data is saved , we need to store it locally also 
          ap.saveUserDataToSP().then((value) => ap.setSignIn().then((value) =>
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(
              builder:(context) => HomeScreen(),
              ),
          (route)=>false),
          ),
          );
        },
        ); 
      }
      else{
     showSnackBar(context, "Please upload your photo");
      }
  }
}