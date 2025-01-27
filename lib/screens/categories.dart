import 'package:expense_tracker/services/database_helper.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void addCategory() async {
    String? newCategoryName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 12),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter category name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade800),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );

    if (newCategoryName != null && newCategoryName.isNotEmpty) {
      Category newCategory = Category(name: newCategoryName);
      var dbHelper = DatabaseHelper();
      await dbHelper.insertCategory(newCategory);
      loadCategories();
    }
  }

  void loadCategories() async {
    var dbHelper = DatabaseHelper();
    List<Category> categoriesFromDb = await dbHelper.getCategories();

    setState(() {
      categories = categoriesFromDb;
    });
  }

  void editCategory(int index) async {
    Category categoryToEdit = categories[index];
    String? editedCategoryName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Category",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  autofocus: true,
                  controller: TextEditingController(text: categoryToEdit.name),
                  decoration: InputDecoration(
                    hintText: "Edit category name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade800),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    Navigator.of(context).pop(value);
                  },
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );

    if (editedCategoryName != null && editedCategoryName.isNotEmpty) {
      Category updatedCategory =
          Category(id: categoryToEdit.id, name: editedCategoryName);
      var dbHelper = DatabaseHelper();
      await dbHelper.updateCategory(updatedCategory);
      loadCategories();
    }
  }

  void deleteCategory(int index) async {
    var dbHelper = DatabaseHelper();
    Category categoryToDelete = categories[index];
    await dbHelper.deleteCategory(categoryToDelete.id!);
    setState(() {
      categories.removeAt(index);
    });
    loadCategories();
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
            title: Text(categories[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue.shade800,
                  ),
                  onPressed: () => editCategory(index),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.blue.shade800,
                  ),
                  onPressed: () => deleteCategory(index),
                ),
              ],
            ),
            onTap: () {},
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCategory,
        tooltip: "Add Category",
        backgroundColor: Colors.blue.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
