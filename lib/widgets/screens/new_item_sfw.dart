import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  bool _isLoading = false;

  var itemName = '';
  var quantity = '';
  Category category = categories.entries.first.value;
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.https(
          dotenv.env['FireBaseURI']!,
          'shopping_list.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': itemName,
            'quantity': quantity,
            'category': category.categoryName,
          },
        ),
      );
      if (mounted) {
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
            id: json.decode(response.body)['name'],
            name: itemName,
            quantity: int.tryParse(quantity)!,
            category: category,
          ),
        );
      }
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
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: TextButton(
                      // style: const ButtonStyle(
                      //   padding: MaterialStatePropertyAll(
                      //     EdgeInsets.fromLTRB(32, 16, 32, 16),
                      //   ),
                      // ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              _formKey.currentState!.reset();
                            },
                      child: const Text(
                        'Reset',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      // style: const ButtonStyle(
                      //   padding: MaterialStatePropertyAll(
                      //     EdgeInsets.fromLTRB(32, 16, 32, 16),
                      //   ),
                      // ),
                      onPressed: _saveItem,
                      child: _isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator.adaptive(
                                backgroundColor: Theme.of(context)
                                    .indicatorColor
                                    .withAlpha(16),
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context)
                                      .indicatorColor
                                      .withAlpha(112),
                                ),
                              ),
                            )
                          : const Text(
                              'Submit',
                            ),
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
