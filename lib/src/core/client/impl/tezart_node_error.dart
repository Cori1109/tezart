import 'package:tezart/src/common/exceptions/common_exception.dart';
import 'package:tezart/src/common/utils/enum_util.dart';
import 'package:tezart/src/core/rpc/rpc_interface.dart';

enum TezartNodeErrorTypes {
  already_revealed_key,
  unhandled,
}

class TezartNodeError extends CommonException {
  final TezartHttpError cause;
  final TezartNodeErrorTypes _inputType;
  final String _inputMessage;

  final staticErrorsMessages = {
    TezartNodeErrorTypes.already_revealed_key: "You're trying to reveal an already revealed key.",
    TezartNodeErrorTypes.unhandled: 'Unhandled error',
  };

  TezartNodeError.fromHttpError(this.cause)
      : _inputType = null,
        _inputMessage = null;

  TezartNodeErrorTypes get type => _inputType ?? _computedType;

  @override
  String get message => _inputMessage ?? _computedMessage;

  TezartNodeErrorTypes get _computedType {
    if (RegExp(r'previously_revealed_key').hasMatch(errorId)) return TezartNodeErrorTypes.already_revealed_key;

    return TezartNodeErrorTypes.unhandled;
  }

  // TODO: what to do when there is multiple errors ?
  String get errorId => cause?.responseBody?.first['id'];

  @override
  String get key => EnumUtil.enumToString(type);

  String get _computedMessage => staticErrorsMessages[type];

  @override
  TezartHttpError get originalException => cause;
}
