import 'base_clipping_method_strategy.dart';

class GomoriFirstStrategy extends BaseClippingMethodStrategy {
  const GomoriFirstStrategy();

  @override
  bool get requiresAllIntegers => true;
}