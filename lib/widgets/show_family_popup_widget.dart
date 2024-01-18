// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/controllers/submit_family_bid_controller.dart';
import 'package:rm_official_app/models/today_market_model.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';

import '../models/family_bid_model.dart';
import '../provider/resend_otp_timer_provider.dart';
import '../provider/user_provider.dart';
import '../screens/bid/bid_history_screen.dart';
import '../screens/navigation/bottom_navigation.dart';

class BidFamilyPopup extends StatefulWidget {
  const BidFamilyPopup({
    super.key,
    required this.total,
    required this.market,
    required this.isOpen,
    required this.title,
    required this.allBids,
    required this.api,
    this.type,
  });

  @override
  State<BidFamilyPopup> createState() => _BidFamilyPopupState();

  final int total;
  final MarketList market;
  final String isOpen;
  final String title;
  final List<FamilyBids> allBids;
  final String api;
  final String? type;
}

class _BidFamilyPopupState extends State<BidFamilyPopup> {
  bool _isLoading = false;

  Future<void> submit() async {
    setState(() {
      _isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final timer = Provider.of<ResendTimerProvider>(context, listen: false);

    String lastResponse = '';
    int error = 0;
    for (final bid in widget.allBids) {
      if (kDebugMode) {
        print('SNO: ${bid.digit} Amount: ${bid.amount}');
      }
      final response = await submitFamilyBids(
        bids: bid,
        isOpen: widget.isOpen,
        marketId: widget.market.id,
        userId: userProvider.user.id,
        api: widget.api,
        type: widget.type ?? 'patta_group',
      );

      if (kDebugMode) {
        print('API Response: $response');
      }

      final er = response['error'];

      if (er) {
        error += 1;
      }

      lastResponse = response['message'];
    }
    setState(() {
      _isLoading = false;
    });
    if (error != 0) {
      Navigator.pop(context);
      showCoolErrorSnackbar(context, lastResponse);
    } else {
      timer.startTimer();
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NavigationBarApp(
            isHistory: true,
          ),
        ),
      );
      showCoolSuccessSnackbar(
          context, error > 0 ? 'Some bids not placed!' : lastResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<ResendTimerProvider>(context);
    return Dialog(
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // **Header**
              Text(
                '${widget.market.marketName} - ${widget.isOpen}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                DateFormat('dd-MMM-yyyy').format(DateTime.now()).toUpperCase(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // **Body**
              Expanded(
                child: ListView(
                  children: [
                    // // Table header
                    // Table(
                    //   border: TableBorder.all(color: Colors.grey, width: 1),
                    //   children: const [
                    //     TableRow(
                    //       children: [
                    //         Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: Text('SNO'),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: Text('BET AMOUNT'),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // Table body with dynamic rows
                    for (final bid in widget.allBids)
                      Table(
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('SERIAL NO: ${bid.digit}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'BID: ${bid.amount}*${bid.bids!.length}=${bid.bids!.length * bid.amount}'),
                              ),
                            ],
                          ),
                          for (final data in bid.bids!)
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('PANNA'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text('${data.number} = ${data.bidPoint}'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    // Total row
                    Table(
                      border: TableBorder.all(color: Colors.grey, width: 1),
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Total'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${widget.total}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // **Footer*
              _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.red, // Change the text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20), // Adjust padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust border radius
                            ),
                          ),
                          child: const Text(
                            'BACK',
                            style: TextStyle(fontSize: 16), // Change text style
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (timer.bidTimer == 60)
                          ElevatedButton(
                            onPressed: submit,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'CONFIRM',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Text(
                              'Wait: ${timer.bidTimer}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
