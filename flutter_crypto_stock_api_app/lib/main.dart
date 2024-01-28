import 'package:flutter/material.dart';
import 'package:flutter_crypto_stock_api_app/models/currency.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stock Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'flutter_crypto_stock_api_app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => apiRealTime()));
                },
                child: Text("Real Time Crypto Data Api")),
          ],
        ),
      ),

    );
  }
}


class apiRealTime extends StatefulWidget {
  const apiRealTime({Key? key}) : super(key: key);

  @override
  State<apiRealTime> createState() => _apiRealTimeState();
}

class _apiRealTimeState extends State<apiRealTime> {

  final StreamController <currency> currencyStreamController = StreamController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(Duration(seconds: 2), (timer) {
      getCurrency();
    });

  }


  Future<void> getCurrency()async {
    final url="https://api.coincap.io/v2/assets/bitcoin";
    var response = await http.get(Uri.parse(url));

    if(response.statusCode==200){
      Map<String,dynamic> map = jsonDecode(response.body);
      print(map['data']);
      currency currencyObject=currency.fromMap(map['data']);

      currencyStreamController.sink.add(currencyObject);
    }
    else{
      print("Failed");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Real Time Api"),
      ),
      body: Center(
          child: Column(
            children: [

              StreamBuilder<currency>(stream: currencyStreamController.stream, builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                if(snapshot.hasError){
                  return Text("Error");
                }else{
                  return coinWidget(snapshot.data!);
                }

              },)
            ],
          )
      ),
    );
  }
}
class coinWidget extends StatelessWidget {
  final currency currencyObject;
  coinWidget(this.currencyObject, {Key? key , }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text("${currencyObject.name} "),
        Image.asset('lib/assets/btc.jpeg'),
        Text("Price: ${currencyObject.price} "),
        Text("Supply: ${currencyObject.supply} "),
      ],
    );
  }
}