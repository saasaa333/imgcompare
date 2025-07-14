import 'dart:io';
import 'package:flutter/material.dart';

class ImageSyncView extends StatefulWidget {
 final File image1;
 final File image2;

 const ImageSyncView({super.key, required this.image1, required this.image2});

 @override
 State<ImageSyncView> createState() => _ImageSyncViewState();
}

class _ImageSyncViewState extends State<ImageSyncView> {
 final TransformationController _controller1 = TransformationController();
 final TransformationController _controller2 = TransformationController();

 bool _syncEnabled = true;
 double _zoomLevel = 1.0;
 bool _isVertical = true; // Added to track layout direction

 @override
 void initState() {
   super.initState();
   _controller1.addListener(_syncTransforms);
 }

 void _syncTransforms() {
   if (_syncEnabled) {
     _controller2.value = _controller1.value;
   }
   _updateZoomLevel();
 }

 void _updateZoomLevel() {
   final matrix = _controller1.value;
   final scaleX = matrix.storage[0];
   final scaleY = matrix.storage[5];
   setState(() {
     _zoomLevel = ((scaleX + scaleY) / 2).clamp(0.5, 10.0);
   });
 }

 void _resetZoom() {
   setState(() {
     _controller1.value = Matrix4.identity();
     _controller2.value = Matrix4.identity();
     _zoomLevel = 1.0;
   });
 }

 @override
 void dispose() {
   _controller1.removeListener(_syncTransforms);
   _controller1.dispose();
   _controller2.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Column(
     children: [
       // Top Control Bar
       Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text("Zoom: ${_zoomLevel.toStringAsFixed(2)}x"),
             Row(
               children: [
                 IconButton(
                   icon: const Icon(Icons.sync),
                   tooltip: 'Toggle Sync',
                   onPressed: () {
                     setState(() {
                       _syncEnabled = !_syncEnabled;
                     });
                   },
                   color: _syncEnabled ? Colors.red : Colors.grey,
                 ),
                 IconButton(
                   icon: const Icon(Icons.refresh),
                   tooltip: 'Reset Zoom',
                   onPressed: _resetZoom,
                 ),
                 IconButton(
                   icon: Icon(
                     _isVertical ? Icons.swap_horiz : Icons.swap_vert,
                   ),
                   tooltip: 'Flip Layout',
                   onPressed: () {
                     setState(() {
                       _isVertical = !_isVertical;
                     });
                   },
                 ),
               ],
             ),
           ],
         ),
       ),

       // Image Viewer Area
       Expanded(
         child: Flex(
           direction: _isVertical ? Axis.vertical : Axis.horizontal,
           children: [
             Expanded(
               child: InteractiveViewer(
                 transformationController: _controller2,
                 panEnabled: !_syncEnabled,
                 scaleEnabled: !_syncEnabled,
                 minScale: 0.5,
                 maxScale: 10.0,
                 child: Image.file(
                   widget.image1,
                   fit: BoxFit.contain,
                   width: double.infinity,
                   height: double.infinity,
                 ),
               ),
             ),
             Expanded(
               child: InteractiveViewer(
                 transformationController: _controller1,
                 panEnabled: true,
                 scaleEnabled: true,
                 minScale: 0.5,
                 maxScale: 10.0,
                 child: Image.file(
                   widget.image2,
                   fit: BoxFit.contain,
                   width: double.infinity,
                   height: double.infinity,
                 ),
               ),
             ),
           ],
         ),
       ),
     ],
   );
 }
}