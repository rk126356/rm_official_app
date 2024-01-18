import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/models/bid_history_model.dart';

import 'bid_history_loop_with_delete.dart';

class AllBidsWithDelete extends StatelessWidget {
  const AllBidsWithDelete({
    Key? key,
    required this.histories,
    required this.name,
  }) : super(key: key);

  final List<BidHistory> histories;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              leading: const Center(child: Text('')),
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              title: Text(name),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < histories.length; i++)
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: BorderDirectional(
                                top: BorderSide(
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                            child: BidHistoryLoopDelete(
                              history: histories[i],
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
