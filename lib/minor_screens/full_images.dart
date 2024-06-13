import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class FullImagesScreen extends StatefulWidget {
  const FullImagesScreen({super.key, required this.imagesList});
  final dynamic imagesList;

  @override
  State<FullImagesScreen> createState() => _FullImagesScreenState();
}

class _FullImagesScreenState extends State<FullImagesScreen> {
  final PageController controller = PageController();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: AppbarBackButton(),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                "${index + 1}/${widget.imagesList.length}",
                style: TextStyle(fontSize: 24, letterSpacing: 8),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: PageView(
                controller: controller,
                onPageChanged: (value) {
                  setState(() {
                    index = value;
                  });
                },
                children: imagePreview(),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * .2,
                child: imageView())
          ],
        ),
      ),
    );
  }

  List<Widget> imagePreview() {
    return List.generate(widget.imagesList.length, (index) {
      return InteractiveViewer(
        transformationController: TransformationController(),
        child: Image.network(
          widget.imagesList[index].toString(),
        ),
      );
    });
  }

  ListView imageView() {
    return ListView.builder(
        itemCount: widget.imagesList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.jumpToPage(index);
            },
            child: Container(
              width: 120,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.amber,
                    width: 2,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imagesList[index].toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }
}
