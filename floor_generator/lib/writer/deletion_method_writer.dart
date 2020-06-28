import 'package:code_builder/code_builder.dart';
import 'package:floor_generator/misc/annotations.dart';
import 'package:floor_generator/misc/change_method_writer_helper.dart';
import 'package:floor_generator/misc/string_utils.dart';
import 'package:floor_generator/value_object/deletion_method.dart';
import 'package:floor_generator/writer/writer.dart';

class DeletionMethodWriter implements Writer {
  final DeletionMethod _method;
  final ChangeMethodWriterHelper _helper;

  DeletionMethodWriter(
    final DeletionMethod method, [
    final ChangeMethodWriterHelper helper,
  ])  : assert(method != null),
        _method = method,
        _helper = helper ?? ChangeMethodWriterHelper(method);

  @nonNull
  @override
  Method write() {
    final methodBuilder = MethodBuilder()..body = Code(_generateMethodBody());
    _helper.addChangeMethodSignature(methodBuilder);
    return methodBuilder.build();
  }

  @nonNull
  String _generateMethodBody() {
    final entityClassName =
        _method.entity.classElement.displayName.decapitalize();
    final methodSignatureParameterName = _method.parameterElement.name;

    if (_method.flattenedReturnType.isVoid) {
      return _generateVoidReturnMethodBody(
        methodSignatureParameterName,
        entityClassName,
      );
    } else {
      // if not void then must be int return
      return _generateIntReturnMethodBody(
        methodSignatureParameterName,
        entityClassName,
      );
    }
  }

  @nonNull
  String _generateVoidReturnMethodBody(
    final String methodSignatureParameterName,
    final String entityClassName,
  ) {
    if (_method.changesMultipleItems) {
      return 'await ${entityClassName}DeletionAdapter.deleteList($methodSignatureParameterName);';
    } else {
      return 'await ${entityClassName}DeletionAdapter.delete($methodSignatureParameterName);';
    }
  }

  @nonNull
  String _generateIntReturnMethodBody(
    final String methodSignatureParameterName,
    final String entityClassName,
  ) {
    if (_method.changesMultipleItems) {
      return 'return ${entityClassName}DeletionAdapter.deleteListAndReturnChangedRows($methodSignatureParameterName);';
    } else {
      return 'return ${entityClassName}DeletionAdapter.deleteAndReturnChangedRows($methodSignatureParameterName);';
    }
  }
}
