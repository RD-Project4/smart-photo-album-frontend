import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/search/SearchCubit.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchCubit cubit = context.read<SearchCubit>();
    print(cubit.state.searchResult);

    return Container();
  }
}
