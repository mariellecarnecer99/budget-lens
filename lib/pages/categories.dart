import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  // Default list of categories
  List<String> categories = ['Food', 'Transport', 'Entertainment', 'Utilities'];

  // Function to handle adding a new category
  void addCategory() async {
    String? newCategory = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Category"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter category name"),
            onSubmitted: (value) {
              Navigator.of(context).pop(value);
            },
          ),
        );
      },
    );

    if (newCategory != null && newCategory.isNotEmpty) {
      setState(() {
        categories.add(newCategory);
      });
    }
  }

  // Function to handle editing an existing category
  void editCategory(int index) async {
    String? editedCategory = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Category"),
          content: TextField(
            autofocus: true,
            controller: TextEditingController(text: categories[index]),
            decoration: InputDecoration(hintText: "Edit category name"),
            onSubmitted: (value) {
              Navigator.of(context).pop(value);
            },
          ),
        );
      },
    );

    if (editedCategory != null && editedCategory.isNotEmpty) {
      setState(() {
        categories[index] = editedCategory;
      });
    }
  }

  // Function to handle deleting a category
  void deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Categories"),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => editCategory(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteCategory(index),
                ),
              ],
            ),
            onTap: () {
              // Optional: You could handle item tap to view category details
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCategory,
        child: Icon(Icons.add),
        tooltip: "Add Category",
      ),
    );
  }
}
