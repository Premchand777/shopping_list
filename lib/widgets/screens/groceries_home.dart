import 'package:flutter/material.dart';

import 'package:shopping_list/data/grocery_items.dart';

class GroceriesHome extends StatelessWidget {
  const GroceriesHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) {
          return ListTile(
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
            contentPadding: const EdgeInsets.only(left: 0.0, right: 12.0),
          );
        },
      ),
    );
  }
}
