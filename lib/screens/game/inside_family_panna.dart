// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/controllers/get_family_number_controller.dart';
import 'package:rm_official_app/models/pana_data_model.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/fade_red_heading_widget.dart';
import 'package:rm_official_app/widgets/heading_title_widget.dart';
import 'package:rm_official_app/widgets/show_family_popup_widget.dart';

import '../../models/family_bid_model.dart';
import '../../models/today_market_model.dart';

class InsideFamilyPanna extends StatefulWidget {
  const InsideFamilyPanna({
    super.key,
    required this.title,
    required this.market,
    required this.isOpen,
  });

  @override
  State<InsideFamilyPanna> createState() => _InsideFamilyPannaState();

  final String title;
  final MarketList market;
  final String isOpen;
}

class _InsideFamilyPannaState extends State<InsideFamilyPanna> {
  int total = 0;
  TextEditingController digitController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<FamilyBids> allBids = [];

  void showLotteryPopup(BuildContext context) {
    if (allBids.isEmpty) {
      showCoolErrorSnackbar(context, 'Please add a bid first!');
      return;
    }
    showDialog(
      context: context,
      builder: (_) => BidFamilyPopup(
        total: total,
        allBids: allBids,
        market: widget.market,
        isOpen: widget.isOpen,
        title: widget.title,
        api: 'https://rmmatka.com/ravan/api/family-bids',
      ),
    );
  }

  Future<void> addBids({required int amount, required int digit}) async {
    total = 0;

    final result = await getFamilyNumber(digit, 'patta_group');
    if (result != null) {
      if (result.error) {
        showCoolErrorSnackbar(context, result.message);
        return;
      }

      final bid = FamilyBids(digit: digit, amount: amount, data: result.data);

      allBids.removeWhere((data) => data.digit == bid.digit);

      setState(() {
        allBids.add(bid);
      });

      checkTotal();
    } else {
      showCoolErrorSnackbar(context, 'Invalid Number');
    }
  }

  void checkTotal() {
    total = 0;

    for (int i = 0; i < allBids.length; i++) {
      final bidsx = allBids[i];

      List<SingleBids> all = [];
      if (bidsx.data != null) {
        for (int j = 0; j < bidsx.data!.length; j++) {
          final b = bidsx.data![j];
          total += bidsx.amount;
          final bid = SingleBids(
              type: 'panna', number: b.pana, bidPoint: bidsx.amount.toString());
          // print(bid.toJson());
          all.add(bid);
        }
      }

      if (bidsx.digit == allBids[i].digit) {
        allBids[i].bids = all;
      }
    }

    setState(() {});
  }

  void createBid(
      int sNo, int value, List<SingleBids> bids, List<PanaData> data) {
    final b = FamilyBids(amount: value, digit: sNo, bids: bids, data: data);
    allBids.removeWhere((bid) => bid.digit == sNo);
    allBids.add(b);
    setState(() {});
  }

  void removeBid(int index) {
    setState(() {
      allBids.removeAt(index);

      checkTotal();
    });
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
                    FadeRedHeading(title: widget.title),
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.blueType,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
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
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 187, 77),
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ENTER DIGIT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: digitController,
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a digit';
                                  }

                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'ENTER DIGIT',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  disabledBorder: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'BID AMOUNT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: amountController,
                                maxLength: 5,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a bid amount';
                                  }
                                  if (int.tryParse(value) == null ||
                                      int.parse(value) > 99999) {
                                    return 'Please enter a valid five-digit number';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'ENTER BID AMOUNT',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  disabledBorder: InputBorder.none,
                                  counterText: '',
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    int digit = int.parse(digitController.text);
                                    int amount =
                                        int.parse(amountController.text);
                                    addBids(amount: amount, digit: digit);
                                    digitController.clear();
                                    amountController.clear();
                                  }
                                },
                                child: const Text('ADD'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 187, 77),
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BIDS LIST',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (allBids.isEmpty)
                            const Text('No bids added yet.')
                          else
                            Column(
                              children: List.generate(allBids.length, (index) {
                                final bid = allBids[index];
                                return Card(
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    title: Text(
                                      'Digit: ${bid.digit}, Amount: ${bid.amount}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.remove_circle),
                                      onPressed: () => removeBid(index),
                                    ),
                                  ),
                                );
                              }),
                            ),
                        ],
                      ),
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
                  Colors.red.withOpacity(0.5),
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
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: InkWell(
                onTap: () {
                  showLotteryPopup(context);
                },
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
}
