import 'package:flutter/material.dart';

import '../utils/date_time_util.dart';

class MonthListTile extends StatelessWidget {
  final int year;

  const MonthListTile({
    required this.year,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Report for $year, cash flow is \$\$\$",
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 15),
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 12, // 12 months
                  itemBuilder: ((context, monthIndex) {
                    const int cashFlow = 2000;
                    const String sign = cashFlow >= 0 ? "" : "-";
                    return MonthTileWidget(
                        cashFlow: cashFlow,
                        month: DateTimeUtil.months[monthIndex],
                        sign: sign);
                  })),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthTileWidget extends StatelessWidget {
  const MonthTileWidget({
    Key? key,
    required this.cashFlow,
    required this.month,
    required this.sign,
  }) : super(key: key);

  final int cashFlow;
  final String month;
  final String sign;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 130,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: cashFlow >= 0
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
      ),
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              month,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text("Cash flow: $sign$cashFlow")
          ],
        ),
      ),
    );
  }
}
