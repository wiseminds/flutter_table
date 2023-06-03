// import 'package:desktop/desktop.dart';
import 'package:flutter/material.dart';

import '../cubit/table_data_source.dart';

class Perpage extends StatelessWidget {
  // final Function(int) onChanged;
  final TableDataSource source;
  const Perpage({Key? key, required this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: source.perPage,
        builder: (context, s, w) {
          return Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('show',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith()),
            ),
            Material(
              // color: Colors.white,
              shape: const RoundedRectangleBorder(side: BorderSide(width: .1)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                  child: DropdownButton<int>(
                    isExpanded: false,
                    onChanged: (val) {
                      source.setPerPage(val ?? source.perPage.value);
                    },
                    icon: const Icon(Icons.unfold_more, size: 15),
                    value: s,
                    underline: const SizedBox(),
                    isDense: true,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 10),
                    items: [
                      DropdownMenuItem(
                          child: Text('10',
                              style: Theme.of(context).textTheme.bodySmall),
                          value: 10),
                      DropdownMenuItem(
                          child: Text('20',
                              style: Theme.of(context).textTheme.bodySmall),
                          value: 20),
                      DropdownMenuItem(
                          child: Text('50',
                              style: Theme.of(context).textTheme.bodySmall),
                          value: 50),
                      DropdownMenuItem(
                          child: Text('100',
                              style: Theme.of(context).textTheme.bodySmall),
                          value: 100),
                      // DropdownMenuItem(child: Text('200'), value: 200),
                      // DropdownMenuItem(child: Text('500'), value: 500),
                      // DropdownMenuItem(child: Text('1000'), value: 1000),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('entities',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith()),
            ),
          ]);
        });
  }
}
