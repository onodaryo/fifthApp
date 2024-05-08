import 'package:flutter/material.dart';

import 'package:shopping_list/data/dummyItems.dart';
import 'package:shopping_list/models/groceryItem.dart';
import 'package:shopping_list/widgets/newItem.dart';

class GroceryList extends StatefulWidget {
  
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Groceries',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
        actions: [
          IconButton(
            onPressed: (){_addItem(context);},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: groceryItems[index].category.categoryColor,
          ),
          trailing: Text(groceryItems[index].quantity.toString()),
        ),
      ),
    );
  }
}
