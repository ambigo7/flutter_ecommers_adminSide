import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop_admin/service/category.dart';
import 'package:lets_shop_admin/service/brand.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory = 'test';
  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color redAccent = Colors.deepOrangeAccent[700];

  @override
  void initState() {
    _getCategories();
    /*_getBrands();*/
    /*categoriesDropDown = */getCategoriesDropDown();
    print(categoriesDropDown.length);
    /*_currentCategory = categoriesDropDown[0].value;*/
  }

  /*List<DropdownMenuItem<String>> */getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for(int i = 0; i < categories.length; i++){
      setState(() {
        categoriesDropDown.insert(0, DropdownMenuItem(child: Text(categories[i]['category']),
          value: categories[i]['category'],
        ));
      });
    }
/*    for (DocumentSnapshot category in categories) {
      items.add(new DropdownMenuItem(
          child: Text(category['category']), value: category['category']));
    }*/
    print(items.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.1,
        title: Text(
          'Add product',
          style: TextStyle(color: redAccent),
        ),
        //background nya masih white
        leading: Icon(
          Icons.close,
          color: black,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                      onPressed: () {},
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 40.0),
                        child: new Icon(Icons.add, color: grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                      onPressed: () {},
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 40.0),
                        child: new Icon(Icons.add, color: grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide:
                          BorderSide(color: grey.withOpacity(0.3), width: 2.5),
                      onPressed: () {},
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 40.0),
                        child: new Icon(Icons.add, color: grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Enter a product name with 10 characters at maximum',
              textAlign: TextAlign.center,
              style: TextStyle(color: redAccent, fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: 'Product Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the product name';
                  } else if (value.length > 10) {
                    return 'Product name cant have more then 10 letters';
                  }
                  return null;
                },
              ),
            ),

              Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                      itemBuilder: (context, index){
                      return ListTile(
                        title: Text(categories[index]['category']),
                      );
                      }))
/*            Center(
              child: DropdownButton(
                value: _currentCategory,
                items: categoriesDropDown,
                onChanged: changeSelectedCategory,
              ),
            )*/
          ],
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      print(categories.length);
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }
}
