import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/book_repository.dart';

List<SingleChildWidget> get providers => [
      ChangeNotifierProvider(create: (context) => BookRepository()),
    ];
