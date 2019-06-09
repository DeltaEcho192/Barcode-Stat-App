import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWords(),   
    );
  }
}
/*

const MyHomePage(title: "FireStore Test")


class MockBandInfo {
  const MockBandInfo({this.name,this.votes});

  final String name;
  final int votes;
}

class MyHomePage extends StatelessWidget{
    const MyHomePage({Key key, this.title}) : super(key: key);

    static const List<MockBandInfo> _bandList = [
      const MockBandInfo(name: "Name 1", votes: 1),
      const MockBandInfo(name: "Name 2", votes: 1),
      const MockBandInfo(name: "Name 3", votes: 1),
      const MockBandInfo(name: "Name 4", votes: 1),
    ];
    final String title;

    Widget _buildListItem(BuildContext context,DocumentSnapshot document)
    {
      return ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                document['name'],
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xffddddff),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Text(
                document['barcode'].toString(),
                style: Theme.of(context).textTheme.display1,
              ),
            )
          ],
        ),
        onTap: (){
          print("Should increase votes here.");
          Firestore.instance.runTransaction((transaction) async{
            DocumentSnapshot freshSnap = await transaction.get(document.reference);
            await transaction.update(freshSnap.reference, {
              'barcode' : freshSnap['barcode'] + 1,
            });
          });
        },
      );
    }
    @override
    Widget build(BuildContext context)
    {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: StreamBuilder(stream: Firestore.instance.collection('barcodes').snapshots(),
        builder: (context, snapshot)
        {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index) => _buildListItem(context, snapshot.data.documents[index]),
          );
        }
        )
        
      );
    }
}
*/
class RandomWordsState extends State<RandomWords>
{
  String inputstr = '';
  String inputstr1 = '';
  String inputstr2 = '';
  final barocdeCont = TextEditingController();
  final nameCont = TextEditingController();
  final categoryCont = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    barocdeCont.dispose();
    nameCont.dispose();
    categoryCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Testing Input"),
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller: barocdeCont,
            ),
            new TextField(
              controller: nameCont,
            ),
            new TextField(
              controller: categoryCont,
            ),
            new FlatButton(
              onPressed: (){
                var rng = new Random();

                var fileName = rng.nextInt(100000).toString();
                Map<String, dynamic> newData = new Map<String, dynamic>();
                newData['barcode'] = int.parse(barocdeCont.text);
                print(newData['barcode']);
                newData['name'] = nameCont.text;
                newData['category'] = categoryCont.text;
                  DocumentReference currentBarcodes =
                    Firestore.instance.collection("barcodes").document(fileName);
                  
                  Firestore.instance.runTransaction((transaction) async{
                    DocumentSnapshot freshSnap = await transaction.get(currentBarcodes);
                    print(freshSnap.exists);
                    await transaction.set(currentBarcodes,newData);
                  });
              },
              child: Text(
                "Enter Data",
              ),
            )
          ],
        ),
      ),
    );
  }

}


class RandomWords extends StatefulWidget
{
  @override
  RandomWordsState createState() => RandomWordsState();
}
