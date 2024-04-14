import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/models/calculate_bid_model.dart';
import 'package:rm_official_app/models/today_market_model.dart';
import 'package:rm_official_app/widgets/bid_popup_widget.dart';
import 'package:rm_official_app/widgets/heading_title_widget.dart';

import '../../widgets/app_bar_widget.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../../widgets/fade_red_heading_widget.dart';

class InsideTriplePanna extends StatefulWidget {
  const InsideTriplePanna({
    super.key,
    required this.title,
    required this.market,
    required this.isOpen,
  });

  final String title;
  final MarketList market;
  final String isOpen;

  @override
  State<InsideTriplePanna> createState() => _InsideTriplePannaState();
}

class _InsideTriplePannaState extends State<InsideTriplePanna> {
  int total = 0;
  List<int> fieldValues = List.filled(1000, 0);
  List<CalculateBid> bids = [];

  void showLotteryPopup(BuildContext context) {
    if (bids.isEmpty) {
      showCoolErrorSnackbar(context, 'Please add a bid first!');
      return;
    }
    showDialog(
      context: context,
      builder: (_) => BidPopupWidget(
        total: total,
        bids: bids,
        market: widget.market,
        isOpen: widget.isOpen,
        title: widget.title,
      ),
    );
  }

  void createBid(int sNo, int value) {
    final b = CalculateBid(betAmount: value, sNo: sNo);
    bids.removeWhere((bid) => bid.sNo == sNo);
    bids.add(b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBarWidget(
        title: widget.title,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      FadeRedHeading(
                        title: widget.title == 'SINGLE DIGIT'
                            ? 'SINGLE AKDA'
                            : widget.title,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: AppColors.blueType,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Text(
                          DateFormat('dd-MMM-yyyy')
                              .format(DateTime.now())
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      HeadingTitle(
                          title:
                              '${widget.market.marketName}\n(${widget.isOpen})'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInputField(('777').toString(), 777),
                            _buildInputField(('444').toString(), 444),
                            _buildInputField(('111').toString(), 111),
                            _buildInputField(('888').toString(), 888),
                            _buildInputField(('555').toString(), 555),
                          ]),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInputField(('222').toString(), 222),
                            _buildInputField(('999').toString(), 999),
                            _buildInputField(('666').toString(), 666),
                            _buildInputField(('333').toString(), 333),
                            _buildInputField(('000').toString(), 000),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            width: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.red.withOpacity(0.5),
                  Colors.red.withOpacity(0.7),
                  Colors.red,
                  Colors.red,
                  Colors.red,
                  Colors.red,
                  Colors.red,
                  Colors.red.withOpacity(0.7),
                  Colors.red.withOpacity(0.5)
                ],
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Center(
                child: Text(
                  'TOTAL POINT: $total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: InkWell(
              onTap: () {
                showLotteryPopup(context);
              },
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String heading, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 65,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              heading,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 65,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            maxLength: 5,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
            onChanged: (value) {
              createBid(index, int.tryParse(value) ?? 0);
              setState(() {
                total += (int.tryParse(value) ?? 0) - fieldValues[index];
                fieldValues[index] = int.tryParse(value) ?? 0;
              });
            },
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
