
import 'package:flutter/material.dart';
import 'package:trackexx/json/budget_json.dart';
import 'package:trackexx/json/day_month.dart';
import 'package:trackexx/theme/color.dart';
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeDay = 3;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                 const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Budget",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                       Row(
                        children: [
                           Icon(
                            Icons.add,
                            size: 25,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.search)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(months.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              activeDay = index;
                            });
                          },
                          child: SizedBox(
                            width: (MediaQuery.of(context).size.width - 40) / 6,
                            child: Column(
                              children: [
                                Text(
                                  months[index]['label'],
                                  style: const TextStyle(fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: activeDay == index
                                          ? primary
                                          : black.withOpacity(0.02),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: activeDay == index
                                              ? primary
                                              : black.withOpacity(0.1))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 7, bottom: 7),
                                    child: Text(
                                      months[index]['day'],
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: activeDay == index
                                              ? white
                                              : black),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                children: List.generate(budgetjson.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, bottom: 25, top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budgetjson[index]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: const Color(0xff67727d).withOpacity(0.6)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  budgetjson[index]['price'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    budgetjson[index]['label_percentage'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color:
                                            const Color(0xff67727d).withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "\$5000.00",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: const Color(0xff67727d).withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Stack(
                          children: [
                            Container(
                              width: (size.width - 40),
                              height: 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xff67727d).withOpacity(0.1)),
                            ),
                            Container(
                              width: (size.width - 40) *
                                  budgetjson[index]['percentage'],
                              height: 4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: budgetjson[index]['color']),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            })),
          )
        ],
      ),
    );
  }
}
