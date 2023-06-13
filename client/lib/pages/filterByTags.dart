import 'package:flutter/material.dart';

class FilterByTags extends StatefulWidget {
  final List<String> checkedTags;
  const FilterByTags({super.key, required this.checkedTags});

  @override
  State<FilterByTags> createState() => _FilterByTagsState();
}

class _FilterByTagsState extends State<FilterByTags> {
  List<String> selectedTags = [];
  List<String> availableTags = [
    'Vegan',
    'Vegetarian',
    'Gluten-free',
    'Dairy-free',
    'Nut-free',
    'Egg-free',
    'Soy-free',
    'Shellfish-free',
    'Fish-free',
    'Halal',
    'Kosher',
    'Organic',
    'Locally sourced',
    'Sugar-free',
    'Low-carb',
    'Paleo',
    'Keto-friendly',
    'Whole30',
    'Allergen-free',
    'Non-GMO',
    'Non-Vegetarian',
    'Jain',
    'Sattvic',
    'Punjabi',
    'South Indian',
    'North Indian',
    'Gujarati',
    'Rajasthani',
    'Bengali',
    'Maharashtrian',
    'Goan',
    'Hyderabadi',
    'Kashmiri',
    'Awadhi',
    'Chettinad',
    'Kerala',
    'Mughlai',
  ];

  @override
  void initState() {
    super.initState();
    selectedTags = List<String>.from(widget.checkedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Menu'),
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView(
              children: availableTags.map((tag) {
                return CheckboxListTile(
                  checkColor: Color.fromARGB(255, 224, 254, 245),
                  activeColor: Color.fromARGB(190, 61, 135, 118),
                  title: Text(
                    tag,
                  ),
                  value: selectedTags.contains(tag),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _clearFilter,
                  icon: Icon(Icons.delete),
                  label: Text('Clear Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: _applyFilter,
                  child: Text(
                    'Apply Filter',
                    style: TextStyle(
                      color: Color.fromARGB(255, 224, 254, 245),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilter() {
    Navigator.pop(context, selectedTags);
  }

  void _clearFilter() {
    setState(() {
      selectedTags.clear();
    });
  }
}
