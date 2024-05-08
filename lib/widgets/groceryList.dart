import 'package:flutter/material.dart';

import 'package:shopping_list/models/groceryItem.dart';
import 'package:shopping_list/widgets/newItem.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      // future型返すよ
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _onRemovedGrocery(GroceryItem groceryItem){
    final groceryIndex = _groceryItems.indexOf(groceryItem);
    setState(() {
      _groceryItems.remove(groceryItem);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (){
            setState(() {
              _groceryItems.insert(groceryIndex, groceryItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget contents = ListView.builder(
      itemCount: _groceryItems.length,
      itemBuilder: (ctx, index) => Dismissible(
          direction: DismissDirection.endToStart,
        background: Container(
          padding: const EdgeInsets.symmetric(vertical: 36),
          color: Theme.of(context).colorScheme.error,
        ),
        key: ValueKey(_groceryItems[index].id),
        child: ListTile(
          title: Text(_groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItems[index].category.categoryColor,
          ),
          trailing: Text(_groceryItems[index].quantity.toString()),
        ),
        onDismissed: (direction) {
          if(direction == DismissDirection.endToStart){
            _onRemovedGrocery(_groceryItems[index]);
          }
        }
      ),
    );

    if (_groceryItems.isEmpty) {
      contents = Center(
        child: Text(
          'Please add your grocery Item!',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
      );
    }

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
              onPressed: () {
                _addItem(context);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: contents);
  }
}
