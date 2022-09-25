// import 'package:admin/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../cubit/table_data_source.dart';
import '../models/pager.dart';

class PaginationPages extends StatelessWidget {
  final TableDataSource source;
  const PaginationPages({Key? key, required this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return ValueListenableBuilder<Pager?>(
        valueListenable: source.pager,
        builder: (context, s, w) {
          // print('mmmmmmmmmm:  ${s?.total}, ${s?.pages} ${s?.page}');
          if (s == null || s.pages <= 1) {
            return  const SizedBox();
          }
          // var pages = List.generate(s.pages, (index) => index +1);
          //
          var list = <Widget>[
            for (var i = 1; i <= s.pages; i++)
              PaginationButton(
                display: Text('$i',
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: i == s.page ? Colors.white : Colors.black)),
                onPressed: () => source.toPage(i),
                isActive: i == s.page,
              )
          ];
          if (list.length > 8) {
            Widget selected = const SizedBox();
            if (s.page > 4 && s.page <= (list.length - 4)) {
              selected = PaginationButton(
                display: Text('${s.page}',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: Colors.white)),
                onPressed: () => source.toPage(s.page),
                isActive: true,
              );
            }
            list.replaceRange(4, (list.length - 4), [
              PaginationButton(
                  display: const Icon(Icons.more_horiz, size: 12),
                  onPressed: () {}),
              selected
            ]);
            // list = list
            //     .where((e) => (e.keys.first ~/ 10) == 0 || (e.keys.first) < 5)
            //     .toList();
          }
          return Row(
            children: [ 
              if (s.page > 1)
                PaginationButton(
                    display: const Icon(Icons.arrow_back_ios_new, size: 12),
                    onPressed: source.prev),
              ...list,
              if (s.page < s.pages)
                PaginationButton(
                    display: const Icon(Icons.arrow_forward_ios, size: 12),
                    onPressed: source.next),
            ],
          );
        });
  }
}

class PaginationButton extends StatelessWidget {
  final Widget display;
  final Function() onPressed;
  final bool isActive;
  const PaginationButton(
      {Key? key,
      required this.display,
      required this.onPressed,
      this.isActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: isActive ? Theme.of(context).primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: .2, color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(2)),
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: 30,
              child: Center(
                child:
                    Padding(padding: const EdgeInsets.all(4.0), child: display),
              ),
            ),
          ),
        ),
      );
}
