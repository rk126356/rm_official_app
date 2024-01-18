import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';
import 'package:rm_official_app/widgets/heading_title_widget.dart';

import '../../controllers/fetch_chart_data_controller.dart';
import '../../models/chart_model.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({
    Key? key,
    required this.marketId,
    required this.marketName,
  }) : super(key: key);

  final String marketId;
  final String marketName;

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<ChartItem> chartData = [];
  bool _isLoading = false;
  String selectedYear = '2024';

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<ChartItem> data =
          await fetchChartData(widget.marketId, selectedYear);
      setState(() {
        chartData = data;
      });
    } catch (e) {
      print('Error fetching chart data: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redType,
        title: const Text(
          'Chart Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const HeadingLogo(),
                  const SizedBox(
                    height: 22,
                  ),
                  HeadingTitle(title: widget.marketName),
                  const SizedBox(
                    height: 22,
                  ),
                  _buildYearPicker(),
                  const SizedBox(
                    height: 22,
                  ),
                  for (int i = 0; i < chartData.length; i++)
                    _buildChartList(chartData[i], i),
                  const SizedBox(
                    height: 22,
                  ),
                  const BottomContact()
                ],
              ),
            ),
    );
  }

  Widget _buildChartList(ChartItem chartItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Week ${index + 1}'),
              subtitle: Text('${chartItem.startDate} - ${chartItem.endDate}'),
            ),
            SizedBox(
              height: 90.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chartItem.results.length,
                itemBuilder: (context, i) =>
                    _buildResultList(chartItem.results[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultList(Result result) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.8, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: AppColors.blueType)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              color: const Color.fromARGB(255, 233, 30, 216),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  result.day,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < result.openPanna.length; i++)
                        Text(
                          result.openPanna[i],
                          style: const TextStyle(fontSize: 10),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    result.jodi,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < result.closePanna.length; i++)
                        Text(
                          result.closePanna[i],
                          style: const TextStyle(fontSize: 10),
                        )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildYearPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: selectedYear,
          items: List.generate(
            DateTime.now().year - 2011,
            (index) => DropdownMenuItem<String>(
              value: (2012 + index).toString(),
              child: Text((2012 + index).toString()),
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedYear = value!;
            });
          },
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: () {
            _fetchChartData();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
