import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../common/styles.dart';
import '../data/model/news_result.dart';
import '../utils/date_time_helper.dart';

class CustomItemNews extends StatelessWidget {
  final News news;
  const CustomItemNews({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: textColorWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            news.title,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: colorBlack,
                ),
          ),
          Row(
            children: [
              AutoSizeText(
                "${news.author} - ${DateTimeHelper().dateFormat(news.date)}",
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: textFieldColorGrey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ],
          ),
          AutoSizeText(
            news.content,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: colorBlack,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
