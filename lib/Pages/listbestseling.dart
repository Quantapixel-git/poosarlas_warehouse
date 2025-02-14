import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
import 'package:e_commerce_grocery_application/Widgets/BsellingProductWidget.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/material.dart';

class Listbestseling extends StatefulWidget {
  const Listbestseling({super.key});

  @override
  State<Listbestseling> createState() => _GriditemsState();
}

class _GriditemsState extends State<Listbestseling> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBestSelling(); // Fetch data in initState
  }

  void fetchBestSelling() async {
    var res = (await ProductService().getBestSellings(userId));
    if (res['status'] == 1) {
      products = res['data'];
    } else {
      //show error.
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: isLoading
            ? Container()
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final griddata = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detailviewpage(
                                    Name: griddata['product_name'],
                                    Price: griddata['product_price'],
                                    // description:
                                        // griddata['product_description'],
                                    Image: griddata['product_image_url'],
                                    id: griddata['id'].toString(),
                                    CategoryId:
                                        griddata['category_id'].toString(),
                                    discount: griddata['product_discount'],
                                  )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              griddata['product_image_url'],
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              griddata['product_name'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475269)),
                            ),
                          ),
                          Text(
                            ' ₹${(double.parse(griddata['product_discount'])).toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
