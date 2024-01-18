import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/widgets/heading_title_widget.dart';

import '../../models/calculate_bid_model.dart';
import '../../models/today_market_model.dart';
import '../../widgets/bid_popup_widget.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../../widgets/fade_red_heading_widget.dart';

class InsideJodiScreen extends StatefulWidget {
  const InsideJodiScreen(
      {super.key,
      required this.title,
      required this.market,
      required this.isOpen});

  @override
  State<InsideJodiScreen> createState() => _InsideJodiScreenState();

  final String title;
  final MarketList market;
  final String isOpen;
}

class _InsideJodiScreenState extends State<InsideJodiScreen> {
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
        title: 'jodi digit',
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
      appBar: AppBar(
        backgroundColor: AppColors.redType,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    FadeRedHeading(
                      title: widget.title,
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
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const HeadingTitle(title: 'AVANTI DAY\n(CLOSE)'),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 11 == 20 ? 10 : index + 11).toString(),
                            index + 11 == 20 ? 10 : index + 11);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 21 == 30 ? 20 : index + 21).toString(),
                            index + 21 == 30 ? 20 : index + 21);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 31 == 40 ? 30 : index + 31).toString(),
                            index + 31 == 40 ? 30 : index + 31);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 41 == 50 ? 40 : index + 41).toString(),
                            index + 41 == 50 ? 40 : index + 41);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 51 == 60 ? 50 : index + 51).toString(),
                            index + 51 == 60 ? 50 : index + 51);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 61 == 70 ? 60 : index + 61).toString(),
                            index + 61 == 70 ? 60 : index + 61);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 71 == 80 ? 70 : index + 71).toString(),
                            index + 71 == 80 ? 70 : index + 71);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 81 == 90 ? 80 : index + 81).toString(),
                            index + 81 == 90 ? 80 : index + 81);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 91 == 100 ? 90 : index + 91).toString(),
                            index + 91 == 100 ? 90 : index + 91);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(10, (index) {
                        return _buildInputField(
                            (index + 1 == 10 ? 00 : index + 1).toString(),
                            index + 1 == 10 ? 00 : index + 1);
                      }),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
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
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              heading.padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            maxLength: 5,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 10),
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
