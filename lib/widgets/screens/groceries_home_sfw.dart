import 'package:flutter/material.dart';

import 'package:shopping_list/data/grocery_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/screens/new_item_sfw.dart';

class GroceriesHomeScreenSFW extends StatefulWidget {
  const GroceriesHomeScreenSFW({
    super.key,
  });

  @override
  State<GroceriesHomeScreenSFW> createState() => _GroceriesHomeSFWState();
}

class _GroceriesHomeSFWState extends State<GroceriesHomeScreenSFW> {
  void _addNewItem() async {
    final groceryItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreenSFW(),
      ),
    );
    if (groceryItem != null) {
      setState(() {
        groceryItems.add(groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
            ),
            onPressed: _addNewItem,
            style: const ButtonStyle(iconSize: MaterialStatePropertyAll(28)),
          ),
        ],
      ),
      body: groceryItems.isNotEmpty
          ? ListView.builder(
              itemCount: groceryItems.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: ValueKey(groceryItems[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(ctx).colorScheme.onErrorContainer,
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        groceryItems.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Item removed',
                            ),
                            duration: Durations.extralong1,
                          ),
                        );
                      });
                    }
                  },
                  child: ListTile(
                    title: Text(groceryItems[index].name),
                    leading: IconButton(
                      icon: Icon(
                        Icons.square_rounded,
                        color: groceryItems[index].category.categoryColor,
                      ),
                      onPressed: () {},
                    ),
                    trailing: Text(
                      groceryItems[index].quantity.toString(),
                      style: Theme.of(ctx).textTheme.bodyLarge,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 0.0, right: 12.0),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'Anything to buy ? add one.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
    );
  }
}
