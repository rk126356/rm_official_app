// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/controllers/get_number_data_controller.dart';
import 'package:rm_official_app/models/sangam_bid_model.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/fade_red_heading_widget.dart';
import 'package:rm_official_app/widgets/heading_title_widget.dart';

import '../../models/number_data_model.dart';
import '../../models/today_market_model.dart';
import '../../widgets/sangam_bid_popup_widget.dart';

class InsideSangamScreen extends StatefulWidget {
  const InsideSangamScreen({
    super.key,
    required this.title,
    required this.market,
    required this.isOpen,
  });

  @override
  State<InsideSangamScreen> createState() => _InsideSangamScreenState();

  final String title;
  final MarketList market;
  final String isOpen;
}

class _InsideSangamScreenState extends State<InsideSangamScreen> {
  int total = 0;
  TextEditingController amountController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  NumberDataModel? numbers;

  List<SangamBidModel> allBids = [];

  String? selectedOpenDigit;
  String? selectedCloseDigit;

  String? openDigitSearch;
  String? closeDigitSearch;

  void showDropdownPopup(BuildContext context, bool isOpen) {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SimpleDialog(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (isOpen) {
                          openDigitSearch = value;
                        } else {
                          closeDigitSearch = value;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter search term',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  height: 300.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var category in isOpen
                            ? numbers?.data.ink ?? []
                            : numbers?.data.pana ?? [])
                          if (category.number.toLowerCase().contains((isOpen
                                  ? openDigitSearch ?? ''
                                  : closeDigitSearch ?? '')
                              .toLowerCase()))
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, category.number);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    category.number,
                                    style: const TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          if (isOpen) {
            selectedOpenDigit = value;
          } else {
            selectedCloseDigit = value;
          }
        });
      }
    });
  }

  void showLotteryPopup(BuildContext context) {
    if (allBids.isEmpty) {
      showCoolErrorSnackbar(context, 'Please add a bid first!');
      return;
    }
    showDialog(
      context: context,
      builder: (_) => SangamBidPopup(
        total: total,
        market: widget.market,
        isOpen: widget.isOpen,
        title: widget.title,
        bids: allBids,
      ),
    );
  }

  Future<void> fetchNumbers() async {
    final num =
        await getNumberData(widget.title == 'HALF SANGAM' ? true : false);

    if (num != null) {
      numbers = num;
      selectedOpenDigit = num.data.ink.first.number;
      selectedCloseDigit = num.data.pana.first.number;
      setState(() {});
    } else {
      showCoolErrorSnackbar(context, 'Error fetching numbers');
      return;
    }
  }

  Future<void> addBids(
      {required int amount, required int open, required int close}) async {
    final b = SangamBidModel(betAmount: amount, open: open, close: close);
    allBids.removeWhere((bid) => bid.open == open);
    allBids.add(b);

    checkTotal();
  }

  void checkTotal() {
    total = 0;
    for (int i = 0; i < allBids.length; i++) {
      final bidsx = allBids[i];

      total += bidsx.betAmount;
    }

    setState(() {});
  }

  void removeBid(int index) {
    setState(() {
      allBids.removeAt(index);

      checkTotal();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNumbers();
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
                              InkWell(
                                onTap: () => showDropdownPopup(context, true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.title == 'FULL SANGAM'
                                                ? 'OPEN PANNA'
                                                : 'OPEN DIGIT',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            selectedOpenDigit ?? 'Select',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: () => showDropdownPopup(context, false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'CLOSE PANNA',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            selectedCloseDigit ?? 'Select',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
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
                                    int amount =
                                        int.parse(amountController.text);
                                    addBids(
                                        amount: amount,
                                        open: int.parse(openDigitSearch ??
                                            selectedOpenDigit!),
                                        close: int.parse(closeDigitSearch ??
                                            selectedCloseDigit!));
                                    openDigitSearch = null;
                                    closeDigitSearch = null;

                                    setState(() {});
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
                    bidsPart(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          bottomPart(context),
        ],
      ),
    );
  }

  Container bidsPart() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 187, 77),
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      'Open: ${bid.open}, Close: ${bid.close}, Amount: ${bid.betAmount}',
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
    );
  }

  Column bottomPart(BuildContext context) {
    return Column(
      children: [
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
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
    );
  }
}
