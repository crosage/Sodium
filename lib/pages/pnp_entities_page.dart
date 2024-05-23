import 'package:fluent_ui/fluent_ui.dart';
import 'package:sodium/uitls/websocket_service.dart';

class PnPEntitiesPage extends StatefulWidget{
  @override
  _PnPEntitiesPageState createState() => _PnPEntitiesPageState();
}
class _PnPEntitiesPageState extends State<PnPEntitiesPage>{
  late WebsocketService _websocketService;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState(){
    super.initState();
    _websocketService=WebsocketService("ws://localhost:8910");
    _websocketService.startSendingMessages("get_pnp_entities");
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
                      Icon(FluentIcons.devices2,color: Colors.blue,),
                      SizedBox(width: 8),
                      Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Icon(FluentIcons.manufacturing,color: Colors.orange,),
                      SizedBox(width: 8),
                      Text("Manufacturer", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Icon(FluentIcons.text_document,color: Color.fromARGB(255, 0xA6, 0xA6, 0xA6),),
                      SizedBox(width: 8),
                      Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Icon(FluentIcons.info,color: Color.fromARGB(255, 0, 178, 148),),
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
                        width: 300,
                        alignment: Alignment.centerLeft,
                        child: Text(filteredList[index]['Description'] ?? ''),
                      ),
                      Container(
                        width: 300,
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
}