const Map<String, String> content = {//todo: redefine model
  'model': '''
/// Abstract class for Response models
abstract class BlocDataModel {
  @protected
  Map<String, dynamic> json;
ľ 
  /// DataModel initialization from JSON map
  DataModel.fromJson(this.json);

  /// Covert the object into JSON map
  Map<String, dynamic> toJson();
}
''',
  'dataLayer': 'core/dataLayer/base_data_manager.dart'
};
