import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class RichTextEditor extends StatefulWidget {
  final quill.QuillController controller;
  final String label;

  const RichTextEditor({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {


bool isExpanded=false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      isExpanded=!isExpanded;
                    });
                  },
                  
                  child: Icon(
                    isExpanded?
                    
                    
                    Icons.keyboard_arrow_up:
                    
                    Icons.
                    keyboard_arrow_down_outlined
                    ,size:30
                    
                    
                    ,color: Colors.black,))
              ],
            ),
          ),
          // Quill Toolbar
    isExpanded?      quill.QuillToolbar.simple(controller: widget.controller):SizedBox(),
          // Quill Editor
          Container(
            height: 200,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: quill.QuillEditor(
              
              controller: widget.controller,
             
              focusNode: FocusNode(),
              scrollController: ScrollController(),
            
            ),
          ),
        ],
      ),
    );
  }
}
