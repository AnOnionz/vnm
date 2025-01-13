import 'package:flutter/material.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fuzzy/fuzzy.dart';

import 'search_text_field.dart';

class SliverSearchWidget<T> extends StatelessWidget {
  final String label;
  final List<T> data;
  final String Function(T object) searchBy;
  final Function(List<T> newData) onSearched;
  const SliverSearchWidget(
      {super.key,
      this.label = 'Nhập nội dung tìm kiếm',
      required this.data,
      required this.searchBy,
      required this.onSearched});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: SizedBox.shrink(),
      leadingWidth: 0,
      floating: true,
      bottom:
          PreferredSize(preferredSize: Size(0, 12.h), child: SizedBox.shrink()),
      surfaceTintColor: AppColors.aliceBlue,
      title: SearchTextField(
        label: label,
        itemBuilder: (context, value) => SizedBox.shrink(),
        suggestionsCallback: (search) {
          if (search.isEmptyOrNull) {
            onSearched(data);
            return data;
          }
          final fuse = Fuzzy(data.map((e) => searchBy(e)).toList(),
              options: FuzzyOptions(
                tokenize: true,
                threshold: 0.1,
              ));

          final result = fuse.search(search).map((suggest) {
            return data
                .firstWhere((element) => searchBy(element) == suggest.item);
          }).toList();

          onSearched(result);
          return result;
        },
        onSelected: (value) => null,
      ),
    );
  }
}
