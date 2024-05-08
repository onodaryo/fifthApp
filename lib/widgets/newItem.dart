import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/groceryItem.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      // boolを返す
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add anew item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  // value はテキストボックス内に入力されている内容
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null; // correct!
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _enteredQuantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // value はテキストボックス内に入力されている内容
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be valid, positive number.';
                        }
                        return null; // correct!
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!)!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.categoryColor,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.categoryName),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
