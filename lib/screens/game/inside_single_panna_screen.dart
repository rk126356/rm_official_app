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

class InsideSinglePanna extends StatefulWidget {
  const InsideSinglePanna({
    super.key,
    required this.title,
    required this.market,
    required this.isOpen,
  });

  final String title;
  final MarketList market;
  final String isOpen;

  @override
  State<InsideSinglePanna> createState() => _InsideSinglePannaState();
}

class _InsideSinglePannaState extends State<InsideSinglePanna> {
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
              scrollDirection: Axis.vertical,
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
                      height: 8,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('128').toString(), 128),
                          _buildInputField(('129').toString(), 129),
                          _buildInputField(('120').toString(), 120),
                          _buildInputField(('130').toString(), 130),
                          _buildInputField(('140').toString(), 140),
                          _buildInputField(('123').toString(), 123),
                          _buildInputField(('124').toString(), 124),
                          _buildInputField(('125').toString(), 125),
                          _buildInputField(('126').toString(), 126),
                          _buildInputField(('127').toString(), 127),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('137').toString(), 137),
                          _buildInputField(('138').toString(), 138),
                          _buildInputField(('139').toString(), 139),
                          _buildInputField(('149').toString(), 149),
                          _buildInputField(('159').toString(), 159),
                          _buildInputField(('150').toString(), 150),
                          _buildInputField(('160').toString(), 160),
                          _buildInputField(('134').toString(), 134),
                          _buildInputField(('135').toString(), 135),
                          _buildInputField(('136').toString(), 136),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('146').toString(), 146),
                          _buildInputField(('147').toString(), 147),
                          _buildInputField(('148').toString(), 148),
                          _buildInputField(('158').toString(), 158),
                          _buildInputField(('168').toString(), 168),
                          _buildInputField(('169').toString(), 169),
                          _buildInputField(('278').toString(), 278),
                          _buildInputField(('170').toString(), 170),
                          _buildInputField(('180').toString(), 180),
                          _buildInputField(('145').toString(), 145),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('236').toString(), 236),
                          _buildInputField(('156').toString(), 156),
                          _buildInputField(('157').toString(), 157),
                          _buildInputField(('167').toString(), 167),
                          _buildInputField(('230').toString(), 230),
                          _buildInputField(('178').toString(), 178),
                          _buildInputField(('179').toString(), 179),
                          _buildInputField(('189').toString(), 189),
                          _buildInputField(('234').toString(), 234),
                          _buildInputField(('190').toString(), 190),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('245').toString(), 245),
                          _buildInputField(('237').toString(), 237),
                          _buildInputField(('238').toString(), 238),
                          _buildInputField(('239').toString(), 239),
                          _buildInputField(('249').toString(), 249),
                          _buildInputField(('240').toString(), 240),
                          _buildInputField(('250').toString(), 250),
                          _buildInputField(('260').toString(), 260),
                          _buildInputField(('270').toString(), 270),
                          _buildInputField(('235').toString(), 235),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('290').toString(), 290),
                          _buildInputField(('246').toString(), 246),
                          _buildInputField(('247').toString(), 247),
                          _buildInputField(('248').toString(), 248),
                          _buildInputField(('258').toString(), 258),
                          _buildInputField(('259').toString(), 259),
                          _buildInputField(('269').toString(), 269),
                          _buildInputField(('279').toString(), 279),
                          _buildInputField(('289').toString(), 289),
                          _buildInputField(('280').toString(), 280),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('380').toString(), 380),
                          _buildInputField(('345').toString(), 345),
                          _buildInputField(('256').toString(), 256),
                          _buildInputField(('257').toString(), 257),
                          _buildInputField(('267').toString(), 267),
                          _buildInputField(('268').toString(), 268),
                          _buildInputField(('340').toString(), 340),
                          _buildInputField(('350').toString(), 350),
                          _buildInputField(('360').toString(), 360),
                          _buildInputField(('370').toString(), 370),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('470').toString(), 470),
                          _buildInputField(('390').toString(), 390),
                          _buildInputField(('346').toString(), 346),
                          _buildInputField(('347').toString(), 347),
                          _buildInputField(('348').toString(), 348),
                          _buildInputField(('349').toString(), 349),
                          _buildInputField(('359').toString(), 359),
                          _buildInputField(('369').toString(), 369),
                          _buildInputField(('379').toString(), 379),
                          _buildInputField(('389').toString(), 389),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('489').toString(), 489),
                          _buildInputField(('480').toString(), 480),
                          _buildInputField(('490').toString(), 490),
                          _buildInputField(('356').toString(), 356),
                          _buildInputField(('357').toString(), 357),
                          _buildInputField(('358').toString(), 358),
                          _buildInputField(('368').toString(), 368),
                          _buildInputField(('468').toString(), 468),
                          _buildInputField(('450').toString(), 450),
                          _buildInputField(('460').toString(), 460),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('560').toString(), 560),
                          _buildInputField(('570').toString(), 570),
                          _buildInputField(('580').toString(), 580),
                          _buildInputField(('590').toString(), 590),
                          _buildInputField(('456').toString(), 456),
                          _buildInputField(('367').toString(), 367),
                          _buildInputField(('458').toString(), 458),
                          _buildInputField(('378').toString(), 378),
                          _buildInputField(('469').toString(), 469),
                          _buildInputField(('479').toString(), 479),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('579').toString(), 579),
                          _buildInputField(('589').toString(), 589),
                          _buildInputField(('670').toString(), 670),
                          _buildInputField(('680').toString(), 680),
                          _buildInputField(('690').toString(), 690),
                          _buildInputField(('457').toString(), 457),
                          _buildInputField(('467').toString(), 467),
                          _buildInputField(('459').toString(), 459),
                          _buildInputField(('478').toString(), 478),
                          _buildInputField(('569').toString(), 569),
                        ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInputField(('678').toString(), 678),
                          _buildInputField(('679').toString(), 679),
                          _buildInputField(('689').toString(), 689),
                          _buildInputField(('789').toString(), 789),
                          _buildInputField(('780').toString(), 780),
                          _buildInputField(('790').toString(), 790),
                          _buildInputField(('890').toString(), 890),
                          _buildInputField(('567').toString(), 567),
                          _buildInputField(('568').toString(), 568),
                          _buildInputField(('578').toString(), 578),
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
        const SizedBox(height: 3),
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
            style: const TextStyle(color: Colors.black, fontSize: 8),
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
          height: 30,
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
