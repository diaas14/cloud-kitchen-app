import 'package:client/widgets/foodProviderCard.dart';
import 'package:client/widgets/menuItemCard.dart';
import 'package:flutter/material.dart';
import 'package:client/services/business_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool isFoodProvidersSelected = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchData(String value) async {
    final trimmedValue = value.trim();
    if (trimmedValue.isNotEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = true;
      });
      if (isFoodProvidersSelected) {
        _searchResults = await fetchFoodProvidersBySearch(trimmedValue);
      } else {
        _searchResults = await fetchFoodItemsBySearch(trimmedValue);
      }
      print(_searchResults);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
        title: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 234, 244, 241),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2), // changes the position of the shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black),
              SizedBox(width: 10.0),
              Expanded(
                child: TextField(
                  cursorColor: Color.fromARGB(190, 61, 135, 118),
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    hintText: 'Search "Dosa"',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) async {
                    await _searchData(value);
                  },
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Color.fromARGB(190, 61, 135, 118), // Background color
                  ),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        isFoodProvidersSelected = true;
                      });
                      await _searchData(_searchController.text);
                    },
                    child: Text(
                      'Food Providers',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isFoodProvidersSelected
                            ? FontWeight.bold
                            : FontWeight.normal, // Text color
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Color.fromARGB(190, 61, 135, 118), // Background color
                  ),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        isFoodProvidersSelected = false;
                      });
                      await _searchData(_searchController.text);
                    },
                    child: Text(
                      'Food',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: !isFoodProvidersSelected
                            ? FontWeight.bold
                            : FontWeight.normal, // Text color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _searchResults.isEmpty
                      ? Center(
                          child: Text('No search results'),
                        )
                      : isFoodProvidersSelected
                          ? ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final provider = _searchResults[index];
                                return FoodProviderCard(profile: provider);
                              },
                            )
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final item = _searchResults[index];
                                return Text("MenuItem");
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
