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

class InsideDoublePanna extends StatefulWidget {
  const InsideDoublePanna({
    super.key,
    required this.title,
    required this.market,
    required this.isOpen,
  });

  final String title;
  final MarketList market;
  final String isOpen;

  @override
  State<InsideDoublePanna> createState() => _InsideDoublePannaState();
}

class _InsideDoublePannaState extends State<InsideDoublePanna> {
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
                          _buildHeadingSmall(('1')),
                          _buildHeadingSmall(('2')),
                          _buildHeadingSmall(('3')),
                          _buildHeadingSmall(('4')),
                          _buildHeadingSmall(('5')),
                          _buildHeadingSmall(('6')),
                          _buildHeadingSmall(('7')),
                          _buildHeadingSmall(('8')),
                          _buildHeadingSmall(('9')),
                          _buildHeadingSmall(('0')),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('100').toString(), 100),
                          _buildInputField(('110').toString(), 110),
                          _buildInputField(('166').toString(), 166),
                          _buildInputField(('112').toString(), 112),
                          _buildInputField(('113').toString(), 113),
                          _buildInputField(('600').toString(), 600),
                          _buildInputField(('115').toString(), 115),
                          _buildInputField(('116').toString(), 116),
                          _buildInputField(('117').toString(), 117),
                          _buildInputField(('118').toString(), 118),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('119').toString(), 119),
                          _buildInputField(('200').toString(), 200),
                          _buildInputField(('229').toString(), 229),
                          _buildInputField(('220').toString(), 220),
                          _buildInputField(('122').toString(), 122),
                          _buildInputField(('114').toString(), 114),
                          _buildInputField(('133').toString(), 133),
                          _buildInputField(('224').toString(), 224),
                          _buildInputField(('144').toString(), 144),
                          _buildInputField(('226').toString(), 226),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('155').toString(), 155),
                          _buildInputField(('228').toString(), 228),
                          _buildInputField(('300').toString(), 300),
                          _buildInputField(('266').toString(), 266),
                          _buildInputField(('177').toString(), 177),
                          _buildInputField(('277').toString(), 277),
                          _buildInputField(('188').toString(), 188),
                          _buildInputField(('233').toString(), 233),
                          _buildInputField(('199').toString(), 199),
                          _buildInputField(('244').toString(), 244),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('227').toString(), 119),
                          _buildInputField(('255').toString(), 255),
                          _buildInputField(('337').toString(), 337),
                          _buildInputField(('338').toString(), 338),
                          _buildInputField(('339').toString(), 339),
                          _buildInputField(('330').toString(), 330),
                          _buildInputField(('223').toString(), 223),
                          _buildInputField(('288').toString(), 288),
                          _buildInputField(('225').toString(), 225),
                          _buildInputField(('299').toString(), 299),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('335').toString(), 335),
                          _buildInputField(('336').toString(), 336),
                          _buildInputField(('355').toString(), 355),
                          _buildInputField(('400').toString(), 400),
                          _buildInputField(('366').toString(), 366),
                          _buildInputField(('448').toString(), 448),
                          _buildInputField(('377').toString(), 377),
                          _buildInputField(('440').toString(), 440),
                          _buildInputField(('388').toString(), 388),
                          _buildInputField(('334').toString(), 334),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('344').toString(), 344),
                          _buildInputField(('499').toString(), 499),
                          _buildInputField(('445').toString(), 445),
                          _buildInputField(('446').toString(), 446),
                          _buildInputField(('447').toString(), 447),
                          _buildInputField(('466').toString(), 466),
                          _buildInputField(('449').toString(), 449),
                          _buildInputField(('477').toString(), 477),
                          _buildInputField(('559').toString(), 559),
                          _buildInputField(('488').toString(), 488),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('399').toString(), 399),
                          _buildInputField(('660').toString(), 660),
                          _buildInputField(('599').toString(), 599),
                          _buildInputField(('455').toString(), 455),
                          _buildInputField(('500').toString(), 500),
                          _buildInputField(('556').toString(), 556),
                          _buildInputField(('557').toString(), 557),
                          _buildInputField(('558').toString(), 558),
                          _buildInputField(('577').toString(), 577),
                          _buildInputField(('550').toString(), 550),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('588').toString(), 588),
                          _buildInputField(('688').toString(), 688),
                          _buildInputField(('779').toString(), 779),
                          _buildInputField(('699').toString(), 699),
                          _buildInputField(('799').toString(), 799),
                          _buildInputField(('880').toString(), 880),
                          _buildInputField(('566').toString(), 566),
                          _buildInputField(('800').toString(), 800),
                          _buildInputField(('667').toString(), 667),
                          _buildInputField(('668').toString(), 668),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('669').toString(), 669),
                          _buildInputField(('778').toString(), 778),
                          _buildInputField(('788').toString(), 788),
                          _buildInputField(('770').toString(), 770),
                          _buildInputField(('889').toString(), 889),
                          _buildInputField(('899').toString(), 899),
                          _buildInputField(('700').toString(), 700),
                          _buildInputField(('990').toString(), 990),
                          _buildInputField(('900').toString(), 900),
                          _buildInputField(('677').toString(), 677),
                        ]),
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
          width: 36,
          height: 30,
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
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 1),
        Container(
          width: 36,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            maxLength: 5,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 8,
            ),
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

  Widget _buildHeadingSmall(String heading) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: const Color.fromARGB(255, 54, 143, 244),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              heading,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
