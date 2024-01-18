import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';

import '../../widgets/market_rates_loop_widget.dart';

class MarketRatesScreen extends StatefulWidget {
  const MarketRatesScreen({super.key});

  @override
  State<MarketRatesScreen> createState() => _MarketRatesScreenState();
}

class _MarketRatesScreenState extends State<MarketRatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.redType,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Market Rates',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 18,
            ),
            Text(
              'MAIN GAME RATES',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            MarketRatesLoop(
              name: 'SINGLE_DIGIT',
              rate: '10-95',
            ),
            MarketRatesLoop(
              name: 'JODI_DIGIT',
              rate: '10-950',
            ),
            MarketRatesLoop(
              name: 'SINGLE_PANA',
              rate: '10-1500',
            ),
            MarketRatesLoop(
              name: 'DOUBLE_PANA',
              rate: '10-3000',
            ),
            MarketRatesLoop(
              name: 'TRIPLE_PANA',
              rate: '10-8000',
            ),
            MarketRatesLoop(
              name: 'HALF_SANGAM',
              rate: '10-12000',
            ),
            MarketRatesLoop(
              name: 'FULL_SANGAM',
              rate: '10-100000',
            )
          ],
        ),
      ),
    );
  }
}
