import 'package:businessmanagementsoftware/models/api_sale.dart';
import 'package:businessmanagementsoftware/models/product.dart';
import 'package:businessmanagementsoftware/models/sale.dart';
import 'package:businessmanagementsoftware/widgets/drawer_widget.dart';
import 'package:businessmanagementsoftware/widgets/pdf_sales.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSale extends StatefulWidget {
  const AddSale({Key? key}) : super(key: key);

  @override
  State<AddSale> createState() => _AddSaleState();
}

class _AddSaleState extends State<AddSale> {
  final _formKey = GlobalKey<FormState>();
  final quantityEditingController = new TextEditingController();
  final buyerNameEditingController = new TextEditingController();
  final buyerContactEditingController = new TextEditingController();
  final _formKey2 = GlobalKey<FormState>();

  List<String> _productList = [];
  String? _chosenProduct;

  bool? _process;
  int? _count;
  List<Product> _storeDocs = [];
  int _totalAmount = 0;

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
        setState(() {
          _productList.add(doc["name"]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buyerNameField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            autofocus: false,
            controller: buyerNameEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("name cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              buyerNameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Buyer Name',
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
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
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


    final buyerContactField = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
        child: TextFormField(
            cursorColor: Colors.brown,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            autofocus: false,
            controller: buyerContactEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("price cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              buyerContactEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Buyer Contact',
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

    DropdownMenuItem<String> buildMenuProduct(String item) =>
        DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.brown),
            ));

    final productDropdown = Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 4,
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
              });
            }));


    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.brown.shade800 : Colors.brown,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          100,
          20,
          100,
          20,
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
              'Wait',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
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
            : Text(
          '  Generate PDF  ',
          textAlign: TextAlign.center,
          style:
          TextStyle(color: Colors.white),
        ),
      ),
    );

    final _productTable = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))
      ),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        color: Colors.brown.shade300,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.brown.shade300,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.brown.shade300,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Price',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.brown.shade300,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
              ),


              for(var i = 0; i < _storeDocs.length; i++)...[
                TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _storeDocs[i].name.toString(),
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.brown
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _storeDocs[i].quantity.toString(),
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.brown
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _storeDocs[i].price.toString(),
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.brown
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                                "Do you want to delete it?"),
                                            actions: [
                                              IconButton(
                                                  icon: new Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              IconButton(
                                                  icon: new Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState((){
                                                      for(Product j in _storeDocs){
                                                        if(j.docID ==  _storeDocs[i].docID){
                                                          _storeDocs.remove(j);
                                                          Navigator.of(context).pop();
                                                        }
                                                      }
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          backgroundColor: Colors.green,
                                                          content: Text(
                                                              "Product removed from cart!!")));
                                                    });
                                                  })
                                            ],
                                          )
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                )
              ]
            ],
          )
      ),
    );

    final cartButton = Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(10)
        ),
        child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FirebaseFirestore.instance
                    .collection('products')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if (doc["name"].toString().toLowerCase() ==
                        _chosenProduct.toString().toLowerCase()) {
                      setState(() {
                        if (int.parse(doc["quantity"]) <
                            int.parse(quantityEditingController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  "Product in that quantity is not available!!")));
                        } else {
                          setState(() {
                            Product product = Product();
                            product.name = doc["name"];
                            product.quantity = quantityEditingController.text;
                            product.price =
                                (int.parse(quantityEditingController.text) *
                                    int.parse(doc["price"])).toString();
                            product.docID = doc["docID"];
                            _storeDocs.add(product);
                            _totalAmount = _totalAmount +
                                (int.parse(quantityEditingController.text) *
                                    int.parse(doc["price"]));
                          });
                        }
                      });
                    }
                  }
                });
              }
            },
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.white
              ),
            )
        )
    );

    final _buyButton = Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(10)
        ),
        child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                      backgroundColor: Colors.brown.shade100,
                      title: Center(child: Text("Buyer Information")),
                      titleTextStyle: TextStyle(fontSize: 20),
                      scrollable: true,
                      content: SingleChildScrollView(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Form(
                              key: _formKey2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  buyerNameField,
                                  SizedBox(height: 10,),
                                  buyerContactField,
                                  SizedBox(height: 20,),
                                  addButton,
                                  SizedBox(height: 40,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              );
            },
            child: Text(
              "Generate PDF",
              style: TextStyle(
                  color: Colors.white
              ),
            )
        )
    );


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sale Product"),
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
                SizedBox(height: 50,),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown
                  ),
                  child: Text(
                    "Total Amount : $_totalAmount TK",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                productDropdown,
                SizedBox(height: 10,),
                quantityField,
                SizedBox(height: 30,),
                cartButton,
                SizedBox(height: 10,),
                _buyButton,
                SizedBox(height: 30,),
                _productTable,
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void AddData() async {
    if (_formKey2.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('products')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          for (Product i in _storeDocs) {
            if (doc["docID"].toString().toLowerCase() ==
                i.docID.toString().toLowerCase()) {
              var ref = FirebaseFirestore.instance.collection("sales")
                  .doc();
              Sale sale = Sale();
              sale.timeStamp = FieldValue.serverTimestamp();
              sale.productID = doc["productID"] + "-" + "sale";
              sale.name = i.name;
              sale.quantity = i.quantity;
              sale.price = i.price;
              sale.category = doc["category"];
              sale.buyerName = buyerNameEditingController.text;
              sale.buyerContact = buyerContactEditingController.text;
              sale.docID = ref.id;
              ref.set(sale.toMap()).onError((error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                        "Something is wrong!!")));
                setState(() {
                  _process = false;
                  _count = 1;
                });
              });
            }
          }
        }
        Navigator.of(context).pop();
      }).whenComplete(() {
        final _list = <ProductItem>[];
        for (Product i in _storeDocs) {
          _list.add(ProductItem(
            i.name.toString(),
            i.quantity.toString(),
            i.price.toString(),
          ));
        }

        final invoice = ApiSale(
            buyerNameEditingController.text,
            buyerContactEditingController.text,
            _totalAmount.toString(),
            _list);
        final pdfFile = PdfSales.generate(invoice);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green, content: Text("Pdf Generated!!")));
        setState(() {
          _process = false;
          _count = 1;
          _storeDocs.clear();
          _chosenProduct = null;
          quantityEditingController.clear();
          buyerContactEditingController.clear();
          buyerNameEditingController.clear();
          _totalAmount = 0;
        });
      });
    }
  }
}
