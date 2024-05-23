import 'package:fluent_ui/fluent_ui.dart';
import 'package:sodium/uitls/websocket_service.dart';
import 'package:flutter/material.dart' show Icons;

class NormalLogPage extends StatefulWidget{
  @override
  _NormalLogPageState createState() => _NormalLogPageState();
}
class _NormalLogPageState extends State<NormalLogPage>{
  late WebsocketService _websocketService;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  RegExp regExp=RegExp(r'\d+');
  String convertToDate(String timestampString){
    Iterable<Match> matches = regExp.allMatches(timestampString);
    String? extractedNumber;
    for (Match match in matches) {
      extractedNumber = match.group(0);
    }
    String dateTime=DateTime.fromMillisecondsSinceEpoch(int.parse(extractedNumber!)).toString();
    return dateTime;
  }
  @override
  void initState(){
    super.initState();
    _websocketService=WebsocketService("ws://localhost:8910");
    _websocketService.startSendingMessages("get_normal_logs");
    _websocketService.stream.listen((data) {
      dataList.clear();
      for (var item in data) {
        if (item is Map<String, dynamic>) {
          dataList.add(item);
        }
      }
      filterData(searchController.text);
    });
  }
  void filterData(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredList = List.from(dataList);
      } else {
        filteredList = dataList.where((data) =>
            data.values.any((value) => value.toString().toLowerCase().contains(keyword.toLowerCase()))).toList();
      }
    });
  }
  @override
  void dispose() {
    _websocketService.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextBox(
              controller: searchController,
              placeholder: "Search",
              onChanged: filterData,
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            height: 40,
            child: Row(
              children: [
                SizedBox(width: 20,),
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Icon(Icons.label_outline,color: Colors.red,),
                      SizedBox(width: 8),
                      Text("Id", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Icon(Icons.list,color: Colors.grey,),
                      SizedBox(width: 8),
                      Text("Level", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Icon(Icons.android,color: Color.fromARGB(255, 0, 178, 148),),
                      SizedBox(width: 8),
                      Text("ProviderName", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Icon(FluentIcons.buffer_time_both,color: Colors.blue,),
                      SizedBox(width: 8),
                      Text("TimeCreated", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  child:
                  Expander(
                    header:Row(
                    children: [
                      SizedBox(width: 20),
                      Container(
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['Id'].toString() ?? ''),
                      ),
                      Container(
                        width: 200,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['Level'].toString() ?? ''),
                      ),
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['ProviderName'] ?? ''),
                      ),
                      Container(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        child: Text(convertToDate(filteredList[index]['TimeCreated'].toString()) ?? ''),
                      ),
                    ],
                  ),
                  content: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Id: ${filteredList[index]['Id'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Version: ${filteredList[index]['Version'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Qualifier: ${filteredList[index]['Qualifiers'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Level: ${filteredList[index]['Level'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Task: ${filteredList[index]['Task'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Opcode: ${filteredList[index]['Opcode'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Keywords: ${filteredList[index]['Keywords'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "RecordId: ${filteredList[index]['RecordId'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "ProviderName: ${filteredList[index]['ProviderName'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "LogName: ${filteredList[index]['LogName'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "ProcessId: ${filteredList[index]['ProcessId'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "ThreadId: ${filteredList[index]['ThreadId'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "MachineName: ${filteredList[index]['MachineName'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "UserId: ${filteredList[index]['UserId'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "TimeCreated: ${filteredList[index]['TimeCreated'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "ActivityId: ${filteredList[index]['ActivityId'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "RelatedActivityId: ${filteredList[index]['RelatedActivityId'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "ContainerLog: ${filteredList[index]['ContainerLog'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Properties: ${filteredList[index]['Properties'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "Message: ${filteredList[index]['Message'].toString()}",
                          style: TextStyle(fontSize: 18),
                        ),

                      ],
                    ),
                  ),),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}