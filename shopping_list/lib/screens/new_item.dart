import 'package:flutter/material.dart';
import 'package:shopping_list/models/models.dart';

import '../data/data.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredQuantity = 1;
  var _selectedCategory = Categories.fruit;

  String? _titleValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= 1 ||
        value.trim().length > 50) {
      return 'Символы должны быть больше 1 и меньше 50';
    }
    return null;
  }

  String? _quantityValidator(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value)! <= 0) {
      return 'Число должен быть валидным';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredTitle,
          quantity: _enteredQuantity,
          category: categories[_selectedCategory]!,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  void _onSavedTitle(String? newValue) {
    _enteredTitle = newValue!;
  }

  void _onSavedQuantity(String? newValue) {
    _enteredQuantity = int.parse(newValue!);
  }

  void _onChangedCategory(value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Новый продукт'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Имя'),
                      ),
                      validator: _titleValidator,
                      onSaved: _onSavedTitle,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: '1',
                            decoration: const InputDecoration(
                              label: Text('Штук'),
                            ),
                            validator: _quantityValidator,
                            onSaved: _onSavedQuantity,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField(
                            value: _selectedCategory,
                            items: [
                              for (final category in categories.entries)
                                DropdownMenuItem(
                                  value: category.key,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: category.value.color,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(category.value.name),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: _onChangedCategory,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _resetForm,
                          child: const Text('Очистить'),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Отправить'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
