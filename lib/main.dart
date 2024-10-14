import 'package:flutter/material.dart';

class EmployeeManagementPage extends StatefulWidget {
  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  // Sample data, you can replace this with actual data fetched from a backend
  List<Map<String, String>> employees = [
    {
      "id": "101",
      "name": "John Doe",
      "role": "Engineer",
      "status": "Active",
      "joiningDate": "2023-01-01",
      "mobile": "+91 99999 99999",
      "email": "john@example.com"
    },
    {
      "id": "102",
      "name": "Jane Smith",
      "role": "Support",
      "status": "Inactive",
      "joiningDate": "2022-06-15",
      "mobile": "+91 88888 88888",
      "email": "jane@example.com"
    },
    // Add more employee data
  ];

  late List<Map<String, String>> filteredEmployees;

  // For search functionality
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredEmployees = employees; // Initial list
  }

  // Function to search employees by name
  void _filterEmployees(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredEmployees = employees;
      } else {}
    });
  }

  // Function to open employee edit dialog
  void _editEmployee(Map<String, String> employee) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController =
            TextEditingController(text: employee['name']);
        TextEditingController roleController =
            TextEditingController(text: employee['role']);
        TextEditingController mobileController =
            TextEditingController(text: employee['mobile']);
        TextEditingController emailController =
            TextEditingController(text: employee['email']);
        String status = employee['status']!;

        return AlertDialog(
          title: Text('Edit Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: roleController,
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              DropdownButton<String>(
                value: status,
                items: ['Active', 'Inactive'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newStatus) {
                  setState(() {
                    status = newStatus!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Perform save operation here (e.g., API call)
                setState(() {
                  employee['name'] = nameController.text;
                  employee['role'] = roleController.text;
                  employee['mobile'] = mobileController.text;
                  employee['email'] = emailController.text;
                  employee['status'] = status;
                });
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete employee
  void _deleteEmployee(String id) {
    setState(() {
      employees.removeWhere((employee) => employee['id'] == id);
      _filterEmployees(searchQuery);
    });
  }

  // Function to create pagination logic
  List<Map<String, String>> _getPaginatedEmployees(int start, int end) {
    return filteredEmployees.sublist(start, end);
  }

  // Widget to display employee management table
  Widget _buildEmployeeTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Joining Date')),
        DataColumn(label: Text('Mobile')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Actions')),
      ],
      rows: filteredEmployees.map((employee) {
        return DataRow(
          cells: [
            DataCell(Text(employee['id']!)),
            DataCell(Text(employee['name']!)),
            DataCell(Text(employee['role']!)),
            DataCell(Text(employee['status']!)),
            DataCell(Text(employee['joiningDate']!)),
            DataCell(Text(employee['mobile']!)),
            DataCell(Text(employee['email']!)),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editEmployee(employee);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteEmployee(employee['id']!);
                  },
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Open modal to add new employee
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Employees',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _filterEmployees(query);
              },
            ),
          ),
          Expanded(child: _buildEmployeeTable()),
        ],
      ),
    );
  }
}
