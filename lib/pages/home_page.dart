import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network/items/employee_item.dart';
import 'package:network/service/network_service.dart';

import '../service/utils_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();
    EmployeeServices.getEmployees(context);
    // EmployeeServices.apiOneEmployee(1);
    // // EmployeeServices.createEmployee('ilmhub', 12000, 22);
    // // EmployeeServices.uptadeEmployee('ilmhub', 12000, 22, 12);
    // // EmployeeServices.deleteEmployee(12);
  }
  
  TextEditingController nameCtr = TextEditingController();
  TextEditingController ageCtr = TextEditingController();
  TextEditingController salaryCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTTP Networking'),
      actions: [
        IconButton(
          onPressed: (){
            _showBottomSheet(context);
          },
          icon: Icon(Icons.add),)
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: EmployeeServices.getEmployees(context),
            builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                  itemBuilder: (context, i){
                  return employeeItem(context, snapshot.data![i],
                      () async {
                        String? result =  await EmployeeServices.deleteEmployee(snapshot.data![i].id);
                        if(result == 'success'){
                        Utils.snackBarSucces('Deleted successfully', context);
                        } else {
                        Utils.snackBarError('Someting is wrong', context);
                        }
                      }
                  );
                  });
            } else {
              return const Center(
                child: Text('No data'),);
            }
          }),
      ),
    );
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Add new employee',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(
                    controller: nameCtr,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: ageCtr,
                    decoration: InputDecoration(labelText: 'Age'),
                  ),
                  TextFormField(
                    controller: salaryCtr,
                    decoration: InputDecoration(labelText: 'Salary'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(nameCtr.text.isNotEmpty && ageCtr.text.isNotEmpty && salaryCtr.text.isNotEmpty) {
                        String? result = await EmployeeServices.createEmployee(nameCtr.text, salaryCtr.text, ageCtr.text);
                        if(result == 'success'){
                          Utils.snackBarSucces('Added successfully', context);
                          Navigator.pop(context);
                        } else {
                          Utils.snackBarError('Someting is wrong', context);
                        }
                      } else {
                        Utils.snackBarError('Please fill all fileds', context);
                      }
                    },
                    child: Text('Add'),
                  ),
                  SizedBox(height: 400,)
                ],
              ),
            ),
          );
        });
  }

}

