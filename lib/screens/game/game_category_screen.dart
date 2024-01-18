import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/models/today_market_model.dart';
import 'package:rm_official_app/screens/game/inside_double_panna_screen.dart';
import 'package:rm_official_app/screens/game/inside_dp_motor_panna_screen.dart';
import 'package:rm_official_app/screens/game/inside_family_jodi_screen.dart';
import 'package:rm_official_app/screens/game/inside_jodi_sdreen.dart';
import 'package:rm_official_app/screens/game/inside_family_panna.dart';
import 'package:rm_official_app/screens/game/inside_sangam_screen.dart';
import 'package:rm_official_app/screens/game/inside_single_akda_screen.dart';
import 'package:rm_official_app/screens/game/inside_single_panna_screen.dart';
import 'package:rm_official_app/screens/game/inside_sp_motor_panna_screen.dart';
import 'package:rm_official_app/screens/game/inside_triple_panna_screen.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';

import 'inside_cycle_panna.dart';

class GameCategoryScreen extends StatefulWidget {
  const GameCategoryScreen(
      {super.key, required this.market, required this.isOpen});

  @override
  State<GameCategoryScreen> createState() => _GameCategoryScreenState();
  final MarketList market;
  final String isOpen;
}

class _GameCategoryScreenState extends State<GameCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.redType,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'CHOOSE CATEGORY',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const HeadingLogo(),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InsidePlayScreen(
                        title: 'SINGLE DIGIT',
                        isOpen: widget.isOpen,
                        market: widget.market,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/categories/single_akda.jpg',
                  width: 120,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.isOpen == "OPEN")
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InsideJodiScreen(
                              title: 'JODI',
                              isOpen: widget.isOpen,
                              market: widget.market,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/categories/jodi.jpg',
                        width: 120,
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideSinglePanna(
                            title: 'SINGLE PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/single_panna.jpg',
                      width: 120,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideDoublePanna(
                            title: 'DOUBLE PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/double_panna.jpg',
                      width: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideTriplePanna(
                            title: 'TRIPAL PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/triple_panna.jpg',
                      width: 120,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideFamilyPanna(
                            title: 'FAMILY PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/family_panna.jpg',
                      width: 120,
                    ),
                  ),
                  if (widget.isOpen == "OPEN")
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InsideFamilyJodi(
                              title: 'FAMILY JODI',
                              isOpen: widget.isOpen,
                              market: widget.market,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/categories/family_jodi.jpg',
                        width: 120,
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideSPMototrPanna(
                            title: 'SP MOTOR PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/sp_motor_panna.jpg',
                      width: 120,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideDPMotorPanna(
                            title: 'DP MOTOR PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/dp_motor_panna.jpg',
                      width: 120,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InsideCyclePannaScreen(
                            title: 'CYCLE PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/cycle_panna.jpg',
                      width: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/categories/sp_dp_tp_all_panna.jpg',
                    width: 120,
                  ),
                  if (widget.isOpen == "OPEN")
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InsideSangamScreen(
                              title: 'HALF SANGAM',
                              isOpen: widget.isOpen,
                              market: widget.market,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/categories/half_sangam.jpg',
                        width: 120,
                      ),
                    ),
                  if (widget.isOpen == "OPEN")
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InsideSangamScreen(
                              title: 'FULL SANGAM',
                              isOpen: widget.isOpen,
                              market: widget.market,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/categories/full_sangam.jpg',
                        width: 120,
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              const BottomContact()
            ],
          ),
        ),
      ),
    );
  }
}
