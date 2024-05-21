import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '设备查看器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel = IOWebSocketChannel.connect('ws://127.0.0.1:8910');
  List<Map<String, String>> dataList = [];
  List<Map<String, String>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  int cnt=0;
  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      setState(() {
        dataList.clear();
        var jsonData = jsonDecode(message);
        List<dynamic> jsonArray = jsonData;
        for (var item in jsonArray) {
          Map<String,String>data={};
          if (item is Map<String, dynamic>) {
            item.forEach((key, value) {
              data[key] = value.toString();
            });
          }
          dataList.add(data);
        }
        filterData(searchController.text);
      });
    });
  }

  void filterData(String keyword) {
    print("过滤$cnt");
    cnt=cnt+1;
    setState(() {
      if (keyword.isEmpty) {
        filteredList = List.from(dataList);
      } else {
        filteredList = dataList
            .where((data) =>
            data.values.any((value) => value.toLowerCase().contains(keyword.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设备查看'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterData,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter search keyword...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            height: 40,
            child:Row(
              children: [
                SizedBox(width: 20,),
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Icon(Icons.devices),
                      SizedBox(width: 8),
                      Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Icon(Icons.business),
                      SizedBox(width: 8),
                      Text("Manufacturer", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  child: Row(
                    children: [
                      Icon(Icons.description),
                      SizedBox(width: 8),
                      Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  child: Row(
                    children: [
                      Icon(Icons.abc),
                      SizedBox(width: 8),
                      Text("PNPDeviceID", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: filteredList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(), // 分割线
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['Name'] ?? ''),
                      ),
                      Container(
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['Manufacturer'] ?? ''),
                      ),
                      Container(
                        width: 400,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['Description'] ?? ''),
                      ),
                      Container(
                        width: 400,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['PNPDeviceID'] ?? ''),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
