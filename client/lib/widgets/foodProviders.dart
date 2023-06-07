import 'package:client/widgets/foodProviderCard.dart';
import 'package:flutter/material.dart';
import 'package:client/services/business_service.dart';
import 'package:client/pages/foodProvider.dart';

class FoodProviders extends StatefulWidget {
  const FoodProviders({Key? key}) : super(key: key);

  @override
  _FoodProvidersState createState() => _FoodProvidersState();
}

class _FoodProvidersState extends State<FoodProviders> {
  List<Map<String, dynamic>> _profiles = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    _profiles = await fetchBusinessProfiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return FoodProviderCard(profile: profile);
      },
    );
  }
}
