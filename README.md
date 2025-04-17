# Base32768
Base32768 is a binary encoding optimised for UTF-16-encoded text. 

This Godot plugin is an implementation of an already existing javascript plugin in gdscript. 
Link to the original repository : https://github.com/qntm/base32768

## Usage

```gdscript
var toTranslate = "testma"

toTranslate.to_utf8_buffer()
# [116, 101, 115, 116, 109, 97]

var encoded = Base32768.encode(toTranslate.to_utf8_buffer())
# "悒茽㇌Ɵ"

var decoded = Base32768.decode(encoded)
# [116, 101, 115, 116, 109, 97, 0, 0]

decoded.get_string_from_utf8()
# "tesma"
```
```gdscript
var toTranslate = { "test": "testma", "yes": "no" }

var encoded = Base32768.Oencode(toTranslate)
# "揥☽Ⰾ嶢㠑ݩ輪駔崐滫ᄤ䷶凹⚈暤铏㝅䖿"

var decoded = Base32768.Odecode(encoded)
# { "test": "testma", "yes": "no" }
```