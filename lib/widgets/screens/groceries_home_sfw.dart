import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

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
  bool _isLoading = true;
  late List<GroceryItem> _groceryItems = [];
  void _loadGroceryItems() {
    final getUrl = Uri.https(dotenv.env['FireBaseURI']!, 'shopping_list.json');
    http.get(getUrl).then((response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic>? bodyMap = json.decode(response.body);
        final List<GroceryItem> groceryItems = [];
        if (bodyMap != null) {
          for (final item in bodyMap.entries) {
            groceryItems.add(
              GroceryItem(
                id: item.key,
                name: item.value['name'],
                quantity: int.tryParse(item.value['quantity'])!,
                category: categories.entries
                    .firstWhere((category) =>
                        category.value.categoryName == item.value['category'])
                    .value,
              ),
            );
          }
        }
        setState(() {
          _groceryItems = groceryItems;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // load grocery items initially here
    _loadGroceryItems();
  }

  void _addNewItem() async {
    final groceryItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreenSFW(),
      ),
    );
    if (groceryItem != null) {
      setState(() {
        _groceryItems.add(groceryItem);
      });
    }
  }

  void _removeItem(GroceryItem item) async {
    setState(() {
      _groceryItems.remove(item);
    });

    final deleteUrl =
        Uri.https(dotenv.env['FireBaseURI']!, 'shopping_list/${item.id}.json');
    final response = await http.delete(deleteUrl);
    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Item removed',
            ),
            duration: Durations.extralong1,
          ),
        );
      }
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Theme.of(context).indicatorColor.withAlpha(16),
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).indicatorColor.withAlpha(112),
                ),
              ),
            )
          : _groceryItems.isNotEmpty
              ? ListView.builder(
                  itemCount: _groceryItems.length,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: ValueKey(_groceryItems[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Theme.of(ctx).colorScheme.onErrorContainer,
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          _removeItem(_groceryItems[index]);
                        }
                      },
                      child: ListTile(
                        title: Text(_groceryItems[index].name),
                        leading: IconButton(
                          icon: Icon(
                            Icons.square_rounded,
                            color: _groceryItems[index].category.categoryColor,
                          ),
                          onPressed: () {},
                        ),
                        trailing: Text(
                          _groceryItems[index].quantity.toString(),
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
