import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MoneyBox.dart';
import 'ExchangeRate.dart';

void main() {
  var app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(primaryColor: Colors.lightBlue[300]),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ExchangeRate _exchangeRate;

  @override
  void initState() {
    super.initState();
    getExchangeRates();
  }

  Future<ExchangeRate> getExchangeRates() async {
    const ACCESS_KEY = "872a123266aed05e52b75978e60e68c9";
    const SYMBOLS = "USD,THB,JPY,KRW";
    var url = Uri.parse(
        "http://api.exchangeratesapi.io/v1/latest?access_key=$ACCESS_KEY&symbols=$SYMBOLS&format=1");
    var response = await http.get(url);
    _exchangeRate = exchangeRateFromJson(response.body); // json => dart
    return _exchangeRate;
  }

  @override
  Widget build(BuildContext context) {
    print("Call build()");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Exchange Rates",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
          future: getExchangeRates(), // where you request data
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var result = snapshot.data;
              double amount = 100;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    MoneyBox("Base Currency (EUR)", amount, Colors.pink[200]),
                    MoneyBox("THB (฿)", amount * result.rates["THB"],
                        Colors.lightBlue[300]),
                    MoneyBox("USD (\$)", amount * result.rates["USD"],
                        Colors.red[300]),
                    MoneyBox("JPY (¥)", amount * result.rates["JPY"],
                        Colors.green[300]),
                    MoneyBox("KRW (₩)", amount * result.rates["KRW"],
                        Colors.yellow[700])
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
