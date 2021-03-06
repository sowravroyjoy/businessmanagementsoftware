import 'package:businessmanagementsoftware/models/product.dart';
import 'package:businessmanagementsoftware/widgets/drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = new TextEditingController();
  final quantityEditingController = new TextEditingController();
  final priceEditingController = new TextEditingController();
  final categoryEditingController = new TextEditingController();

  List<String> _categoryList = ["none","new category"];
  String? _chosenCategory;

  List<String> _productList = ["new product"];
  String? _chosenProduct;

  bool? _process;
  int? _count;
  bool _newCategory = false;
  bool _newProduct = false;
  String _selectedDoc = "";
  List<int> _indexList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _process = false;
    _count = 1;

    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
          if (doc["category"] != "none") {
            setState(() {
             _categoryList.add(doc["category"]);
            });
          }
            setState(() {
              _productList.add(doc["name"]);
            });
      }
    }).whenComplete(() {
      for(int i=1; i < _categoryList.length;i++){
          if(_categoryList[i] ==_categoryList[i-1]){
              _indexList.add(i);
        }
      }
      for(int j in _indexList.reversed){
        setState((){
          _categoryList.removeAt(j);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            autofocus: false,
            controller: nameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if(_chosenProduct == "new product" && value!.isEmpty){
                return ("name cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              nameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.brown),
              floatingLabelStyle: TextStyle(color: Colors.brown),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown),
              ),
            )));

    final quantityField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: quantityEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("quantity cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              quantityEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Quantity',
              labelStyle: TextStyle(color: Colors.brown),
              floatingLabelStyle: TextStyle(color: Colors.brown),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown),
              ),
            )));


    final priceField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: priceEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("price cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              priceEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Price',
              labelStyle: TextStyle(color: Colors.brown),
              floatingLabelStyle: TextStyle(color: Colors.brown),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown),
              ),
            )));

    final categoryField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            autofocus: false,
            controller: categoryEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if(_chosenCategory == "new category" && value!.isEmpty){
                return ("category cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              categoryEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Category',
              labelStyle: TextStyle(color: Colors.brown),
              floatingLabelStyle: TextStyle(color: Colors.brown),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown),
              ),
            )));


    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.brown),
        ));

    final categoryDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown),
              ),
            ),
            items: _categoryList.map(buildMenuItem).toList(),
            hint: Text(
              'Select Category',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.brown),
            ),
            value: _chosenCategory,
            onChanged: (newValue) {
              setState(() {
                _chosenCategory = newValue;
                if(newValue == "new category"){
                  _newCategory = true;
                }else{
                  _newCategory = false;
                }
              });
            }));


    DropdownMenuItem<String> buildMenuProduct(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.brown),
        ));

    final productDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.brown),
              ),
            ),
            items: _productList.map(buildMenuProduct).toList(),
            hint: Text(
              'Select Product',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.brown),
            ),
            value: _chosenProduct,
            onChanged: (newValue) {
              setState(() {
                _chosenProduct = newValue;
                if(newValue == "new product"){
                  _newProduct= true;
                  setState(() {
                    quantityEditingController.clear();
                    priceEditingController.clear();
                    _chosenCategory = null;
                    _selectedDoc = "";
                  });
                }else{
                  _newProduct = false;
                  FirebaseFirestore.instance
                      .collection('products')
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      if(doc["name"].toString().toLowerCase() == newValue.toString().toLowerCase()){
                        setState(() {
                          quantityEditingController.text = doc["quantity"];
                          priceEditingController.text = doc["price"];
                          _chosenCategory = doc["category"];
                          _selectedDoc = doc["docID"];
                        });
                      }
                    }
                  });
                }
              });
            }));


    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.brown.shade800 : Colors.brown,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          150,
          35,
          150,
          35,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text("Wait Please!!")))
              : AddData();
        },
        child: (_process!)
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Processing',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Center(
                child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))),
          ],
        )
            : (_selectedDoc !="")?Text(
          'Update Product',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ):Text(
          'Add Product',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (_selectedDoc != "")?Text("Update Product"):Text("Add Product"),
      ),
      drawer: drawerWidget(context),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _newProduct? nameField:Text(""),
                SizedBox(height: 10,),
                productDropdown,
                SizedBox(height: 10,),
                quantityField,
                SizedBox(height: 10,),
              priceField,
                SizedBox(height: 10,),
                categoryDropdown,
                SizedBox(height: 10,),
                _newCategory? categoryField:Text(""),
                SizedBox(height: 10,),
                addButton,
                SizedBox(height: 40,),

              ],
            ),
          ),
        ),
      ),
    );
  }



  void AddData()  async{
    int _productID = 1;
    bool _unique = true;
    if (_formKey.currentState!.validate() &&
        _chosenCategory != null && _chosenProduct != null) {

        FirebaseFirestore.instance
            .collection('products')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if(doc["productID"].toString().toLowerCase() == "${_chosenCategory.toString().toLowerCase()}:1"  ||  doc["productID"].toString().toLowerCase() == "${categoryEditingController.text.toString().toLowerCase()}:1" ){
              if(int.parse(doc["productID"].toString().split(":").last) <= _productID){
                _productID = _productID + 1;
              }
            }
          }

          FirebaseFirestore.instance
              .collection('products')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (doc["name"].toString().toLowerCase() ==
                  nameEditingController.text.toString().toLowerCase()) {
                _unique = false;
              }
            }

            if (_unique) {
              var ref = FirebaseFirestore.instance.collection("products")
                  .doc();

              if(_selectedDoc != ""){
                ref = FirebaseFirestore.instance.collection("products")
                    .doc(_selectedDoc);
              }

              Product product = Product();
              product.timeStamp = FieldValue.serverTimestamp();
              (_chosenCategory != "new category")
                  ? product.productID =
                  _chosenCategory.toString() + ":" + _productID.toString()
                  : product.productID =
                  categoryEditingController.text.toString().toLowerCase() +
                      ":" + _productID.toString();
              (_chosenProduct != "new product") ?
              product.name = _chosenProduct.toString() : product.name =
                  nameEditingController.text;
              product.quantity = quantityEditingController.text;
              product.price = priceEditingController.text;
              (_chosenCategory != "new category") ?
              product.category = _chosenCategory.toString() : product.category =
                  categoryEditingController.text.toString().toLowerCase();
              product.docID = ref.id;
              ref.set(product.toMap()).whenComplete(() {
                (_selectedDoc != "")?ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                        "Product Updated!!"))):ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                        "New Product Added!!")));
                setState(() {
                  _process = false;
                  _count = 1;
                  nameEditingController.clear();
                  quantityEditingController.clear();
                  priceEditingController.clear();
                  categoryEditingController.clear();
                  _chosenCategory = null;
                  _chosenProduct = null;
                });

                FirebaseFirestore.instance
                    .collection('products')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  setState(() {
                    _categoryList.clear();
                    _categoryList.add("none");
                    _categoryList.add("new category");
                    _productList.clear();
                    _productList.add("new product");
                  });
                  for (var doc in querySnapshot.docs) {
                    if (doc["productID"].toString().split(":").last == "1"&& doc["productID"].toString().split(":").first != "none") {
                      setState(() {
                        _categoryList.add(doc["category"]);
                      });
                    }
                    setState(() {
                      _productList.add(doc["name"]);
                    });
                  }
                });
              }).onError((error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Something Wrong!!")));
                setState(() {
                  _process = false;
                  _count = 1;

                });
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                      "Already a product available in this name. Please select that product and update the quantity!!")));
              setState(() {
                _process = false;
                _count = 1;
              });
            }
          });
        });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
