import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/models/today_market_model.dart';

import '../provider/user_provider.dart';
import '../screens/bid/chart_screen.dart';
import '../screens/game/game_category_screen.dart';
import 'error_snackbar_widget.dart';

class ItemLoop extends StatelessWidget {
  const ItemLoop({
    super.key,
    required this.market,
  });

  final MarketList market;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    void showPopup(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      "Choose Session",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        if (market.timeLeftOpenTime != 'TIME OVER')
                          if (market.timeLeftOpenTime != 'RESULT DECLARED')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                if (market.timeLeftOpenTime ==
                                    'RESULT DECLARED') {
                                  Navigator.pop(context);
                                  showCoolErrorSnackbar(
                                      context, 'MARKET SESSION IS CLOSED');
                                  return;
                                }
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GameCategoryScreen(
                                      market: market,
                                      isOpen: 'OPEN',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'OPEN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GameCategoryScreen(
                                  market: market,
                                  isOpen: 'CLOSE',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'CLOSE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 69, 1, 255), width: 2)),
        child: Column(
          children: [
            if (userProvider.user.onWallet != '0')
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.red,
                      child: Text(
                        market.isHoliday != '0'
                            ? 'TODAY IS HOLIDAY'
                            : market.timeLeftOpenTime,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.green,
                      child: Text(
                        market.isHoliday != '0'
                            ? 'TODAY IS HOLIDAY'
                            : market.timeLeftCloseTime,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(22),
              child: Row(
                mainAxisAlignment: userProvider.user.onWallet != '0'
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChartScreen(
                            marketId: market.id,
                            marketName: market.marketName,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/gifs/bar_icon.gif',
                          height: 55,
                        ),
                        const Text(
                          'CHART',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        market.marketName,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 228, 114, 188),
                          fontSize: 23,
                        ),
                      ),
                      Text(
                        market.number,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                  if (userProvider.user.onWallet != '0')
                    InkWell(
                      onTap: () {
                        if (market.isOpen) {
                          showPopup(context);
                        } else {
                          showCoolErrorSnackbar(context, 'Market is closed');
                        }
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            market.isOpen
                                ? 'assets/images/gifs/play_icon.gif'
                                : 'assets/images/gifs/close_icon.gif',
                            height: 55,
                          ),
                          Text(
                            market.isOpen ? 'PLAY' : 'CLOSED',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.green,
                    child: Text(
                      'OPEN TIME: ${market.openTime}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.red,
                    child: Text(
                      'CLOSE TIME: ${market.closeTime}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
