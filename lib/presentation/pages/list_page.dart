import 'package:bicycle_rental_system/application/config/config.dart';
import 'package:bicycle_rental_system/domain/time_tag.dart';
import 'package:bicycle_rental_system/presentation/theme/color_theme.dart';
import 'package:bicycle_rental_system/presentation/theme/text_theme.dart';
import 'package:bicycle_rental_system/presentation/widgets/item_card.dart';
import 'package:bicycle_rental_system/presentation/widgets/time_tag_button.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<ListPage> {
  TimeTag timeTagState = TimeTag.hour;

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: Drawer(
          backgroundColor: MyTheme.lightBlue,
        ),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Padding(
                padding: const EdgeInsets.only(left: 100),
                child: boldText('BICYCLE RENTAL', Colors.white, 32)),
            backgroundColor: MyTheme.blue,
            elevation: 0),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: GridView.builder(
                      itemCount: 20,
                      padding: EdgeInsets.all(20 * (mWidth / 600)),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20 * (mWidth / 800), //ボックス左右間のスペース
                        mainAxisSpacing: 20 * (mWidth / 800), //ボックス上下間のスペース
                        crossAxisCount: mWidth > BREAKPOINT2
                            ? 3
                            : (mWidth > BREAKPOINT1 ? 2 : 1), //横に並べるボックス数
                      ),
                      itemBuilder: (context, index) {
                        return ItemCard(
                          index: index,
                          timeTagState: timeTagState,
                        );
                      },
                    ),
                  ),
// time tag
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: 150,
                      decoration: BoxDecoration(
                        color: MyTheme.celeste,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 1.5,
                            blurRadius: 4,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        timeTagState = TimeTag.month;
                                      });
                                    },
                                    child: timeTagButton(TimeTag.month,
                                        timeTagState == TimeTag.month)),
                              ],
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    timeTagState = TimeTag.day;
                                  });
                                },
                                child: timeTagButton(
                                    TimeTag.day, timeTagState == TimeTag.day)),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    timeTagState = TimeTag.hour;
                                  });
                                },
                                child: timeTagButton(TimeTag.hour,
                                    timeTagState == TimeTag.hour)),
                          ]),
                    ),
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 350),
              width: mWidth * 0.3,
              color: MyTheme.lightBlue,
              child: Column(
                children: [Text('aaaaaaaaaaa')],
              ),
            )
          ],
        ));
  }
}
