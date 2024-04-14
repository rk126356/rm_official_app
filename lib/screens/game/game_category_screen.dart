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
import 'package:rm_official_app/screens/game/inside_sp_dp_tp_all_panna_screen.dart';
import 'package:rm_official_app/screens/game/inside_sp_motor_panna_screen.dart';
import 'package:rm_official_app/screens/game/inside_triple_panna_screen.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';

import '../../widgets/app_bar_widget.dart';
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
      appBar: const AppBarWidget(
        title: 'CHOOSE CATEGORY',
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
                  'assets/images/categories/icons-10.png',
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
                        'assets/images/categories/icons-11.png',
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
                      'assets/images/categories/icons-12.png',
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
                      'assets/images/categories/icons-13.png',
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
                      'assets/images/categories/icons-07.png',
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
                      'assets/images/categories/icons-08.png',
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
                        'assets/images/categories/icons-09.png',
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
                      'assets/images/categories/icons-04.png',
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
                      'assets/images/categories/icons-05.png',
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
                      'assets/images/categories/icons-06.png',
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
                          builder: (context) => InsideSPDPTPAllPannaScreen(
                            title: 'SP-DP-TP-ALL PANNA',
                            isOpen: widget.isOpen,
                            market: widget.market,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/categories/icons-03.png',
                      width: 120,
                    ),
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
                        'assets/images/categories/icons-02.png',
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
                        'assets/images/categories/icons-01.png',
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
