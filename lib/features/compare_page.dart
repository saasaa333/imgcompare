import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'image_sync.dart';

class ComparePage extends StatefulWidget {
 const ComparePage({super.key});

 @override
 State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
 File? image1;
 File? image2;

 Future<void> pickImage(int index) async {
   final FilePickerResult? result = await FilePicker.platform.pickFiles(
     type: FileType.image,
   );
   if (result != null && result.files.single.path != null) {
     setState(() {
       if (index == 1) {
         image1 = File(result.files.single.path!);
       } else {
         image2 = File(result.files.single.path!);
       }
     });
   }
 }

 @override
 Widget build(BuildContext context) {
   return AnnotatedRegion<SystemUiOverlayStyle>(
     value: const SystemUiOverlayStyle(
       statusBarColor: Colors.black,
       statusBarIconBrightness: Brightness.light,
       statusBarBrightness: Brightness.dark,
     ),
     child: Scaffold(
       backgroundColor: Colors.black,
       body: SafeArea(
         child: Column(
           children: [
             const SizedBox(height: 10),
             if (image1 != null && image2 != null)
               Expanded(
                 child: ImageSyncView(image1: image1!, image2: image2!),
               )
             else
               const Expanded(
                 child: Center(
                   child: Text(
                     'Please pick both images.',
                     style: TextStyle(color: Colors.white),
                   ),
                 ),
               ),
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   ElevatedButton(
                     onPressed: () => pickImage(1),
                     child: const Text('Pick Image 1'),
                   ),
                   ElevatedButton(
                     onPressed: () => pickImage(2),
                     child: const Text('Pick Image 2'),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }
}