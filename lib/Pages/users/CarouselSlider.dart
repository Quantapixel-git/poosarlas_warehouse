import 'package:e_commerce_grocery_application/Pages/models/ImageSliderModel.dart';
import 'package:e_commerce_grocery_application/services/ImageSliderServices.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({super.key});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  List<Banners> imgList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImagesSlider(); // Fetch categories on initialization
  }

  Future<void> _fetchImagesSlider() async {
    try {
      var fetchedBanners = await Imagesliderservices().fetchBanners();
      if (fetchedBanners.isNotEmpty) {
        setState(() {
          imgList = fetchedBanners;
          isLoading = false;
        });
      } else {
        setState(() {
          imgList = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        imgList = []; // Ensure imgList is empty on failure
      });
      debugPrint('Error fetching banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (imgList.isEmpty) {
      return const Center(
        child: Text(
          'No images to display',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: imgList.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imgList[index].imageUrl, // Use image URL from the Banners model
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 240.0,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        onPageChanged: (index, reason) {},
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
