import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItemScreenSFW extends StatefulWidget {
  const NewItemScreenSFW({
    super.key,
  });

  @override
  State<NewItemScreenSFW> createState() => _NewItemScreenSFWState();
}

class _NewItemScreenSFWState extends State<NewItemScreenSFW> {
  final _formKey = GlobalKey<FormState>();

  var itemName = '';
  var quantity = '';
  Category category = categories.entries.first.value;
  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Item added successfully',
          ),
          duration: Durations.extralong1,
        ),
      );
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: itemName,
          quantity: int.tryParse(quantity)!,
          category: category,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
                keyboardType: TextInputType.name,
                maxLength: 30,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.length <= 2 ||
                      value.length > 30) {
                    return 'Must be in between 2 and 30 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  itemName = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '1',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value) == 0) {
                          return 'Atleast 1 is required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        quantity = value!;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                      ),
                      value: categories.entries.first.value,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.square_rounded,
                                  color: category.value.categoryColor,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  category.value.categoryName,
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        category = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.fromLTRB(24, 8, 24, 8),
                      ),
                    ),
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text(
                      'Reset',
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.fromLTRB(24, 8, 24, 8),
                      ),
                    ),
                    onPressed: _saveItem,
                    child: const Text(
                      'Submit',
                    ),
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
