// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';

import '../../models/polls_model.dart';
import '../../provider/user_provider.dart';

class InsidePollsScreen extends StatefulWidget {
  const InsidePollsScreen(
      {Key? key, required this.status, required this.name, this.revealed})
      : super(key: key);

  final String status;
  final String name;
  final bool? revealed;

  @override
  State<InsidePollsScreen> createState() => _InsidePollsScreenState();
}

class _InsidePollsScreenState extends State<InsidePollsScreen> {
  late PollModel poll;
  int? selectedOption;
  bool isUserVoted = false;
  bool _isLoading = false;
  bool _isReveled = false;

  @override
  void initState() {
    super.initState();
    fetchPoll();
    hasUserVoted();
    if (widget.revealed != null) {
      setState(() {
        _isReveled = widget.revealed!;
      });
    }
  }

  Future<void> fetchPoll() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('polls')
          .where('name', isEqualTo: widget.name)
          .where('status', isEqualTo: widget.status)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        poll = PollModel.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        setState(() {});
      } else {
        showCoolErrorSnackbar(context, 'Check your internet connection');
      }
    } catch (error) {
      showCoolErrorSnackbar(context, 'Check your internet connection');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> hasUserVoted() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('polls')
          .where('name', isEqualTo: widget.name)
          .where('status', isEqualTo: widget.status)
          .get();

      if (doc.docs.isNotEmpty) {
        final pollData = doc.docs.first.data();
        List<String> voters = List<String>.from(pollData['voters'] ?? []);

        setState(() {
          isUserVoted = voters.contains(userProvider.user.mobile);
        });
      } else {
        setState(() {
          isUserVoted = false;
        });
      }
    } catch (error) {
      showCoolErrorSnackbar(context, 'Check your internet connection');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> submitPoll() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('polls')
          .where('name', isEqualTo: widget.name)
          .where('status', isEqualTo: widget.status)
          .get();

      if (doc.docs.isNotEmpty) {
        final pollDocRef = doc.docs.first.reference;
        final pollData = doc.docs.first.data();
        List<String> voters = List<String>.from(pollData['voters'] ?? []);

        if (!voters.contains(userProvider.user.mobile) &&
            selectedOption != null) {
          Map<String, dynamic> optionsUpdate = {
            'options.$selectedOption': FieldValue.increment(1),
            'voters': FieldValue.arrayUnion([userProvider.user.mobile]),
          };

          await pollDocRef.update(optionsUpdate);
        } else if (voters.contains(userProvider.user.mobile)) {
          print('User has already voted for this poll.');
        } else {
          print('Please select an option before submitting.');
        }
      } else {
        print('Poll not found');
      }
    } catch (error) {
      print('Error submitting vote: $error');
    }
    fetchPoll();
    hasUserVoted();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.redType,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Poll: ${widget.name} - ${widget.status.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isReveled
                    ? buildPollResults()
                    : isUserVoted
                        ? buildPollResults()
                        : buildPollOptions(),
          ],
        ),
      ), // Display poll options
    );
  }

  Widget buildPollOptions() {
    return poll != null
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Poll Name: ${poll.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Status: ${poll.status.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Poll Options:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List<int>.generate(
                              10, (index) => index == 9 ? 0 : index + 1)
                          .map((entry) {
                        return RadioListTile<int>(
                          title: Text(
                            '$entry',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          value: entry,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: submitPoll,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget buildPollResults() {
    return poll != null
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Poll Name: ${poll.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Status: ${poll.status.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Poll Results:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: poll.options.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${entry.key}:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: LinearProgressIndicator(
                                  value: totalVotes() == 0
                                      ? 0
                                      : entry.value / totalVotes(),
                                  minHeight: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  totalVotes() == 0
                                      ? '0%'
                                      : '${(entry.value / totalVotes() * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  int totalVotes() {
    // Calculate the total number of votes for all options
    int total = 0;
    for (var entry in poll.options.entries) {
      total += entry.value;
    }
    return total;
  }
}
